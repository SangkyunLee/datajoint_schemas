%{
# pl_pr.Align : alignment of two-photon data acquired from prairie 
# new table 
-> common.Tpscan2
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

classdef Align2 < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
            rel = common.Tpscan & key;
            for ch = 1:3
                [key, dpath] = gen_key(rel,key, ch);
                if isempty(dpath)
                    return;
                end
            end
            %!!! compute missing fields for key here
             self.insert(key)
            
        end
        
        
	end

end


function [key, dpath] = gen_key(rel,key, ch)

    [dpath,fn] = getFilename(rel, ch);
    dpath = dpath{1};
    fn = fn{1};
    if isempty(fn)
        return;
    end
    
    mcfn = dir(fullfile(dpath,['MC_' fn]));
    if isempty(mcfn)
        % I have not implemented here
        % I have to work
        error('not implemented yet');
        motioncorrection(dpath,fn);
    end
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
end