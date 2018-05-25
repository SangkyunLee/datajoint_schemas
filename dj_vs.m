classdef dj_vs <dj_data
    %dj_vs : 
    %   insert visual stimulation file created from spikeray
    % into database (vs_spkray) via datajoint
    % 2018-05-15 Sangkyun Lee
    
    properties
        animal_id;
        session_id;
        grp_id;
        scan_id;
 
        
        stim_path;
        fn;        
        stimparmat; % loaded matfile
        
        
        stimpar; % stimulus parameter struct to be inserted   
        
        cond_idx; % condition index for trials
        condseq; % to gen cond_idx e.g, {contrast, orienation,sf..}
    end
    
    methods
        function self = dj_vs(header)
           
            stim_path = header.stim_path;
            fn = header.fn;
            load(fullfile(stim_path,fn));
            self.stimparmat = stim.params;
            self.stim_path = stim_path;
            self.fn = fn;
            self.animal_id = header.animal_id;
            self.session_id = header.session_id;
            self.grp_id = header.grp_id;
            self.scan_id = header.scan_id;
            
        end
        function dat = create_Condition(self)
            %function dat = create_Condition(self)
            % generate dat structure to input in vs_spkray.Condition
            
            dat = struct('animal_id',self.animal_id,...
                'session_id', self.session_id,...
                'grp_id',self.grp_id,...
                'condseq_name',[],'ncondseq',[]);
            n = length(self.condseq);
            for i = 1: n                
                dat.condseq_name = ...
                    [dat.condseq_name self.condseq{i} '/'];
                
                dat.ncondseq(i) = ...
                    length(self.stimpar.(self.condseq{i}));                
            end
            dat.condseq_name = dat.condseq_name(1:end-1);
            dat.cond_idx =[];
            nidx = length(unique(self.cond_idx));
            dat = repmat(dat,[nidx, 1]);
            
            for i =1:nidx
                dat(i).cond_idx =i;
            end
            
            
        end
        
        function dat = create_Trial(self)
            
            dat = struct('animal_id',self.animal_id,...
                'session_id', self.session_id,...
                'grp_id',self.grp_id,...
                'scan_id',self.scan_id,...
                'trial_id',[],'cond_idx',[],...
                'stim_dur',[],'blank_dur',[]);
            N = length(self.cond_idx);
          
            dat = repmat(dat,[N, 1]);
            stimFrames = getparv(self,'stimFrames');
            blankFrames = getparv(self,'blankFrames');
            refreshRate = getparv(self,'refreshRate');
            if length(stimFrames)==1,
                stimFrames = repmat(stimFrames, [N 1]);
            end
            if length(blankFrames)==1,
                blankFrames = repmat(blankFrames, [N 1]);
            end
                
            
            for i =1:N
                dat(i).trial_id =i;
                dat(i).cond_idx =self.cond_idx(i);
                
                dat(i).stim_dur = stimFrames(i)/refreshRate;
                if isempty(blankFrames)
                    dat(i).blank_durms = 0;
                else
                    dat(i).blank_dur = blankFrames(i)/refreshRate;
                end
            end
            
        end
        
        
        function self = gen_stimdat(self)

        end  
    end
    methods(Access = private)
        function out = getparv(self,fldname)
            stimmat = self.stimparmat;
            if isfield(stimmat.constants,fldname)
                out = stimmat.constants.(fldname);
            elseif isfield(stimmat.trials,fldname)
                out = stimmat.trials(end).(fldname);
            else
                out =[];
                warning('%s not exist and set to []',fldname);
            end
        end

    end
    
end


