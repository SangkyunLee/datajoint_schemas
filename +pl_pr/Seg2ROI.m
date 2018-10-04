%{
# 
-> pl_pr.Seg2
roi_id                      : smallint                      # roi number
roitype="pyr"               : enum('pyr','SST','PV','Axon','Den','Spine','Bouton','VIP','neuropil') # 
---
center_x                    : float      # cell x-center in pixel
center_y                    : float      # cell y-center in pixel
filllist                    : longblob   # pixel filled roi: donut + neucleus
pixellist                   : longblob   # pixel
neuropil                    : longblob   # neuropil pixel 
seg_ts=CURRENT_TIMESTAMP: timestamp 
%}


classdef Seg2ROI < dj.Part

	properties(SetAccess=protected)
		master= pl_pr.Seg2;
    end
    methods
        function makeTuples(self,key)
            [fn, rpath]=fetch1(pl_pr.Seg2&key,...
                'roifn', 'path_roif');
            
            fullfn = fullfile(rpath,fn);
            ROI = load(fullfn);
            ROI = ROI.ROI;
            for i = 1: length(ROI)
                tuple = key;
                tuple.roi_id = i;
                if ~isempty(ROI(i).fill_list)
                    tuple.center_x = ROI(i).centerPos(2);
                    tuple.center_y = ROI(i).centerPos(1);
                    tuple.filllist = ROI(i).fill_list;
                    tuple.pixellist = ROI(i).pixel_list;
                    tuple.neuropil = ROI(i).neuropilarea;
                    if isfield(ROI(i),'roitype')
                        tuple.roitype = ROI(i).roitype;
                    else
                        tuple.roitype = 'pyr';
                    end
                end
                self.insert(tuple);
            end
            
        end
    end

end
