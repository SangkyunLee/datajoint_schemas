%{
# my newest table
->pl_pr.Deconvsang2
->pl_pr.Ext2ROI
-----
parname : varchar(256) # estimation parameter names separated by '/'
parval : varchar(256) # estimation parameter values separated by '/'

a : longblob  # spatail filter
dff0 : longblob # dFF simply with a=1;
dff : longblob # obtained from optimal a estimated from algorithm
nhat : longblob # estimated spikerate
dffn : longblob # dff for neuropil with a=1;
suc :longblob  # with success, suc=1 otherwise =0 


deconvsang_ts=CURRENT_TIMESTAMP: timestamp 
%}

classdef Deconvsang2ROI < dj.Part

	properties(SetAccess=protected)
		master= pl_pr.Deconvsang2
    end
    methods
        function makeTuples(self,key)
            
            % insert old data generated with pl_pr.Syncvs2tpscan
            rel = pl_pr.Ext2ROI&key;
            selfld ={'dff0','dff','nhat','dffn','suc','a'};
            
            if rel.count~=0,
                rid = fetch(rel,'roi_id');
                for i = 1: length(rid)
                    tuple = rid(i);                    
                    fldnames = fieldnames(key);
                    for j = 1 : length(fldnames)
                        
                        if any(strcmp(selfld,fldnames{j}))

                            tuple.(fldnames{j}) = key.(fldnames{j})(:,i);
                        else
                            tuple.(fldnames{j}) = key.(fldnames{j});
                        end
                    end
                    self.insert(tuple);
                end
            end
            return;
             % will be deleted later
            %%%%%
            % I have to implement here
            
        end
    end

end