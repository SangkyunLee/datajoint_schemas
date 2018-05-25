%{
# pl_pr.Seg # cellidentification main table
->pl_pr.Align
-----
path_roif : varchar(256) # datapath for roi file 
roifn : varchar(50) # roi filename
fov_xsz : smallint unsigned # field of view size (x)
fov_ysz : smallint unsigned # field of view size (y)
nprad1 : float # neuroipl inner radius center to cell
nprad2 : float # neuroipl outer radius center to cell
%}

classdef Seg < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
            [dpath,fn] = fetch1(pl_pr.Align&key,'data_path','data_fn2');
            f = fullfile(dpath,['AVG_' fn]);
            img = loadTseries(f);
            key0 =key;
            
            [key.roifn, key.path_roif, fullfn] = ...
                pl_pr.Seg.get_roifn(dpath);
            key.fov_xsz = size(img,2);
            key.fov_ysz = size(img,1);
            ROI = load(fullfn);
            ROI = ROI.ROI;
            key.nprad1 =ROI(1).npinradius(1);
            key.nprad2 =ROI(1).npinradius(2);
            
            self.insert(key)
            makeTuples(pl_pr.SegROI,key0);
		end
    end
    
    methods(Static)
        function [fn, rpath, fullfn] = get_roifn(dpath)
            sespath = strsplit(dpath,'/2pimage/');
            imgdir = sespath{2};
            
            sespath =sespath{1};
            xls =dir(fullfile(sespath,'/doc/*.xls'));
            xls = load_logfile(fullfile(sespath,'doc',xls.name),1);
            imglist = {xls.Image_directory};
            inx = strcmp(imglist,imgdir);
            
            rpath = fullfile(sespath,'matlab/ROI');
            fn =[xls(inx).ROIfn '-1.mat'];
            fullfn = fullfile(rpath,fn); 
            assert(exist(fullfn,'file')==2, sprintf('file not exist: %s.',fn));
            
        end
    end

end