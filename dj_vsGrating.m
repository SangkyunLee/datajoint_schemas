classdef dj_vsGrating <dj_vs
    % dj_vsGrating 
    %  insert visual stimulation file created from spikeray
    % into database (vs_spkray) via datajoint
    
    properties

    end
    
    methods
        function self = dj_vsGrating(header)            
            self = self@dj_vs(header); 
        end
        
        
        function self = gen_stimdat(self)
            trial = self.stimparmat.trials;
            const = self.stimparmat.constants;
            
            % set stimpar structure
            self.stimpar.animal_id = self.animal_id;
            self.stimpar.session_id = self.session_id;
            self.stimpar.grp_id = self.grp_id;
            
            % set stimpar
            self.stimpar.stimcenter_x = const.stimCenterDeg(1);
            self.stimpar.stimcenter_y = const.stimCenterDeg(2);
            self.stimpar.stimrad = const.stimRadiusDeg;
            self.stimpar.stimmargin = const.stimMarginDeg;
            self.stimpar.gratingwaveform = const.gratingWaveform;
            self.stimpar.contrast = unique(trial.contrast);
            self.stimpar.orientation = unique(trial.orientation);
            self.stimpar.sf = unique(trial.spatialFreq);
            self.stimpar.tf = unique(trial.tempoFreq);
            self.stimpar.dir = unique(trial.direction);
            self.stimpar.ph = unique(trial.initialPhase);
            
            
            self.condseq ={'contrast','orientation','sf','tf','dir','ph'};
            self.cond_idx = trial.DIOValue;
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
            
            % generate condition index for each stimulus condition
            idx = self.get_condidx(unique(self.cond_idx));   
            
            out = zeros(N,n);
            for i= 1: length(kinds)
                vals = self.stimpar.(kinds{i});
                cmdstr = sprintf('vals(idx.I%d)',i);
                out(:,i)=eval(cmdstr);
            end
            
            for k =1 : N
                for i= 1: n        
                    datstr(k).(kinds{i}) = out(k,i);                   
                end
                datstr(k).cond_idx = k;                
            end
            self.datstr =datstr;
            
        end
        
        function idx = get_condidx(self,condid)
            conds = self.condseq; 
            n = length(conds);
            nvals = zeros(1,n);
            cmdstring0 = cell(1,n);
            for i = 1 : n
                nvals(i) = length(self.stimpar.(conds{i}));
                cmdstring0{i}=sprintf('idx.I%d, ',i);
            end
            cmdstring0 = cell2mat(cmdstring0);
            cmdstring =['[' cmdstring0(1:end-2)...
                ']=ind2sub(nvals,condid);'];
            eval(cmdstring);
            
            
        end
    end
    
end

