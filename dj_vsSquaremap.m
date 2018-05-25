classdef dj_vsSquaremap <dj_vs
    % dj_vsSquaremap 
    %  insert visual stimulation file created from spikeray
    % into database (vs_spkray) via datajoint
    
    properties
        
    end
    
    methods
        function self = dj_vsSquaremap(header)
            self = self@dj_vs(header);
          
        end
        function self = gen_stimdat(self)
            %trial = self.stimparmat.trials;
            const = self.stimparmat.constants;
            
            % set stimpar structure
            self.stimpar.animal_id = self.animal_id;
            self.stimpar.session_id = self.session_id;
            self.stimpar.grp_id = self.grp_id;
            
%             self.stimpar.stim_durms = 1000*const.stimFrames/...
%                 const.refreshRate;
%             self.stimpar.blank_durms = 1000*const.blankFrames/...
%                 const.refreshRate;
            self.stimpar.stimcenter_x = const.stimCenterX;
            self.stimpar.stimcenter_y = const.stimCenterY;
            self.stimpar.dotsize = const.dotSize;
            self.stimpar.dotcolor = const.dotColor;
            [loc,~,idx] = self.get_dotloc;
            self.stimpar.dotloc_x = loc.x;
            self.stimpar.dotloc_y = loc.y;
            
            self.stimpar.dotloc_xi = [];
            self.stimpar.dotloc_yi = [];
            self.stimpar.dotloc_ci = [];
            
            %set additional info: condseq and cond_idx
            self.condseq ={'dotloc_x','dotloc_y','dotcolor'};
            self.cond_idx = idx;
           
        end
        
        function self = create_datstr(self)
            N = length(unique(self.cond_idx));
            parname = fieldnames(self.stimpar);
            npar = length(parname);
            kinds = self.condseq;            
            n = length(kinds);
          
            clear datstr
            for i= 1: npar                   
                if any(strcmp(kinds,parname{i}))
                    datstr.(parname{i}) = [];
                else
                    datstr.(parname{i}) = self.stimpar.(parname{i});
                end                
            end           
            datstr.cond_idx =[];
            datstr = repmat(datstr,[N 1]);
                            
            %idx = self.get_condidx(unique(self.cond_idx));   
            [~,idxi,idx] = self.get_dotloc;
            [cond_idx,idx2]= unique(idx);
            out = zeros(N,n);
            out1 = zeros(N,n);
            for i= 1: length(kinds)
                vals = self.stimpar.(kinds{i});                
                out(:,i)=vals(idxi(idx2,i))';
                out1(:,i) = idxi(idx2,i);
            end
            
            for k =1 : N
                for i= 1: n        
                    datstr(k).(kinds{i}) = out(k,i);                   
                end
                datstr(k).cond_idx = cond_idx(k);
                datstr(k).dotloc_xi = out1(k,1);
                datstr(k).dotloc_yi = out1(k,2);
                datstr(k).dotloc_ci = out1(k,3);
                
            end
            self.datstr =datstr;
            
            
            
        end
        
        function [loc,idxi,idx] = get_dotloc(self)
            trial = self.stimparmat.trials;
            locxy = cell2mat(trial.dotLocations);
            [loc1,~, i1] = unique(locxy(1,:));
            [loc2,~,i2] = unique(locxy(2,:));
            clr = cell2mat(trial.dotColors);
            [clr3,~, i3] = unique(clr);
            
            loc.x = loc1;
            loc.y = loc2;
            loc.c = clr3;
            idxi = [i1 i2 i3];
            
            idx = sub2ind([length(loc1),length(loc2),...
                length(clr3)],i1,i2,i3);
            
        end
            
            
        
    end
    
end

