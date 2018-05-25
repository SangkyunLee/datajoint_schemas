classdef xls2dj <dj_data
    properties
        xlsfn; % excel file name
        finfo; % extracted excel info
    end
    
    methods
        function self = xls2dj(xlsfn,sheet)  
            self = self@dj_data;
          
            self.finfo = load_logfile(xlsfn,sheet);
            self.xlsfn = xlsfn;
        end
        
        
        function self = insert(self,table, inx, fldlist)
            %function self = insert(self,table, datstr,inx, fldlist)
            % table: table object
              % inx: index of structure array (i.e., row of excel file)
            % fldlist: fld list to be put in the table
            if isempty(self.datstr)
                self.datstr = self.finfo;
            end
            self = insert@dj_data(self,table, inx, fldlist);
           
        end
        
        
        
        function self = convert(self)
            % function self = convert(self)
            % convert xls columns to class members
            f = self.finfo;
            fldname = fieldnames(self);
            fldxls = fieldnames(f(1));
            n = length(f);
            
            for j = 1:length(fldxls)                  
                fldn = fldxls{j};
                for i = 1: n                    
                    if any(strcmpi(fldname,fldn))
                        tmp = f(i).(fldn);
                        
                        if isnan(tmp)
                            self.(lower(fldn)){i}='';
                        else
                            self.(lower(fldn)){i}=tmp;
                        end

                    end
                end
            end
        end
        
        
    end
        
    methods (Static )
        function xlsfn = get_xlsfn(folder)
            xlsfn = dir(sprintf('%s/*.xls*',folder));
            errmsg = sprintf('%d excelfile exist in %s',length(xlsfn),folder);
            assert( length(xlsfn)==1,errmsg);
            xlsfn = xlsfn.name;
        end

    end
end
%%
% 
% classdef xls2dj
%     properties
%         xlsfn; % excel file name
%         finfo; % extracted excel info
%         datstr; % data structure array to input database table
%         
%     end
%     
%     methods
%         function self = xls2dj(xlsfn,sheet)            
%             self.finfo = load_logfile(xlsfn,sheet);
%             self.xlsfn = xlsfn;
%         end
%         
%         function self = create_datstr(self,fldlist,list)
%             %function self = create_datstr(self,fldlist,list)
%             n =length(list);
%             for k0 = 1:n
%                 
%                 k = list(k0);
%                 D = struct;
%                 for i = 1 : length(fldlist)                    
%                     d = self.(fldlist{i});
%                     if ischar(d) || length(d)<2
%                         D.(fldlist{i})=d;
%                     else
%                         if iscell(d)
%                             D.(fldlist{i})=d{k};
%                         else
%                             D.(fldlist{i})=d(k);
%                         end
%                     end
%                 end 
%                 if isempty(self.datstr)
%                     self.datstr=D;
%                 else
%                     self.datstr(k0)=D;
%                 end
%             end
%         end
%         
%         
%         
%         function self = autofill(self,fld,inxscan)
%             %function self = autofill(self,fld,inxscan)
%             if nargin<3
%                 inxscan = 1:length(self.finfo);                   
%             end
%             n = length(inxscan);
%             for i = 1:2:length(fld)                
%                 a =repmat(fld(i+1),[1 n]);       
%                 self.(fld{i}) = cell(1, max(inxscan));
%                 self.(fld{i})(inxscan) = a;
%             end
%         end
%         
%         function self = setdatstr(self,datstr)
%             %function self = setdatstr(self,datstr)
%             % set datstructure 
%             self.datstr = datstr; 
%         end
%         
%         function self = insert(self,table, inx, fldlist)
%             %function self = insert(self,table, datstr,inx, fldlist)
%             % table: table object
%               % inx: index of structure array (i.e., row of excel file)
%             % fldlist: fld list to be put in the table
%             if isempty(self.datstr)
%                 self.datstr = self.finfo;
%             end
%             self = insert@dj_data(self,table, inx, fldlist);
%            
%         end
%         
% %         function self = insert(self,table, inx, fldlist)
% %             %function self = insert(self,table, datstr,inx, fldlist)
% %             % table: table object
% %               % inx: index of structure array (i.e., row of excel file)
% %             % fldlist: fld list to be put in the table
% %             if isempty(self.datstr)
% %                 self.datstr = self.finfo;
% %             end
% %             if isempty(inx)
% %                 inx = 1: length(self.datstr);
% %             end
% % 
% %             for i = inx
% %    
% %                 dat = struct;
% %                 for j = 1: length(fldlist)
% %                     dat.(fldlist{j})= self.datstr(i).(fldlist{j});
% %                 end
% %                 insert(table,dat);
% % 
% %             end
% %         end
%         
%         
%         function self = convert(self)
%             % function self = convert(self)
%             % convert xls columns to class members
%             f = self.finfo;
%             fldname = fieldnames(self);
%             fldxls = fieldnames(f(1));
%             n = length(f);
%             
%             for j = 1:length(fldxls)                  
%                 fldn = fldxls{j};
%                 for i = 1: n                    
%                     if any(strcmpi(fldname,fldn))
%                         tmp = f(i).(fldn);
%                         
%                         if isnan(tmp)
%                             self.(lower(fldn)){i}='';
%                         else
%                             self.(lower(fldn)){i}=tmp;
%                         end
% 
%                     end
%                 end
%             end
%         end
%         
%         
%     end
%         
%     methods (Static )
%         function xlsfn = get_xlsfn(folder)
%             xlsfn = dir(sprintf('%s/*.xls*',folder));
%             errmsg = sprintf('%d excelfile exist in %s',length(xlsfn),folder);
%             assert( length(xlsfn)==1,errmsg);
%             xlsfn = xlsfn.name;
%         end
% 
%     end
% end
% 





