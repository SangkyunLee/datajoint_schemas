%{
# slee_tp_oddball.Oritun
->slee_tp_oddball.Datasort
dtype  : enum('nhat','dff','dffn')
-----
# add additional attributes
oritun : blob # orientation tuning
sem_oritun : blob # sem of orientation tuning
roritun : blob # orientation tuning of relative from baseline
sem_roritun : blob # sem of orientation tuning

ori : tinyblob # orientation
oritun_ts=CURRENT_TIMESTAMP: timestamp 
%}

classdef Oritun < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
            dtypes={'nhat','dff'};
            for i = 1: length(dtypes)
                tuple = key;                
                tuple = get_oritun(tuple, dtypes{i});
                tuple.dtype = dtypes{i};
                self.insert(tuple);
            end
            
            
            
%             rel = slee_tp_oddball.Datasort&key;
%             data = fetch(rel,'*');
%             grpid = fetch1(vs_spkray.Scan&key,'grp_id');                
%             rel = vs_spkray.Grating&key & sprintf('grp_id ="%s"',grpid);
%             ori= fetchn(rel,'orientation');
%             
%             dtype='nhat';
%             evtname ='orientation';
%             
%             
%             evt = ori(data.cond_idx);
%             X = data.(dtype);
%             
%             
%             rel = slee_tp_oddball.Datasort&key;
%             frtime = fetch1(rel,'frtime');            
%             inxpre = frtime<0;
%             
%             
%             cg = util.contgain(X,evtname,evt);
%              % baseline subtracted
%             X1 =bsxfun(@minus, X,mean(X(:,inxpre,:),2));
%             cg1 = util.contgain(X1,evtname,evt);
% 
%             %rel =slee_tp_oddball.Selvrcell&key;
%             %inx_cell = fetch1(rel,'cell_nhat'); 
%             inx_cell = 1:size(X,3);
%             [orit, seorit, ori] = cg.get_oritun(inx_cell); % oritun timseries
%             [orit1, seorit1] = cg1.get_oritun(inx_cell); % oritun timseries
%             
%             
%             
%             sd = fetchn(vs_spkray.Trial&key,'stim_dur');
%            
%             if sum(abs(sd-sd(1)))>0
%                 error('stimtime for all the trials should be same');
%             end
%             sd = sd(1);
%             inxst = frtime>=0 & frtime<=sd+mean(diff(frtime));% stimdur +1frame
%             
%             key.oritun = squeeze(mean(orit(:,inxst,:),2));
%             key.sem_oritun = squeeze(mean(seorit(:,inxst,:),2));
%             % baseline corrected
%             key.roritun = squeeze(mean(orit1(:,inxst,:),2));
%             key.sem_roritun = squeeze(mean(seorit1(:,inxst,:),2));
%             key.ori = ori;            

% 			 self.insert(key)
        end
        
        
        
        
        
        
        
	end

end

function tuple = get_oritun(tuple, dtype)
    evtname ='orientation';
    
    
    rel = slee_tp_oddball.Datasort&tuple;
    data = fetch(rel,'*');
    grpid = fetch1(vs_spkray.Scan&tuple,'grp_id');                
    rel = vs_spkray.Grating&tuple & sprintf('grp_id ="%s"',grpid);
    
    ori= fetchn(rel,evtname);        
            
    evt = ori(data.cond_idx);
    X = data.(dtype);


    rel = slee_tp_oddball.Datasort&tuple;
    frtime = fetch1(rel,'frtime');            
    inxpre = frtime<0;


    cg = util.contgain(X,evtname,evt);
     % baseline subtracted
    X1 =bsxfun(@minus, X,mean(X(:,inxpre,:),2));
    cg1 = util.contgain(X1,evtname,evt);

    inx_cell = 1:size(X,3);
    [orit, seorit, ori] = cg.get_oritun(inx_cell); % oritun timseries
    [orit1, seorit1] = cg1.get_oritun(inx_cell); % oritun timseries



    sd = fetchn(vs_spkray.Trial&tuple,'stim_dur');

    if sum(abs(sd-sd(1)))>0
        error('stimtime for all the trials should be same');
    end
    sd = sd(1);
    inxst = frtime>=0 & frtime<=sd+mean(diff(frtime));% stimdur +1frame

    tuple.oritun = squeeze(mean(orit(:,inxst,:),2));
    tuple.sem_oritun = squeeze(mean(seorit(:,inxst,:),2));
    % baseline corrected
    tuple.roritun = squeeze(mean(orit1(:,inxst,:),2));
    tuple.sem_roritun = squeeze(mean(seorit1(:,inxst,:),2));
    tuple.ori = ori;



end