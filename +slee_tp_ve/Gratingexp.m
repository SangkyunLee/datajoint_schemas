%{
# slee_tp_ve.Gratingexp
->slee_tp_ve.Seslearn
stmgrp_id  : varchar(20)
session_id : varchar(20) # this should match to common.session
-----
tpscan_ids : tinyblob #tp-scan ids belong to this session
btwin : tinyblob # baseline time window
rtwin : tinyblob # response time window
twin : tinyblob  # trial time window
cell_common : blob # cells selected across tpsession within learningsession
cellinx : blob #cell index specifically within scan
trialinx : blob # trial index selected
celln : tinyblob # imaged cell no within scan
%}

classdef Gratingexp < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)

            rel =vs_spkray.Scan&slee_tp_ve.Datsort&key;
            stmid = fetchn(rel&...
               'fn="GratingExperiment2PhotonbySang.mat"','grp_id');
            if isempty(stmid)
                return;
            end
            stmid = unique(stmid);
            ses_id = fetchn(rel,'session_id');
            ses_id = unique(ses_id);
%  
            for i = 1 : length(stmid); 
                vsl = GratingLearn(key.animal_id,ses_id,stmid{i});
                [vsl,binx,rinx] = vsl.get_contgain;
                [vsl,  celln]= vsl.select_cell_vresp(0.05,binx,rinx);
                vsl = vsl.get_common_cellinx;
                
                for ises = 1: length(ses_id)
                    table = key;
                    table.stmgrp_id = stmid{i};
                    table.session_id = vsl.session_ids{ises};
                    table.tpscan_ids = vsl.scan_ids{ises};
                    table.btwin = vsl.btwin;
                    table.rtwin = vsl.rtwin;
                    table.twin = vsl.twin;
                    table.cell_common = vsl.cell_common;
                    table.cellinx = vsl.cellinx{ises};
                    table.trialinx = vsl.trialinx{ises};
                    table.celln = celln{ises};
                    self.insert(table);
                end
        
			 
            end
		end
	end

end