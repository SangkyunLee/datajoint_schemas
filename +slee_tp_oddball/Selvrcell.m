%{
# slee_tp_oddball.Selvrcell : select visual responsive cell
->slee_tp_oddball.Datasort
dtype  : enum('nhat','dff','dffn')
roi_id : smallint # it should match roi_id of pl_pr.Seg2ROI
-----
thr : float # statistical threshold
selvrcell_ts=CURRENT_TIMESTAMP: timestamp 
%}

classdef Selvrcell < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
            
            dtype={'dff','nhat'};
            thr = 0.05; % statistical 
            
            
            rel = slee_tp_oddball.Datasort&key;
            data = fetch(rel,'*');
            
            inxpre = data.frtime<0;
            sd = fetchn(vs_spkray.Trial&key,'stim_dur');
            % stimtime for all the trial should be same;
            if isempty(sd)
                return;
            end
            if sum(abs(sd-sd(1)))>0
                error('stimtime for all the trials should be same');
            end
            sd = sd(1);
            
            
            inxsttime = data.frtime>=0 & data.frtime<sd+1*mean(diff(data.frtime));% stimdur +100msec
                      
            
            ncell = size(data.(dtype{1}),3);
            p = NaN*ones(ncell,length(dtype));
            rth = NaN*ones(ncell,length(dtype));% response threshold
            for  i =   1  : length(dtype)
                base = squeeze(mean(data.(dtype{i})(:,inxpre,:),2));
                rp = squeeze(mean(data.(dtype{i})(:,inxsttime,:),2));
                for k = 1 : ncell
                    if all(isnan(base(:,k))) || all(isnan(rp(:,k)))
                        continue;
                    end
                    p(k,i)= signrank(base(:,k),rp(:,k));
                end
                rth(:,i) = mean(rp,1)'>mean(base,1)';
            end
            
            inxcell = p<thr & rth;
            
            for i = 1: length(dtype)
                cell_dtype = find(inxcell(:,i));
                
                for j = 1: length(cell_dtype)
                    tuple = key;
                    tuple.thr = thr;
                    tuple.dtype = dtype{i};
                    tuple.roi_id = cell_dtype(j);
                    self.insert(tuple)
                end
            end
            
		end
	end

end