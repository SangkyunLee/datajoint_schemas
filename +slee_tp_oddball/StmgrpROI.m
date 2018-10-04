%{
#slee_tp_oddball.StmgrpROI
->slee_tp_oddball.Stmgrp
->slee_tp_oddball.Oritun
->pl_pr.Seg2ROI   # roi_id, roitype
-----
oritun : blob # orientation tuning
sem_oritun : blob # sem of orientation tuning
roritun : blob # orientation tuning of relative from baseline
sem_roritun : blob # sem of orientation tuning

stmgrproi_ts=CURRENT_TIMESTAMP: timestamp 
%}



classdef StmgrpROI < dj.Part

	properties(SetAccess=protected)
		master= slee_tp_oddball.Stmgrp;
    end
    methods 
        function makeTuples(self,key)
            sl = key.scan_ids;
            
            for i = 1:length(sl)
                rel1 = rmfield(key,{'ori','scan_ids'});                               
                rel1.scan_id = key.scan_ids(i);
                rel1=slee_tp_oddball.Oritun&rel1;
                data = fetch(rel1,'*');
                
                
                inxcell = 1:size(data.oritun,2);
                
                for j0 = 1: length(inxcell) 
                    j = inxcell(j0);
                    tuple = rmfield(key,{'ori','scan_ids','layer'}); 
                    tuple.scan_id = sl(i);
                    tuple.roi_id = j;
                    tuple.roitype= fetch1(pl_pr.Ext2ROI&tuple,'roitype');
          
                    
                    tuple.oritun = data.oritun(:,j);
                    tuple.sem_oritun = data.sem_oritun(:,j);
                    tuple.roritun = data.roritun(:,j);
                    tuple.sem_roritun = data.sem_roritun(:,j);
                    
                    
                    self.insert(tuple);
                end
                    
            end
        end
    end

end