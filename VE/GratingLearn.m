classdef GratingLearn <vslearning
    
    
    properties
        CGF; % contgain (dff)
        CGA; % contgain(nhat)
        CGN; % contgain(dffn)
        btwin;
        rtwin;
        twin;
    end
    
    methods(Access=public)
        function self = GratingLearn(animal_id,ses_ids,stmgrp,twin, btwin, rtwin)
            % twin: time window for entire response time course
            % btwin: time window for response baseline 
            % rtwin: time window for visual response
           
            
            self = self@vslearning(animal_id,ses_ids,stmgrp);
            if nargin<4,
                self.btwin =[-0.5 -0.1];
               
                [stimdur,blankdur]=fetchn(vs_spkray.Trial&self.vs{1},...
                    'stim_dur','blank_dur');
                self.rtwin =[0 stimdur(1)];
                self.twin =[-0.5 max(stimdur+blankdur)];
            else
                self.twin =twin;
                self.rtwin =rtwin;
                self.btwin = btwin;
                
            end
            
            

        end
        function [self,binx,rinx] = get_contgain(self,outframes)
            % [self,binx,rinx] = get_contgain(self, outframes)
            % outframes : not used for calculation e.g., high motion
            nses = length(self.session_ids);
            if nargin==1
                outframes = cell(1,nses);            
                for i = 1:nses
                    nscan = length(self.scan_ids{i});
                    outframes{i}= cell(1,nscan);
                end
            end
            [self.CGF,self.trialinx, binx,rinx ] = ...
                get_contgain0(self, 'dff', self.twin,outframes,self.btwin,self.rtwin);
            self.CGA = get_contgain0(self, 'nhat', self.twin);
            self.CGN = get_contgain0(self, 'dffn', self.twin);
        end

        
        function [self, celln]= select_cell_vresp(self, rthr,binx,rinx)
            % function [self,  celln]= select_cell_vresp(self, dtype,twin, btwin, rtwin, rthr)
             % rthr: response modulation threshold

            if isempty(rthr)                
                rthr =0.05; % response threshold for visual response
            end
            
            CGA1 = self.CGA;
            CGF1 = self.CGF;
            
            % select cell inx;
            nses = length(CGA1);
            celln = cell(1, nses);
            self.cellinx = cell(1, nses);
            for k = 1 : nses
                nscan = length(CGA1{k});
                

                celln{k} = NaN(1,nscan);
                self.cellinx{k} = cell(1,nscan);
                
               for i =1 : nscan
                    % select cell based on contrast response                  
                    cinx1 = CGF1{k}(i).select_cell_resp(binx{k}{i}, rinx{k}{i}, rthr);
                    cinx2 = CGA1{k}(i).select_cell_vrespstat(binx{k}{i}, rinx{k}{i});

                    cinx2(isnan(cinx2))=0;
                    self.cellinx{k}{i} = find(cinx1 & cinx2);
                    
                    dF = CGF1{k}(i).X;
                    celln{k}(i) = length(find(squeeze(sum(sum(dF,2),1))>0));
                end
            end
%             self.CGF = CGF1;
%             self.CGA = CGA1; 
%             self.CGN = get_contgain(self, 'dffn', self.twin);
        end
        
        
        
%         function [tun,etun,ori]=get_oritun(self,dtype,cinx,contrast,bavg)
%             %function get_oritun(self,dtype,cinx,contrast,bavg)
%             % get ORI tuning from cinx(cell idx; default=self.cell_common)
%             % if isemtpy(cinx), get ori only within selected cell pool
%             % i.e., outcell = setdiff(cinx,self.cellinx{ises}{iscan});
%             
%             if isempty(cinx)
%                 cinx = self.cell_common;
%                 bwithincommon = true;
%                 cinx0 = zeros(max(cinx),1);
%                 cinx0(cinx) = 1:length(cinx);
%             end
%             
%             CG = self.(dtype);
%             nses = length(CG);
%             tun = cell(1,nses);
%             etun = cell(1,nses);
%             
%             for i = 1: nses
%                 nscan = length(CG{i});
%                 tun{i} = cell(1,nscan);
%                 etun{i} = cell(1,nscan);
%                 for j = 1: nscan
%                    
%                    [y,  ey, ori]=GratingLearn.get_oritun1(CG{i}(j),cinx, contrast,false);
%                    outcell=[];
%                    if bwithincommon
%                        out = setdiff(cinx,self.cellinx{i}{j});
%                        outcell = cinx0(out);                   
%                    end
%                    
%                    y(:,:,outcell)=NaN;
%                    ey(:,:,outcell)=NaN;
%                    
%                    if bavg
%                        tun{i}{j} = y;
%                        etun{i}{j}=ey;
%                    else
%                        tun{i}{j} = squeeze(mean(y,2));
%                        etun{i}{j}=squeeze(mean(ey,2));
%                    end
%                 end
%             end
%         
%         end
    end
        
    methods(Access=private)
        function [CG,trialinx, binx,rinx] = ...
                get_contgain0(self, dtype, twin,outframes,btwin,rtwin)
            %function [CG,binx,rinx] = 
            % get_contgain0(self, dtype, twin,outframes,btwin,rtwin)
            % btwin: baseline timewindow
            % rtwin: response timewindow
            % binx: baseline frameindx
            % rinx: response frame indx
            
            
            nses = length(self.tp);
            CG = cell(1,nses);
            
            binx = cell(1,nses);
            rinx = cell(1,nses);
            trialinx = cell(1,nses);
            if nargin<4, 
                outframes=cell(1,nses);
            end
            
            for k = 1 : nses
                
                tp1 = self.tp{k};
                sync1 = self.sync{k};
                vs1 = self.vs{k};
                scan_id = fetchn(tp1,'scan_id');
                nscan = length(scan_id);
                
                CG1 = contgain([]);
                CG1 = repmat(CG1,[1 nscan]);
                binx{k} = cell(1,nscan);
                rinx{k} = cell(1,nscan);
                trialinx{k} = cell(1,nscan);
                if nargin<4,
                    outframes{k}=cell(1,nscan);
                end
                for i =1 : nscan
                    scanstr = sprintf('scan_id=%d',scan_id(i));
                    tpi = tp1&scanstr;
                    
                   
                    tv = Trialvstim(tpi,sync1,dtype);
                    [X,~,info] = tv.sort_data_vstim(twin,outframes);
                    
                    % get baseline/response frame inx 
                    if nargout>2 && nargin>4
                        binx{k}{i}= get_rinx(tv,  twin,btwin);
                        rinx{k}{i} = get_rinx(tv, twin, rtwin);
                    end
                    
                    a = num2cell(info.seltrial);
                    key = cell2struct(a,{'trial_id'},1);

                
                    trcond= vs_spkray.Trial&tpi&key;
                    CG1(i) = contgain(X);
                    CG1(i) = CG1(i).set_evt(vs1,trcond);
                    trialinx{k}{i}=info.seltrial;
                end
                CG{k} = CG1;
            end
        end
    end
%     methods(Static)
%         
%         function [y,  ey, ori]= get_oritun1(ORI,cinx, contrast,bavg)
%             
%             [y, ey, ori] = ORI.get_oritun(cinx,'contrast',contrast);
%             y(y(:)==0) =NaN; 
%             ey(ey(:)==0) =NaN; 
% 
%             if bavg
%                 y = squeeze(nanmean(y,2));
%                 ey = squeeze(nanmean(ey,2));            
%             end
%         end
%         
%     end
    
  
    
end



