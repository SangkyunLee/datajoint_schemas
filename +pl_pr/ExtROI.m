%{
# pl_pr.ExtROI # part of pl_pr.Ext
->pl_pr.Ext
roi_id : smallint # roi number
-----
f : longblob         #pixel x frames fluoresence signal of cell
n : longblob         #pixel x frames fluoresence signal of neuropil patch
roitype = 'disk' : enum('donut','disk') #roitype for extr regardless realshape
%}

classdef ExtROI < dj.Part

	properties(SetAccess=protected)
		master= pl_pr.Ext
    end
    methods 
        function makeTuples(self,key)
            
            Img2D = key.Img2D;
            key = rmfield(key,'Img2D');
            roitype = 'disk';
            [c_pix,np_pix,roi_id] = fetchn(pl_pr.SegROI&key,roitype,'neuropil','roi_id');
            for i = 1: length(c_pix)
                tuple = key;
                tuple.roi_id = roi_id(i);
                if ~isempty(c_pix)
                    tuple.f =  Img2D(:,c_pix{i});
                end
                if ~isempty(np_pix)
                    np = Img2D(:,np_pix{i});
                    mFn = mean(np,1);
                    mmFn = mean(mFn); stdmFn = std(mFn);
                    inx = abs(mFn-mmFn)<2*stdmFn;
                    tuple.n = mean(np(:,inx),2);
                end
                tuple.roitype = roitype;
                self.insert(tuple);
            end
            
        end
    end

end