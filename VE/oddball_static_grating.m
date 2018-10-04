
%%
clear key
key.animal_id='SL_thy1_0220_ML'
key.session_id ='0527_D1'
inx_scan = 1;
key.session_id ='0604_D9'
inx_scan = 2;

% clear key
% key.animal_id='SL_thy1_0220_MR'
% key.session_id ='0527_D1'
% inx_scan = 1;

[D.nhat,D.dff,D.dffn,frtime,cond_idx]=...
    fetchn(slee_tp_ve.Datsort&key,'nhat','dff','dffn','frtime','cond_idx');
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


inx_scan0= 2
cidx0 = cond_idx{inx_scan0};



inx_scan=3;
dtype='nhat';
cidx = cond_idx{inx_scan};

% d1 = [ diff(cidx)];
% d2 = [ d1(2:end); 0]; 
% d3 = [ 0; d1(1:end-1)]; 
% 
% 
% k12= find(d1==1 &d2==0 & d3==0)+1; % 1->2
% k21= find(d1==-1 &d2==0 & d3==0)+1; % 2->1
% k121= find(d1==1 &d2==-1 & d3==0)+1; %1-> 2->1
% k212= find(d1==-1 &d2==1 & d3==0)+1; %2-> 2->1
% % k=k121;
% % [cidx(k-2) cidx(k-1) cidx(k) cidx(k+1) cidx(k+2)]
% 
% 
% k1 = [[1;k21] k12-1];
% k2 = [k12 [k21-1; 1100]];
% inx_odd = cell(size(k1,1),2);
% inx_com = inx_odd;
% for iblk = 1 : size(k1,1)
%   i = find(k1(iblk,1)<k121 & k1(iblk,2)>k121);
%   inx_odd{iblk,1} = k121(i);  
%   inx_com{iblk,1} =  k1(iblk,1):inx_odd{iblk,1}-1;
% end
% for iblk = 1 : size(k2,1)
%   i = find(k2(iblk,1)<k212 & k2(iblk,2)>k212);
%   inx_odd{iblk,2} = k212(i);  
%   inx_com{iblk,2} =  k2(iblk,1):inx_odd{iblk,2}-1;
% end

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

inxcellS = [inx1];

C = cell(1,nblk);
C0 = cell(1,nblk);
O = cell(1,nblk);
inxresp=5:6;
% inxbase =4;

dat0 =mean(nanmean(D.(dtype){inx_scan0}(:,inxresp,inxcellS),3),2);
uo = unique(cidx0);
Ctrl = cell(1,length(uo));
for io = 1:length(uo)
    Ctrl{io}= dat0(cidx0==uo(io));
end


for iblk = 1 : nblk

    dat =nanmean(D.(dtype){inx_scan}(:,:,inxcellS),3);
    
    
    O{iblk} = mean(dat(inx_odd{iblk},inxresp),2);
    
    inx = inx_odd{iblk}-1;       
    C{iblk} = mean(dat(inx,inxresp),2);
    
    
    inx = inx_com{iblk}(1:length(inx_odd{iblk}));
    C0{iblk} = mean(dat(inx,inxresp),2);
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


%% time constant
Ptau = cell(1,nblk);
inxcellS = [inx1 inx2 inx3 ]; %inx3%
for iblk = 1 : nblk

    dat =nanmean(D.(dtype){inx_scan}(:,:,inxcellS),3);
    inx = inx_com{iblk};       
    Ptau{iblk} = mean(dat(inx,inxresp),2);    
end

Ptau1 = cell2mat(Ptau(1:2:end));
Ptau2 = cell2mat(Ptau(2:2:end));
figure; 
subplot(211);
errorbar(mean(Ptau1,2),std(Ptau1,0,2)/sqrt(5))
subplot(212);
errorbar(mean(Ptau2,2),std(Ptau2,0,2)/sqrt(5))

%------------adaptation-------------
x1 = (0 : 0.6 : (size(Ptau1,1)-1)*0.6)';
x = repmat(x1,[1 5]);
x = x(1:39,:);
y = Ptau1(1:39,:);

f1 = @(a,x) a(1)*exp(x*a(2))+a(3);
mx = mean(x,2);
my = mean(y,2);
a0=[mean(my(1:5))-mean(my(end-10:end)) -0.2 -mean(my(end-10:end))];
[a,resnorm,~,exitflag,output] = lsqcurvefit(f1,a0,x(:),y(:));
figure; hold on;
errorbar(mx,mean(Ptau1(1:39,:),2),std(Ptau1(1:39,:),0,2)/sqrt(5))
plot(mx,f1(a,mx));
title(['time constant=' num2str(-1/a(2))])

% -------------recovery-------------------
inxcellS = [inx1 inx2 inx3];
inx_odd1 = cell2mat(inx_odd(1:2:end));
x1 = bsxfun(@minus,inx_odd1,40+(0:220:220*4))*0.6;


inx_odd2 = cell2mat(inx_odd(2:2:end));
x2 = bsxfun(@minus,inx_odd2,40+(110:220:220*5))*0.6;


dat =mean(nanmean(D.(dtype){inx_scan}(:,inxresp,inxcellS),3),2);
y1 = reshape(dat(inx_odd1),size(x1));
y2 = reshape(dat(inx_odd2),size(x2));

x = [x2];
y = [y2];

f1 = @(a,x) a(1)*(exp(x*a(2)))+a(3);
mx = mean(x,2);
my = mean(y,2);
a0=[mean(my(1:2))-mean(my(end-2:end)) -0.2 -mean(my(end-2:end))];
[a,resnorm,~,exitflag,output] = lsqcurvefit(f1,a0,x(:),y(:));

figure; hold on;
%errorbar(mx,mean(y,2),std(y,0,2)/sqrt(5))
plot(x(:),y(:),'.');
plot(unique(x(:)),f1(a,unique(x(:))));
title(['time constant=' num2str(-1/a(2))])

% ---------- control stimulation
y = mean(nanmean(D.nhat{3}(:,inxresp,inxcellS),3),2);
x = 0:0.6:(length(y)-1)*0.6;

f1 = @(a,x) a(1)*exp(x*a(2))+a(3);

a0=[mean(y(1:5))-mean(y(end-5:end)) 50 mean(y(end-5:end))];
[a,resnorm,~,exitflag,output] = lsqcurvefit(f1,a0,x(:),y(:));


figure; hold on;
plot(y)
oddtr = cell2mat(inx_odd(2:2:end));
plot((oddtr(:)),y(oddtr(:)),'r.');

for i =1:10
plot(i*110*ones(1,2),[min(y) max(y)]);
end



