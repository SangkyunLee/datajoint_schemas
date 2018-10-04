%{
# slee_tp_ve.Datasort
->pl_pr.Deconvsang
->pl_pr.Syncvs2tpscan

-----
twin : tinyblob # [start end]
frtime : tinyblob # frame time selected
cond_idx : blob # stimulus cond_idx for trial idx
trial_idx : blob #  trial idx
dff : longblob # dff trial x frame x cell
dffn : longblob # dffn trial x frame x cell
nhat : longblob # nhat trial x frame x cell

%}

classdef Datsort < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
            tp = pl_pr.Deconvsang&key;
            sync = pl_pr.Syncvs2tpscan&key;

            [sd, bd]=fetchn(vs_spkray.Trial&key,'stim_dur','blank_dur');
            trialdur = min(sd+bd);

            twin=[-0.5 trialdur];
            %dff
            tv = Trialvstim(tp,sync,'dff');                
            dff = tv.sort_data_vstim(twin);
            key.dff = dff;
            %nhat
            tv = Trialvstim(tp,sync,'nhat');                
            nhat = tv.sort_data_vstim(twin);
            key.nhat = nhat;
            %dffn
            tv = Trialvstim(tp,sync,'dffn');  
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