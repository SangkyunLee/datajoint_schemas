%{
# 
-> pl_pr.Seg
roi_id                      : smallint                      # roi number
---
center_x                    : float                         # cell x-center in pixel
center_y                    : float                         # cell y-center in pixel
disk                        : longblob                      # pixel filled roi: donut + neucleus
pixellist                   : longblob                      # pixel
neuropil                    : longblob                      # neuropil pixel
roitype="pyr"               : enum('pyr','SST','PV','Axon','Den','Spine','Bouton','VIP') # 
%}


classdef SegROI < dj.Part

	properties(SetAccess=protected)
		master= pl_pr.Seg;
    end
    methods
        function makeTuples(self,key)
            [fn, rpath]=fetch1(pl_pr.Seg&key,...
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
                    tuple.disk = ROI(i).fill_list;
                    tuple.pixellist = ROI(i).pixel_list;
                    tuple.neuropil = ROI(i).neuropilarea;
                end
                self.insert(tuple);
            end
            
        end
    end

end
