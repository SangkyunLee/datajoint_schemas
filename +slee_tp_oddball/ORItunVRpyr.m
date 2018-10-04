%{
# my newest table
->slee_tp_oddball.StmgrpROI
-----
# add additional attributes
%}

classdef ORItunVRpyr < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
        
        rel = slee_tp_oddball.Selvrcell&key;
        if rel.count==0, return; end
        rel1 = slee_tp_oddball.StmgrpROI&key;
        
%         inxcell = fetch(slee_tp_oddball.Selvrcell&rel1,
        
			 self.insert(key)
		end
	end

end