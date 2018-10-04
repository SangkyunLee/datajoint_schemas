classdef xls2dj_Daq < xls2dj
    properties
        homedir;
        
        animal_id;
        session_id;
  
        scan_id;
        
        data_path={};  %
        data_fn={};
        recorder={};
        
        nch={};
        fs={};
        frame_trigger={};
        pd={};
        wheel_ch1={};
        wheel_ch2={};
        
        use={};        
        
        
    end
    
    methods
        
        function self = xls2dj_Daq(ses_path,sheet, animal_id, session_id,homedir)    
                        
            xlsfn = xls2dj.get_xlsfn(fullfile(ses_path,'doc'));
            self = self@xls2dj(fullfile(ses_path,'doc',xlsfn),sheet);
            self.homedir = fullfile(ses_path,homedir);
            
            self.animal_id = animal_id;
            self.session_id = session_id;
            self.scan_id = 1:length(self.finfo);

        end
        function scanlist = get_validscanlist(self)
            %function scanlist = get_validscanlist(self)
            
           
            f = self.finfo;
            n = length(f);
            scanlist =zeros(1,n);
            k =1;
            for i = 1: n
              
                x = self.data_path{i};
                fn =self.data_fn{i};
                if strcmp(f(i).use,'1') && exist(x,'dir')==7
                    x2 =fullfile(x,fn);
 
                    if exist(x2,'file')
                       scanlist(k) = i;
                        
                        k = k+1;
                    end
                end
            end
            scanlist =scanlist(1:k-1);
        end
        
        
        function self = gen_datfn(self)
            %function self = gen_datfn(self)
            
           
            f = self.finfo;
            n = length(f);
            self.data_path = cell(1,n);
            self.data_fn = cell(1,n);
            
            for i = 1: n
                if isfield(f(i),'Image_directory')
                    x = fullfile(self.homedir,...
                        f(i).Image_directory);
                    dirname = 'Image_directory';
                elseif isfield(f(i),'Recording_directory')
                    x = fullfile(self.homedir,...
                        f(i).Recording_directory);
                    dirname = 'Recording_directory';
                end
                    
                
                if  exist(x,'dir')==7
                    x2 =dir(fullfile(x,[f(i).(dirname) '*.csv']));
 
                    if ~isempty(x2)
                        self.data_path{i} = x;                        
                        self.data_fn{i}=x2.name;                        
 
                        
                    end
                end
                
                    
                self.use{i}=f(i).use;
 
                
            end
        end
    end
end