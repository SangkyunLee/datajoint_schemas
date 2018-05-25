%{
# slee_tp_ve.Datgrp # stimulus group within a session
->slee_tp_ve.Datsort
#->vs_spkray.Stimgrp
-----
# add additional attributes
%}

classdef Stimgrp < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here       
            
%             scanrel = vs_spkray.Scan&key;            
%             datrel = slee_tp_ve.Datsort&scanrel;
%             [twin,frtime,cond_idx,trial_idx,dff,dffn,nhat]...
%                 = fetchn(datrel,'twin','frtime','cond_idx','trial_idx',...
%                 'dff','dffn','nhat');
%             key.twin
			 self.insert(key)
		end
	end

end