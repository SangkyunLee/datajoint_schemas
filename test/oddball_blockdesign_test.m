
%%
clear key
key.animal_id='SL_SST_0206_MB'
key.session_id ='0623'
inx_scan = 1;
ntrial = 80; % ntrial within a blk
nblk = 10;

clear key
key.animal_id='SL_thy1_0220_ML'
key.session_id ='0527_D1'
inx_scan = 1;
% key.session_id ='0604_D9'
% inx_scan = 1;

ntrial = 110; % ntrial within a blk
nblk = 10;


%%
[D.nhat,D.dff,D.dffn,frtime,cond_idx]=...
    fetchn(slee_tp_oddball.Datasort&key,'nhat','dff','dffn','frtime','cond_idx');
dtype='nhat'
% figure; plot(frtime{inx_scan},squeeze(mean(nanmean(D.(dtype){inx_scan},3),1)),'.-')


cid = cond_idx{inx_scan};
y = D.(dtype){inx_scan};
X = zeros(size(y));

Tun = zeros(8,size(y,3));
eTun =Tun;


for i = 1 : 8
    inx = find(cid==i);    
    my = mean(y(inx,5:6,:),2);
    Tun(i,:)  = squeeze(mean(my,1));   
    eTun(i,:)  = squeeze(std(my,0,1)/sqrt(length(inx)));   
    
    dr = squeeze(mean(D.(dtype){inx_scan}(inx,5:6,:),2));
    db = squeeze(mean(D.(dtype){inx_scan}(inx,4,:),2));
    if i ==1,
        dR = NaN*ones(size(dr,1),8,size(dr,2));
        dB = dR;
    end
    dR(:,i,:)=dr;
    dB(:,i,:)=db;
    
end

ncell = size(dR,3);
ps = inf*ones(1,ncell);
for i = 1:ncell
    x = dR(:,:,i);
    if ~any(isnan(x))
        ps(i) = anova1(x,[],'off');
    end
end

inxcell = find(ps<0.05);

peakinx = zeros(1, max(inxcell));
for i0 = 1 : length(inxcell)
    i = inxcell(i0);
    if mod(i0,35)==1,
%         figure;
        k = 1;
    end
%     subplot(7,5,k);
%     errorbar(Tun(:,i),eTun(:,i));
    [~,peakinx(i) ]= max(Tun(:,i));
%     title(num2str(i));
    k = k+1;    
end


%
mp = nanmean(dR,3);
pTun= mean(mp,1);
epTun = std(mp,0,1)/sqrt(size(mp,1));    
%     
% figure; 
% errorbar([22.5:22.5:180],pTun, epTun);

%% oddball


inx_scan0= 1 % orientation tuning scan
cidx0 = cond_idx{inx_scan0};



inx_scan=2; % block oddball scan
dtype='nhat';
cidx = cond_idx{inx_scan};


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


inx1 =  find(peakinx>=2&peakinx<=2); % short distance to adapter
inx2=  find(peakinx==4 | peakinx==8); % medium distance
inx3 =  find(peakinx>=5 &peakinx<=7);  %far distance

inxcellS = [inx1];

% C: 1 trial prior to odd stimulus (most adaptive)
% C0 : first trials in each block (kind of standard)
% O : oddball trials
C = cell(1,nblk);
C0 = cell(1,nblk);
O = cell(1,nblk);
inxresp=5:7;
inxbase =4;

dat = squeeze(mean(D.(dtype){inx_scan0}(:,inxresp,inxcellS),2));
uo = unique(cidx0);
x = cell(1,length(uo));
for io = 1:length(uo)
    x{io}= mean(dat(cidx0==uo(io),:),1);
end
x = cell2mat(x');
norm = max(x,[],1);
dat = bsxfun(@rdivide, dat, norm);
dat = mean(dat,2);

uo = unique(cidx0);
Ctrl = cell(1,length(uo));
for io = 1:length(uo)
    Ctrl{io}=dat(cidx0==uo(io));
end


for iblk = 1 : nblk

    dat = squeeze(mean(D.(dtype){inx_scan}(:,inxresp,inxcellS),2));

    dat = bsxfun(@rdivide, dat, norm);
    dat = nanmean(dat,2);
    
    O{iblk} =dat(inx_odd{iblk});
    
    inx = inx_odd{iblk}-1;       
    C{iblk} = dat(inx);
    
    
    inx = inx_com{iblk}(1:length(inx_odd{iblk}));
    C0{iblk} = dat(inx);
end
    
% C = cell2mat(C);
% C0 = cell2mat(C0);
% O = cell2mat(O);

C1 = cell2mat(C(:,1:2:end)); % 45deg block
C2 = cell2mat(C(:,2:2:end));  % 135 deg block
C01 = cell2mat(C0(:,1:2:end));
C02 = cell2mat(C0(:,2:2:end));


O1 = cell2mat(O(:,1:2:end));
O2 = cell2mat(O(:,2:2:end));
X1=[mean(Ctrl{2}) mean(C01(:)) mean(C1(:)), mean(O2(:))];
X2=[ mean(Ctrl{6}) mean(C02(:)) mean(C2(:)) mean(O1(:))];
eX1 =[std(Ctrl{2})/sqrt(numel(Ctrl{2})), std(C01(:))/sqrt(numel(C01)),...
    std(C1(:))/sqrt(numel(C1)), std(O1(:))/sqrt(numel(O1))];
eX2 = [std(Ctrl{6})/sqrt(numel(Ctrl{6})), std(C02(:))/sqrt(numel(C02)),...
    std(C2(:))/sqrt(numel(C2)), std(O2(:))/sqrt(numel(O2))];

% X0 = mean(nanmean(dR(:,[2 6],inxcellS),3),1);
% eX0 = std(nanmean(dR(:,[2 6],inxcellS),3),0,1)/sqrt(size(X0,1));

figure; 
hold on;
errorbar(X1, eX1,'b');
errorbar(X2, eX2,'r');
legend('45deg','135deg');
set(gca,'xtick',[1 2 3 4]);
set(gca,'xticklabel',{'ctrl','com0','com','odd'});

