classdef xls2dj_vstpscan < xls2dj
    properties
        
        
        animal_id;
        session_id;
        scan_id;
        
        stim_path;  %
        fn;

        grp_id;     
        
        ntrial;
        
        
    end
    
    methods
        
        function self = xls2dj_vstpscan(ses_path,sheet, animal_id, session_id)    
                        
            xlsfn = xls2dj.get_xlsfn(fullfile(ses_path,'doc'));
            self = self@xls2dj(fullfile(ses_path,'doc',xlsfn),sheet);
            self.animal_id = animal_id;
            self.session_id = session_id;
            self.scan_id = 1:length(self.finfo);

        end
        
  
        
        
        function scanlist = get_validscanlist(self)
            %function self = get_validscanlist(self)
           
            f = self.finfo;
            n = length(f);
            scanlist =zeros(1,n);
           
            k=1;
            for i = 1: n
                dirname = self.stim_path{i}; 
                fn1 = self.fn{i};
                if strcmp(f(i).use,'1') && exist(dirname,'dir')==7
                    fullfn = fullfile(dirname,fn1);                    
                    if exist(fullfn,'file')
                        scanlist(k) = i;
                        k = k+1;
                    end
                end
            end
            scanlist =scanlist(1:k-1);
        end
        
      
        function self = gen_stimfn(self,homedir,ses_date)
            f = self.finfo;
            n = length(f);
            self.grp_id= cell(1,n);
            self.fn =cell(1,n);
            self.stim_path = cell(1,n);
            for i = 1: n
                stimtype = f(i).stimulus_type;
                stimdir = f(i).stim_directory;
                if ischar(stimtype) 
                    self.grp_id{i} = stimtype;
                else
                    self.grp_id{i} = '';
                end
                
                fn1 =getfilename(f(i).stimulus_type);
                
                if ~ischar(stimdir)
                    continue;
                end
                x = fullfile(homedir,fn1,ses_date,...
                    stimdir);
                
                self.stim_path{i} = x;
                self.fn{i} = [fn1 '.mat'];
                ffn = fullfile(x,[fn1 '.mat']);
                self.ntrial(i) = get_ntrial(ffn,fn1);
            end 
        end
        
        
        
        function datstr = get_stimdatstr(self)
            ugrpname = unique(self.grp_id);
            grpids = ugrpname(~cellfun(@isempty,ugrpname));
            ngrp = length(grpids);
            datstr = struct('animal_id',self.animal_id,...
                    'session_id',self.session_id,...                    
                    'grp_id',[]);
                
            datstr = repmat(datstr,[ngrp, 1]);            
            for i = 1:ngrp
                datstr(i).grp_id = grpids{i};
            end
        end
    end
end


function stimfn = getfilename(stim_type)
    switch lower(stim_type)
        case {'cont-ori-48r','cont-ori-15r','cont-ori-40r',...
                'cont40_ori60','cont40_ori150','cont100_ori60',...
                'cont100_ori150','grating_d60_cont100',...
                'ori60','ori150','ori','cont-ori','orientation'}
            stimfn ='GratingExperiment2PhotonbySang';
        case {'rfmapping'}
            stimfn ='SquareMappingExperiment2Photon';
        case {'bar0','bar90','bar180','bar270'}
            stimfn ='RFmappingBarDrift';
        otherwise
            stimfn='';
    end
end

function n = get_ntrial(ffn, fn)
    try
        load(ffn)
        switch fn
            case {'GratingExperiment2PhotonbySang'}
                n = length(stim.params.trials.DIOValue);
            case {'SquareMappingExperiment2Photon'}
                n = length(stim.params.trials.dotLocations);
            case {'RFmappingBarDrift'}
                n = length(stim.params.trials.BarDriftDRI);
            otherwise
                n = 0;
                warning('%s not implemented\n',fn);
        end
    catch
        warning('file%s not exist or not completed\n',ffn);
        n=0;
    end
    
end

