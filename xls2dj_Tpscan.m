classdef xls2dj_Tpscan < xls2dj
    properties
        scan_upfolder;
        
        
        animal_id;
        session_id;
        scan_id;
        
        data_path={};  %
        data_fn1={};
        data_fn2={};
        data_fn3={};
        
        ch1_color={};
        ch2_color={};
        ch3_color={};
        
        scanmethod={};
        
        anesthesia={} ;
        area={};
        layer={};
        depth={};
        laser_wavelength=920;
        fov={};
        scan_notes={};
        use={};
        image_type={} ; 
        
        dwell_time={};
        pixres={};
        objective={};    
        
        
        
    end
    
    methods
        function self = xls2dj_Tpscan(ses_path,sheet, animal_id, session_id)    
                        
            xlsfn = xls2dj.get_xlsfn(fullfile(ses_path,'doc'));
            self = self@xls2dj(fullfile(ses_path,'doc',xlsfn),sheet);
            self.scan_upfolder = fullfile(ses_path,'2pimage');
            
            self.animal_id = animal_id;
            self.session_id = session_id;
            
            self = convert(self);
            self.scan_id = 1:length(self.finfo);

        end
        
        function [tscan, zscan, self] = get_validscanlist(self)
            %function [tscan, zscan, self] = get_validscanlist(self)
            % return valid tscan, zscan 

            
          
            f = self.finfo;
            n = length(f);
%             self.scan_id = [];
            tscan = -1*ones(1,n);
            zscan = -1*ones(1,n);
            tk =1;
            zk=1;
            for i = 1: n
                x = self.data_path{i};
                % check data from ch1 -3
                
                d{1} = self.data_fn1{i};
                d{2} = self.data_fn2{i};
                d{3} = self.data_fn3{i};
                
                [~,m]=fileparts(x);
                if strcmp(f(i).use,'1') && exist(x,'dir')==7
                    if ~all(cellfun(@isempty,d))
                        if strcmp(m(1:8),'ZSeries-')
                            zscan(zk) = i;
                            zk = zk+1;
                        end
                        if strcmp(m(1:8),'TSeries-')
                            tscan(tk) = i;
                            tk = tk+1;
                        end
                    end                    
                end                
            end
            tscan =tscan(1:tk-1);
            zscan =zscan(1:zk-1);
        end
        
        
        function self = gen_datfn(self)
            nch = 3; % I set the maximum channel for tp-scan to 3
            f = self.finfo;
            n = length(f);
            self.data_path = cell(1,n);
            self.data_fn1 = cell(1,n);
            self.data_fn2 = cell(1,n);
            self.data_fn3 = cell(1,n);
            for i = 1: n
                x = fullfile(self.scan_upfolder,...
                    f(i).Image_directory);
                
%                 if strcmp(f(i).use,'1') && exist(x,'dir')==7
                x2 =dir(fullfile(x,[f(i).Image_directory '*.tif']));

                if isempty(x2)
                    self.data_path{i} = '';
                else
                    self.data_path{i} = x;
                end

                % multiple channel handle
                for j = 1:nch
                    str = sprintf('%s*Ch%d*.tif',f(i).Image_directory,j);
                    fn1 = dir(fullfile(x,str));
                    str1 = sprintf('data_fn%d',j);
                    if length(fn1)==1,
                        self.(str1){i}=fn1.name;
                    elseif length(fn1)>1
                        warning('%s,image may not be stacked',x);
                        self.(str1){i}='';                                                            
                    else
                        self.(str1){i}='';                            
                    end
                end
%                 end                
            end
        end
        function self = convert(self)
            % function self = convert(self)
            % convert xls columns to class members
            
            self = convert@xls2dj(self);
            f = self.finfo;
            n = length(f);
            
            for i = 1: n     
                if isnan(f(i).Notes)
                    self.scan_notes{i}='';
                else
                    self.scan_notes{i} = f(i).Notes;
                end
            end
        end
        
        

        
    end
    
        
    
end


%% 
% classdef xls2dj_Tpscan < xls2dj
%     properties
%         scan_upfolder;
%         
%         
%         animal_id;
%         session_id;
%         scan_id;
%         
%         data_path;  %
%         data_fn1;
%         data_fn2;
%         data_fn3;
%         
%         ch1_color;
%         ch2_color;
%         ch3_color;
%         
%         scanmethod;
%         
%         anesthesia ;
%         area;
%         layer;
%         depth='NA';
%         laser_wavelength=920;
%         fov;
%         scan_notes;
%         use;
%         image_type ; 
%         
%         dwell_time;
%         pixres;
%         objective;    
% 
%         
%         
%     end
%     
%     methods
%         function self = xls2dj_Tpscan(ses_path,sheet, animal_id, session_id)    
%                         
%             xlsfn = xls2dj.get_xlsfn(fullfile(ses_path,'doc'));
%             self = self@xls2dj(fullfile(ses_path,'doc',xlsfn),sheet);
%             self.scan_upfolder = fullfile(ses_path,'2pimage');
%             
%             self.animal_id = animal_id;
%             self.session_id = session_id;
%            
%         end
%         
%         function self = get_validscanlist(self)
%             %function self = get_validscanlist(self,dpath_str)
%             % select valid scans and create data struture
% 
%             
%             nch = 3; % I set the maximum channel for tp-scan to 3
%             f = self.finfo;
%             n = length(f);
%             k =1;
%             for i = 1: n
%                 x = fullfile(self.scan_upfolder,...
%                     f(i).Image_directory);
%                 
%                 if strcmp(f(i).use,'1') && exist(x,'dir')==7
%                     x2 =dir(fullfile(x,[f(i).Image_directory '*.tif']));
%  
%                     if ~isempty(x2)
%                         self.data_path{k} = x;
%                         % multiple channel handle
%                         for j = 1:nch
%                             if strfind(x2.name,['Ch' num2str(j)])
%                                 str = sprintf('data_fn%d',j);
%                                 self.(str){k}=x2.name;
%                             end
%                         end
%                         
%                         
%                         self.valid_nscan = self.valid_nscan +1;
%                         self.scan_id(k) = i;
%                         
%                         
%                         k = k+1;
%                     end                    
%                 end                
%             end
%             self = convert(self);
%         end
%         
%         
%         
%         function self = convert(self)
%             % function self = convert(self)
%             % convert xls columns to class members
%             
%             self = convert@xls2dj(self);
%             f = self.finfo;
%             n = length(f);
%             
%             for i = 1: n     
%                 if isnan(f(i).Notes)
%                     self.scan_notes{i}='';
%                 else
%                     self.scan_notes{i} = f(i).Notes;
%                 end
%             end
%         end
%         
%         
% 
%         
%     end
%     
%         
%     
% end
% 
