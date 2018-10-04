%{
# slee_tp_oddball.Stmgrp
->vs_spkray.Stimgrp
fov : enum('FOV1','FOV2','FOV3','FOV4','FOV5','FOV6','FOV7','FOV8','FOV9','FOV10') 
dtype  : enum('nhat','dff','dffn')
-----
layer : varchar(10)
scan_ids : blob # scan lists in the selected stimgroup
ori : blob # orientation lists
%}

classdef Stmgrp < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
            rel = slee_tp_oddball.Oritun&(vs_spkray.Scan&key);
           
            if rel.count==0, return; end
            oris = fetchn(rel,'ori');
            
            dtypes = fetchn(rel,'dtype');
            [sid, layer,fov] = fetchn(common.Tpscan2&rel,'scan_id','layer','fov');

            ulayer = unique(layer);
            ufov  = unique(fov);
            udtype = unique(dtypes);
            nfov = length(ufov);
            ndtype = length(udtype);
            for i =1:nfov
                inx = strcmp(fov(:)',ufov{i});              
                sids = sid(inx)';
                tuple = key;
                for j = 1 : ndtype
                    tuple.dtype = udtype{j};
                    tuple.scan_ids = sids;
                    tuple.fov = ufov{i};
                    tuple.ori = oris{1};
                    tuple.layer = ulayer{i};
                    self.insert(tuple);                
                    makeTuples(slee_tp_oddball.StmgrpROI,tuple);
                end
            end
		end
	end

end