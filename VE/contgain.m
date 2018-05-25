classdef contgain 
    properties
        X; %  3d matrix (trial x frame x cell)
        evtname; % event name in order shown in columns of evtlut 
        evt; % real event for each trial (trial x conditions)
      


    end
    methods
        function self = contgain(X, evtname,evt)            
            
            
            if nargin<3
                evtname=[];
                evt=[];
            end
            self.X = X;
            self.evtname = evtname;
            self.evt = evt;
       
        end
        
        function self = set_evt(self,vs,trcond)
            
             [idx0,ucont, uori]= fetchn(vs,'cond_idx',...
                        'contrast','orientation');
            ucont = ucont(idx0);
            uori = uori(idx0);

            cond_idx = fetchn(trcond,'cond_idx');
            cont = ucont(cond_idx);
            ori = uori(cond_idx);

            self.evtname = {'contrast','orientation','cond_idx'};
            self.evt = [cont ori cond_idx];

        end
        
        function [mresp, seresp, ucond] = get_contrast_resp(self)
            %function mresp = get_contrast_resp(self)
            % mean visual response to one condition e.g.: contrast,
            % orientation, size...
            
            y1 = self.evt(:,strcmp(self.evtname,'contrast'));
            [mresp, seresp, ucond] = get_mean_ste(self.X,y1);             
        end
        
        
        function cinx = select_cell_vrespstat(self, baseframe, respframe)
            % function cinx = select_cell_vrespstat(self, baseframe, respframe, respthr)
            % select cells based on visual response 
            % by statistical testing between baseline and response
                
            X0 = squeeze(mean(self.X(:,baseframe,:),2));
            XP = squeeze(mean(self.X(:,respframe,:),2));
            cinx = ttest(XP,X0,'Tail','right');            
                        
        end
        
        function cinx = select_cell_contoristat(self, baseframe, respframe)
        % function cinx = select_cell_contoristat(self, baseframe, respframe, respthr)
            % select cells based on contrast-orientation response 
            % by statistical testing between baseline and response
        
            X0 = squeeze(mean(self.X(:,baseframe,:),2));
            XP = squeeze(mean(self.X(:,respframe,:),2));
            % X0 and XP : trial x cell
            condition ='cond_idx';
            y0 = get_respsort_evt(self, X0, condition);
            yP = get_respsort_evt(self, XP, condition);
            p = zeros(1,size(yP,3));
            for i = 1:size(yP,3)
                p(i) = kruskalwallis(yP(:,:,i)-y0(:,:,i),[],'off');
            end
            
            cinx = p<0.05;
        end
        
        function cinx = select_cell_resp(self, baseframe, respframe, respthr)
            % function cinx = select_cell_resp(self, baseframe, respframe, respthr)
            % select cells based on visual response 
            % by applying for absoulte mean response level with respthr
            
            if nargin<4
                respthr =0;
            end
                
            X0 = squeeze(mean(self.X(:,baseframe,:),2));
            XP = squeeze(mean(self.X(:,respframe,:),2));
            
            mX0 = mean(X0,1);
            mXP = mean(XP,1);
            cinx = mXP > mX0*(1+respthr);
            
        end
        
        
        function y = get_respsort_evt(self, X, condition)

            evt_cond = self.evt(:,strcmp(self.evtname,condition));
            uevt = unique(evt_cond);
            Xe = cell(length(uevt),1);
            maxtrial = 0;
            for i = 1: length(uevt)
                it  = find(evt_cond == uevt(i));
                Xe{i} = X(it,:);
                maxtrial = max(maxtrial, length(it));
            end

            y = NaN*ones(maxtrial,length(uevt), size(X,2));
            for i = 1: length(uevt)
                Nt = size(Xe{i},1);
                y(1:Nt,i,:)=Xe{i};
            end

        end
        
        function [mori, seori, ori] = get_oritun(self,inx_cell,varargin)
            % function [mori, seori, ori] = get_oritun(self,varargin)
            % get orientation tuning function for the given
            % condtion(varargin)
            % e.g., [mori, seori, ori] = get_oritun(self,'contrast',40)
            
            if nargin>2
                inx = get_trialinx(self,varargin);                
            else
                inx = 1: size(self.X,1);
            end
            %----- when cinx is larger than size(X,3)
            % because scans miss some cells
            sz = size(self.X);
            X0 = zeros(length(find(inx)),sz(2), length(inx_cell));
            K =find(inx_cell<sz(3));
            X0(:,:,K) =...
                self.X(inx,:,inx_cell(K));
            %---------------------------------
            X1 = X0;
            y1 = self.evt(inx,strcmp(self.evtname,'orientation'));
            [mori, seori, ori] = get_mean_ste(X1,y1); 

        end
        
    end
    
    
    methods(Access=private)        
        function inx = get_trialinx(self,varargin)
            % function inx = get_trialinx(self,varargin)
            % get trial inxdexs for given conditions
            % e.g., inx = get_trialinx(self,'contrast',100)
            
            if iscell(varargin) && length(varargin)==1
                varargin = varargin{1};
            end
            n = length(varargin)/2;
            for i = 1: n
                inx0 = strcmp(self.evtname,varargin{(i-1)*2+1});
                if i ==1,
                    inx = self.evt(:,inx0) == varargin{i*2};
                else
                    inx = inx& self.evt(:,inx0) == varargin{i*2};
                end
            end
        end
        
        
        
    end
       
    
end

function [my, ey, uy]= get_mean_ste(X,y)
% function [my, ey]= get_mean_ste(X,y)
% X: (trial x frame x cell)
% y: condtion of trial of X

    uy = unique(y);
    ne = length(uy);
    my = NaN*ones(ne, size(X,2), size(X,3));
    ey =my;
    for i = 1 : ne
        inx = find(y==uy(i));
        my(i,:,:)= mean(X(inx,:,:),1);
        ey(i,:,:) = std(X(inx,:,:),0,1)/sqrt(length(inx));    
    end
end



