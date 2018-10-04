classdef xls2dj_Eye < xls2dj
    properties
        homedir;
        
        animal_id;
        session_id;
  
        scan_id;
        
        data_path={};  %
        data_fn={};
        recorder={};
        
        daq_ch1={};
        daq_ch2={};
        
        use={};        
     
        
    end
    
    methods
        
        function self = xls2dj_Eye(ses_path,sheet, animal_id, session_id,homedir)    
                        
            xlsfn = xls2dj.get_xlsfn(fullfile(ses_path,'doc'));
            self = self@xls2dj(fullfile(ses_path,'doc',xlsfn),sheet);
            self.homedir = fullfile(ses_path,homedir);
            
            self.animal_id = animal_id;
            self.session_id = session_id;
            self.scan_id = 1:length(self.finfo);

        end
        function self = gen_datfn(self)
            %function self = gen_datfn(self)
            f = self.finfo;            
            if ~isfield(f,'eye')
                return;
            end
            
            n = length(f);
            for i = 1: n                
                if ~any(isnan(f(i).eye))  
                    fn=dir(fullfile(self.homedir,...
                        [f(i).eye '.*']));
 
                    if length(fn)==3
                        self.data_path{i} = self.homedir;
                        self.data_fn{i}=fn(1).name(1:end-5);                        
                        
                    end
                end 
                self.use{i}=f(i).use;
             end
        end
        
        function scanlist = get_validscanlist(self)
            %function scanlist = get_validscanlist(self)
            f = self.finfo;            
            if ~isfield(f,'eye')
                return;
            end
            
            n = length(f);
            scanlist =zeros(1,n);
            k =1;
            for i = 1: n                
                if ~any(isnan(f(i).eye)) && strcmp(f(i).use,'1') 
                    fn=dir(fullfile(self.homedir,...
                        [f(i).eye '.*']));
 
                    if length(fn)==3
                        scanlist(k) = i;
                        k = k+1;
                    end
                end
            end
            scanlist =scanlist(1:k-1);
             
        end
    end
end