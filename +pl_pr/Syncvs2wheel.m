%{
# pl_pr.Syncvs2wheel : sychronize vs photodiode to wheel rotation
->pl_pr.Daq

-----

t : longblob # time in daq (sec)
wheelspeed : longblob   # stimulus cond_idx change on DAQ card
sync_ts = CURRENT_TIMESTAMP : timestamp    # automatic
%}

classdef Syncvs2wheel < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			 self.insert(key)
		end
	end

end