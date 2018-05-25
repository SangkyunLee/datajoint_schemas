classdef dj_data
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        datstr; % data structure array to input database table
    end
    
    methods
        function self = dj_data
            self.datstr=struct([]);
        end
        function self = insert(self,table, inx, fldlist)
            %function self = insert(self,table, datstr,inx, fldlist)
            % table: table object
              % inx: index of structure array (i.e., row of excel file)
            % fldlist: fld list to be put in the table
            if nargin<3
                inx =[];
                fldlist = fieldnames(self.datstr);
            end
            if isempty(inx)
                inx = 1: length(self.datstr);
            end
            

            for i = inx
   
                dat = struct;
                for j = 1: length(fldlist)
                    dat.(fldlist{j})= self.datstr(i).(fldlist{j});
                end
                insert(table,dat);

            end
        end
        
        function self = create_datstr(self,fldlist,list)
            %function self = create_datstr(self,fldlist,list)
            n =length(list);
            for k0 = 1:n
                
                k = list(k0);
                D = struct;
                for i = 1 : length(fldlist)                    
                    d = self.(fldlist{i});
                    if ischar(d) || length(d)==1
                        D.(fldlist{i})=d;
                    else
                        if iscell(d)
                            D.(fldlist{i})=d{k};
                        else
                            D.(fldlist{i})=d(k);
                        end
                    end
                end 
                if isempty(self.datstr)
                    self.datstr=D;
                else
                    self.datstr(k0)=D;
                end
            end
        end
        
        function self = autofill(self,fld,inxscan)
            %function self = autofill(self,fld,inxscan)
            if nargin<3
                inxscan = 1:length(self.finfo);                   
            end
            n = length(inxscan);
            for i = 1:2:length(fld)                
                a =repmat(fld(i+1),[1 n]);       
                self.(fld{i}) = cell(1, max(inxscan));
                self.(fld{i})(inxscan) = a;
            end
        end
        
        function self = setdatstr(self,datstr)
            %function self = setdatstr(self,datstr)
            % set datstructure 
            self.datstr = datstr; 
        end
    end
    
end

