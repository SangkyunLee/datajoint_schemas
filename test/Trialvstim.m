classdef Trialvstim
    %classdef Trialvstim
    % get trialbased visual response
    properties
        tp; % struct(data, parname, parval), each component cell array
        sync; %struct(stim_times, frame_times)
        nscan;
    end
    
    methods(Access = public)
        
        function self = Trialvstim(tp,  sync,dtype)
            
            [tp1.data] = fetchn(tp,dtype);
            [sync1.t, sync1.stim_times,sync1.frame_times] = fetchn(sync,'t','stim_times','frame_times');
            self.tp = tp1;
            self.sync = sync1;
            self.tp.dtype = dtype;
            self.nscan = tp.count;
            
        end
        


        
        function [Y, frtime, info] = sort_data_vstim(self, tsec, out_frame) 
            % function [Y, frtime, info] = sort_data_vstim(self,dataType, tsec, out_frame) 
            % sort visual response tseries into Y (
            
          
            [frames, frtime] = self.convert_time_frame(tsec);

            sig1 = self.tp.data{1};
            stimtime = self.sync.stim_times{1};
            frame_start = self.sync.frame_times{1};                        


            [Nframe, nCell] = size(sig1);
            if nargin<5 || isempty(out_frame)
                out_frame = false*ones(Nframe,1);
            end            





            inxf = find(frame_start>0);
            inxf = inxf(1:Nframe);  
            inxin = length(stimtime)>=inxf;
            stiminx = stimtime(inxf(inxin)); 



            stimonset = find(diff(stiminx)~=0)+1;        
            trialdur = diff(stimonset);
            stimimginx = stiminx(stimonset);
            inxn0 = find(stimimginx~=0);
            stimonset = stimonset(inxn0);
            trialdur = trialdur(inxn0(1:end-1));
            trialdur(end+1) = round(mean(trialdur));
            stimimginx = stimimginx(inxn0); 



            cut_pre = zeros(1,length(stimonset));
            cut_post = zeros(1,length(stimonset));
            cut_frame = zeros(1,length(stimonset));


            for itrial=1:length(stimonset)
                if any((stimonset(itrial)+frames)<1),
                    cut_pre(itrial)=1;
                end
                if any((stimonset(itrial)+frames)>Nframe),
                    cut_post(itrial)=1;
                end

                inxframe = stimonset(itrial)+(-2:trialdur(itrial));
                if inxframe(1)>0 && inxframe(end)<=Nframe
                    cut_frame(itrial) = any(out_frame(inxframe));
                end
            end


            keepinx = ~(cut_pre | cut_post | cut_frame);    


            stimonset = stimonset(keepinx);
            stimimginx = stimimginx(keepinx);

            info.events = stimimginx;
            Y = zeros(length(stimimginx),length(frames),nCell);
            for iwin=1:length(frames)        
                a = sig1(stimonset+frames(iwin),:);
                a=reshape(a,[size(a,1) 1 size(a,2)]);
                Y(:,iwin,:)=a; 
            end
            info.seltrial = find(keepinx);
           
        end


        function [frames, frame_tsec] = convert_time_frame(self, tsec)
            %function [frames, frame_tsec] = convert_time_frame(self, tsec)
            % convert vis_stim_time to relative frame index and frame time
                   
            frame_dur = ...
                mean(diff(self.sync.t{1}(self.sync.frame_times{1}>0)));
            frame = round(tsec/frame_dur);
            frames = frame(1):frame(end);
            frame_tsec = frames*frame_dur;

        end
        
        function inx = get_rinx(self, twin, twin2)
            f1 = self.convert_time_frame(twin);
            f2 = self.convert_time_frame(twin2);
            inx = find(f1==f2(1)):find(f1==f2(end));
           
        end

        
    end
    
end


