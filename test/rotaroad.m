% rotation pattern (clockwise or counter clockwise)
ROT1 = [0 0  0 1  1 1  1 0];
ROT2 = [1 0  1 1  0 1  0 0];
ROTAROADSIZE_RAD = 8; % in cm
ENCODER_RESOLUTION = 2500; % CYCLE/REVOLUTION


key.animal_id = 'SL_thy1_0220_ML'
key.session_id = '0528_D2'
key.scan_id = 4


 figure; plot(ty,y);
 
 
%%

[dff,n, dffn] =fetchn(pl_pr.Deconvsang&key,'dff','nhat','dffn');
figure; 
i=2,j=12
plot([dff{i}(:,j) n{i}(:,j) dffn{i}(:,j)])

key.animal_id='SL_thy1_0220_ML'
key.session_id = '0604_D9'
key.scan_id=1
[sig,ch,t]=loadDAQ(common.Daq,key);