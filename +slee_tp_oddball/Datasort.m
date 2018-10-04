%{
# slee_tp_oddball.Datasort
->pl_pr.Deconvsang2
->pl_pr.Syncvs2tpscan

-----
twin : tinyblob # [start end]
frtime : tinyblob # frame time selected
cond_idx : blob # stimulus cond_idx for trial idx
trial_idx : blob #  trial idx
dff : longblob # dff trial x frame x cell
dffn : longblob # dffn trial x frame x cell
nhat : longblob # nhat trial x frame x cell
sort_ts=CURRENT_TIMESTAMP: timestamp 
%}

classdef Datasort < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
            tp = pl_pr.Deconvsang2ROI&key;
            sync = pl_pr.Syncvs2tpscan&key;
            
            
            b = slee_tp_oddball.check_stmval(key);
            if ~b, return; end
            rel = vs_spkray.Trial&key;
            if rel.count==0, return; end
            
            [sd, bd]=fetchn(rel,'stim_dur','blank_dur');
            trialdur = min(sd+bd);

            twin=[-0.5 trialdur];
            %dff
            tv = util.Trialvstim(tp,sync,'dff');   
            pause(0.1);
            dff = tv.sort_data_vstim(twin);
            key.dff = dff;
            %nhat
            tv = util.Trialvstim(tp,sync,'nhat');                
            nhat = tv.sort_data_vstim(twin);
            key.nhat = nhat;
            %dffn
            tv = util.Trialvstim(tp,sync,'dffn');  
            [dffn,frtime,info] = tv.sort_data_vstim(twin);
            key.dffn = dffn;
            
            key.frtime = frtime;
            key.cond_idx = info.events;
            key.trial_idx = info.seltrial;
            key.twin =twin;
            
			self.insert(key)
		end
    end
end

% function b = check_stmval(key)
%     key2 = struct('animal_id',key.animal_id,...
%         'session_id',key.session_id);
%     grpnames = fetchn(vs_spkray.Stimgrp&key2,'grp_id');
%     b = false;
%     for i = 1: length(grpnames)
%         if ~isempty(strfind(grpnames{i},'oddball')) || ...
%                 ~isempty(strfind(grpnames{i},'adapt'))
%             b = true;
%             break;
% 
%         end            
% 
%     end
% end