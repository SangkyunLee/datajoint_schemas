%{
#pl_pr.Ext2 new version
->pl_pr.Seg2
-----
ext_ts=CURRENT_TIMESTAMP: timestamp 
%}

classdef Ext2 < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
            
            
            % insert old data generated with pl_pr.Syncvs2tpscan
            rel = pl_pr.Seg2&key;
            if rel.count~=0,
                self.insert(key);
                makeTuples(pl_pr.Ext2ROI,key);
                
            end
            return;
             % will be deleted later
            %%%%%
            
			 self.insert(key);
             
            
            [dpath,fn] = fetch1(pl_pr.Align2&key,'data_path','data_fn2');
            f = fullfile(dpath,fn);
            
            
            [xz, yz] = fetch1(pl_pr.Seg2&key,'fov_xsz','fov_ysz');
            nframe = fetch1(pl_pr.Align2&key, 'nframes');
            
            img = loadTseries(f);
            key.Img2D = reshape(img, [xz*yz nframe])';
            
             makeTuples(pl_pr.Ext2ROI2,key);
		end
	end

end