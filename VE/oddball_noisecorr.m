clear key
key.animal_id='SL_thy1_0220_ML'
key.session_id ='0527_D1'
inx_scan = 1; % ori tuning exp

% key.session_id ='0604_D9'
% inx_scan = 2;  % ori tuning exp
[D.nhat,D.dff,D.dffn,frtime,cond_idx]=...
    fetchn(slee_tp_ve.Datsort&key,'nhat','dff','dffn','frtime','cond_idx');
dtype='nhat'
inxresp = 5:6;
[inxcell,peakinx]= get_coarseORItun(D,dtype,cond_idx,inx_scan,inxresp);



inx_scan=3; % oddbaall experiment scan
dtype='nhat';
cidx = cond_idx{inx_scan};


ntrial = 110; % ntrial within a blk
nblk = 10;
inx_odd = cell(1,nblk);
inx_com = cell(1,nblk);
inx_com2 = cell(1,nblk);
for iblk = 1: nblk
    if iblk == nblk
        cidx1 = cidx((iblk-1)*ntrial+1: end);
    else
        cidx1 = cidx((iblk-1)*ntrial+1: iblk*ntrial);
    end
    
    if mod(iblk,2)==1,
        com = 1;
        odd =2;
    else
        com = 2;
        odd = 1;
    end
    
    inx_odd{iblk} = find(cidx1==odd)+ntrial*(iblk-1);
    inx_com{iblk} = find(cidx1==com)+ntrial*(iblk-1);
    inx_com2{iblk} = inx_com{iblk}(inx_com{iblk}>inx_odd{iblk}(1));   
end


inx1 =  find(peakinx>=1&peakinx<=3); % short distance to adapter
inx2=  find(peakinx==4 | peakinx==8); % medium distance
inx3 =  find(peakinx>=5 &peakinx<=7);  %far distance

inxcellS = inx1;

C = cell(nblk,1);
C0 = cell(nblk,1);
O = cell(nblk,1);


for iblk = 1 : nblk

    dat = squeeze(nanmean(D.(dtype){inx_scan}(:,inxresp,inxcellS),2));
    
    
    O{iblk} = dat(inx_odd{iblk},:);
    
    inx = inx_odd{iblk}-1;       
    C{iblk} =dat(inx,:);
    
    
    inx = inx_com{iblk}(3:2+length(inx_odd{iblk}));
    C0{iblk} = dat(inx,:);
end


C1 = C(1:2:end); % 45deg block
C2 = C(2:2:end);  % 135 deg block
C01 = C0(1:2:end);
C02 = C0(2:2:end);

O1 = O(1:2:end); % oddball: 135deg 
O2 = O(2:2:end);  % oddball: 45deg


C1 = cell2mat(C1);
C2 = cell2mat(C2);
C01 = cell2mat(C01);
C02 = cell2mat(C02);
O1 = cell2mat(O1);
O2 = cell2mat(O2);

CC1 = corr(C1);
M = tril(CC1,-1);
tmp = tril(ones(size(M)));
inxi = find(tmp(:)==1);
CC2 = corr(C2);
CC01 = corr(C01);
CC02 = corr(C02);
CO1 = corr(O1);
CO2 = corr(O2);


X1= [CC01(inxi) CC1(inxi) CO2(inxi)]; 
X2= [CC02(inxi) CC2(inxi) CO1(inxi)]; 
n = length(find(~isnan(X1(:,1))));
figure; hold on; 
errorbar(nanmean(X1,1), nanstd(X1,0,1)/sqrt(n),'b');
errorbar(nanmean(X2,1), nanstd(X2,0,1)/sqrt(n),'r');


















