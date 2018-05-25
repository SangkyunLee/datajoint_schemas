%{
# pl_pr.Align : alignment of two-photon data acquired from prairie 
-> common.Tpscan
-----
nframes : smallint # no. frames
data_path : varchar(255) # scan directory for raw data
data_fn1 : varchar(255) # scan filename for aligned data of ch1
data_fn2 : varchar(255) # scan filename for aligned data of ch2
data_fn3 : varchar(255) # scan filename for aligned data of ch3

motion_x : longblob # motionparameter in x (pixels)
motion_y : longblob # motionparameter in y (pixels)
aligment_ts=CURRENT_TIMESTAMP: timestamp 

%}

classdef Align < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
            ch =2;
            [dpath,fn,fullfns] = getFilename(common.Tpscan & key, ch);
            
            dpath = dpath{1};
            fn = fn{1};
            if isempty(dpath) || isempty(fn)
                return;
            end
            
            mcfn = dir(fullfile(dpath,['MC_' fn]));
            if length(mcfn)==1
                par = dir(fullfile(dpath,'motionparameter*.mat'));
                if length(par)==1;
                    par=load(fullfile(dpath, par.name));
                end
                key.motion_x = par.M(4,:);
                key.motion_y = par.M(3,:);
                key.data_path = dpath;
                key.nframes = size(par.M,2);
                ch = sprintf('data_fn%d',ch);
                key.(ch)=mcfn.name;
            else
                % I have not implemented here
                % I have to work
                error('not implemented yet');
                fullfn = fullfns{1};
                motioncorrection(fullfn);
                
                
            end
            
            
		%!!! compute missing fields for key here
			 self.insert(key)
		end
	end

end