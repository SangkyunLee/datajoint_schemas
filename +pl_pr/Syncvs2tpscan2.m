%{
# pl_pr.Syncvs2tpscan2 : sychronize vs photodiode to tp scan
->pl_pr.Align2
->vs_spkray.Scan
-----

t : longblob # time in daq (sec)
frame_times : longblob   # frame times on DAQ card
stim_times : longblob   # stimulus cond_idx change on DAQ card
sync_ts = CURRENT_TIMESTAMP : timestamp    # automatic
%}

classdef Syncvs2tpscan2 < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
        
            % insert old data generated with pl_pr.Syncvs2tpscan
            rel = pl_pr.Syncvs2tpscan&key;
            if rel.count~=0,
                tuple = fetch(rel,'*');
                tuple.fov = key.fov;
                self.insert(tuple);
            end
            return;
             % will be deleted later
            %%%%%
            
            f = fetch(common.Daq&key,'*');
            [sig,ch,t]=loadDAQ(common.Daq,key);
            Nframe = fetch1(pl_pr.Align&key,'nframes');
            
            
            % get time index for tpscan frames
            y = sig(:,ch==f.frame_trigger);
            fT = FrameT(t,y);
            tinxf = fT.get_tstmp(Nframe);
            frame_times = zeros(size(t));
            frame_times(tinxf(:,1))=1;
            
            % get stimtime
            fn =fetch1(vs_spkray.Scan&key,'fn');            
            if isempty(fn), return; end
            
            
            pdt = PDT(t,sig(:,ch==f.pd));
            [minint, ~, blanktime] = pl_pr.Syncvs2tpscan.get_minISI(key);
            [tinxe,evtime] = pdt.get_tstmp(minint,[]);
            pdt.plot_result(evtime,40,...
                sprintf('%s,%s,scan%d',key.animal_id,key.session_id,key.scan_id));

            if min(blanktime>0)
                lenstim = floor(length(tinxe)/2);
                stim_onset = tinxe(1:2:lenstim*2);
                blank_onset = tinxe(2:2:lenstim*2);
            else
                stim_onset = tinxe;
                blank_onset = [];    % when different stimulus conditions are consecutive without blank
            end
            nevt1 = length(stim_onset);
            condseq = fetchn(vs_spkray.Trial&key,'cond_idx');
            stim_time0 = zeros(size(t));
            stim_times = stim_time0;
            stim_time0(stim_onset) = condseq(1:nevt1);    

            if ~isempty(blank_onset)
                stimend = blank_onset;
            else
                if condseq(end)>0 % condseq==0  ==>blank condition
                    stimend = stim_onset(2:end)-1;
                    stimdur = diff(stim_onset);
                    est_stimend = stimend(end) + stimdur;
                    if est_stimend<=length(stim_time0)
                        stimend(end+1) = est_stimend;
                    else
                        stimend(end+1) = length(stimtime0);
                        warning('The last trial(%d) is cut out',length(stim_onset));
                    end
                else
                    stimend=[];
                end
            end


            nevt = length(condseq); 

            if nevt1> nevt
                fprintf('NEVT:%d(designed), %d(executed): %d used for data collection',...
                    nevt, nevt1, nevt);
                nevt1 = nevt;
            end

            for iblk = 1: nevt1
                stpoint = stim_onset(iblk);     
                if isempty(stimend)
                    edpoint = length(stimtime);
                else
                    edpoint = stimend(iblk);
                end
                cond = stim_time0(stpoint);
                inxes = stpoint : edpoint;
                stim_times(inxes) = cond;    
            end    
            key.stim_times = stim_times;
            
            
            key.t = t;
            key.frame_times = frame_times;
            
        
			 self.insert(key)
        end
        
     
        
    end
    methods(Static)
        
        function [minint, stimtime, blanktime] = get_minISI(key)

            rel = vs_spkray.Trial&key;
            assert( rel.count>1, 'tuple not exist');
            [stimtime,blanktime]=fetchn(rel,'stim_dur','blank_dur');
            if min(blanktime)==0
                minint = min(stimtime); % in second
            else
                minint = min([stimtime;blanktime]); % in second
            end
        
            
        end
	end

end