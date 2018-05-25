%{
#pl_pr.Ext
->pl_pr.Seg
-----

%}

classdef Ext < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
			 self.insert(key);
             
            
            [dpath,fn] = fetch1(pl_pr.Align&key,'data_path','data_fn2');
            f = fullfile(dpath,fn);
            
            
            [xz, yz] = fetch1(pl_pr.Seg&key,'fov_xsz','fov_ysz');
            nframe = fetch1(pl_pr.Align&key, 'nframes');
            
            img = loadTseries(f);
            key.Img2D = reshape(img, [xz*yz nframe])';
            
             makeTuples(pl_pr.ExtROI,key);
		end
	end

end