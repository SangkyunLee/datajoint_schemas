%{
# pl_pr.Wheelspeed : wheel rotation speed
->common.Daq
-----
rodsize : float # cm in radius
encoder_resolution : float # cycles per revolution
t : longblob # time in daq (sec)
whlspd : longblob   # wheelspeed
wheel_ts = CURRENT_TIMESTAMP : timestamp    # automatic
%}

classdef Wheelspeed < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here

            ch1 = fetch1(common.Daq&key,'wheel_ch1');
            ch2 = fetch1(common.Daq&key,'wheel_ch2');
            [sig,ch,t]=loadDAQ(common.Daq,key);
            
            % rotation pattern (clockwise or counter clockwise)
            ROT1 = [0 0  0 1  1 1  1 0];
            ROT2 = [1 0  1 1  0 1  0 0];
            ROTAROADSIZE_RAD = 8; % in cm
            ENCODER_RESOLUTION = 2500; % CYCLE/REVOLUTION



            A=sig(:,ch==ch1)-mean(sig(:,ch==ch1));
            A=(sign(A/max(abs(A)))+1)/2;

            B=sig(:,ch==ch2)-mean(sig(:,ch==ch2));
            B=(sign(B/max(abs(B)))+1)/2;

            statechange_inxA=find(diff(A)~=0);
            statechange_inxB=find(diff(B)~=0);
            statechange_inx = unique(sort([statechange_inxA;statechange_inxB]));


            Time_statechange = t(statechange_inx);
            M=[A(statechange_inx) B(statechange_inx) ];

            Maug = [M(1:end-1,:) M(2:end,:)];
            direction=zeros(size(Maug,1),1);
            RotTime =Inf*ones(size(Maug,1),1);
            
            for istate = 1 : size(Maug,1)
                Mi = Maug(istate,:);            
                for ishift = 0 : 2 : 6
                    ROT1sh= circshift(ROT1',ishift)';
                    ROT1sh = ROT1sh(1:4);
                    ROT2sh= circshift(ROT2',ishift)';
                    ROT2sh = ROT2sh(1:4);

                   
                    if sum(abs(Mi-ROT1sh))==0 || sum(abs(Mi-ROT2sh))==0
                        if sum(abs(Mi-ROT1sh))==0
                            direction(istate) = 1;
                        elseif sum(abs(Mi-ROT2sh))==0
                            direction(istate) = -1;
                        end
                        RotTime(istate)=Time_statechange(istate+1) - Time_statechange(istate);


                    end
                end
            end
            distseg = (ROTAROADSIZE_RAD*2*pi)/(4*ENCODER_RESOLUTION);
            
            % I have not check RotTime = inf
            % after checking that, I have to repopulate
            speed=distseg./RotTime;
            speed = speed.*direction;
            fs = 5000;
            [y,ty] = resample(speed,Time_statechange(1:end-1),fs);
            key.t = ty;
            key.whlspd =y;
            key.rodsize = ROTAROADSIZE_RAD;
            key.encoder_resolution = ENCODER_RESOLUTION;           
        
        
        
			 self.insert(key)
		end
	end

end