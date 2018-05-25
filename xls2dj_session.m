classdef xls2dj_session < xls2dj
    properties

        aniUIDs;  % ani unique ID
        aniIDs; % aniIDs forall sessions 
    end
    
    methods
        function self = xls2dj_session(xlsfn,sheet)            
            self = self@xls2dj(xlsfn,sheet);
            self = self.get_animal_ids;
        end
        
        function self = get_animal_ids(self)
            self.aniIDs = {self.finfo(:).animal_id};
            self.aniUIDs = unique(self.aniIDs);
        end
        
        function ses_inx = get_sessions(self, aniID)
            a =@(x) strcmp(x,aniID);
            ses_inx = find(cellfun(a,self.aniIDs));
        end
        
    end
end


