%{
# pl_pr.ExtROI # part of pl_pr.Ext new version of ExtROI
->pl_pr.Ext2
->pl_pr.Seg2ROI
-----
f : longblob         #pixel x frames fluoresence signal of roi (filledlist)
n : longblob         #pixel x frames fluoresence signal of neuropil patch
roishape ='blob' : enum('blob','donut')
%}

classdef Ext2ROI < dj.Part

	properties(SetAccess=protected)
		master= pl_pr.Ext2
    end
    methods 
        function makeTuples(self,key)
            
            
            
            % insert old data generated with pl_pr.Syncvs2tpscan
            rel = pl_pr.ExtROI&key;
            if rel.count~=0,
                tuple0 = fetch(rel,'*');
                for i = 1: length(tuple0)
                    tuple = rmfield(tuple0(i),'roitype');
                    tuple.roishape = 'blob';
                    [fov,roitype] = fetchn(pl_pr.Seg2ROI&tuple,'fov','roitype');
                    
                    tuple.roitype = roitype{1};
                    
                    tuple.fov = fov{1};
                    self.insert(tuple);
                end
            end
            return;
             % will be deleted later
            %%%%%
            
            
            
            %% I have to re-implement the follows 2018-10-02
            Img2D = key.Img2D;
            key = rmfield(key,'Img2D');
            
            
            [c_pix,np_pix,roi_id] = fetchn(pl_pr.Seg2ROI&key,'filllist','neuropil','roi_id');
            
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
                tuple.roishape = roitype;
                self.insert(tuple);
            end
            
        end
    end

end