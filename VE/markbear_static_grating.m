clear key
key.animal_id = 'SL_thy1_0220_ML';
key.session_id = '0527_D1';
key.scan_id = 1;
% long-term habituation (markbear)
key(2).animal_id = 'SL_thy1_0220_ML';
key(2).session_id = '0603_D8';
key(2).scan_id = 2;

% 
% clear key
% key.animal_id = 'SL_thy1_0220_MR';
% key.session_id = '0527_D1';
% key.scan_id = 1;
% % long-term habituation (markbear)
% key(2).animal_id = 'SL_thy1_0220_MR';
% key(2).session_id = '0604_D9';
% key(2).scan_id = 3;

[D.nhat,D.dff,D.dffn,frtime,cond_idx]=...
    fetchn(slee_tp_ve.Datsort&key,'nhat','dff','dffn','frtime','cond_idx');
dtype='nhat'




dR = cell(1,2);
dB = cell(1,2);
Tun = cell(1,2);
eTun = cell(1,2);
inxcell = cell(1,2);
for inx_scan = 1:2
    cid = cond_idx{inx_scan};
    y = D.(dtype){inx_scan};
    X = zeros(size(y));

    Tun{inx_scan} = zeros(8,size(y,3));
    eTun{inx_scan} =zeros(8,size(y,3));


    for i = 1 : 8
        inx = find(cid==i);    
        my = mean(y(inx,5:6,:),2);
        Tun{inx_scan}(i,:)  = squeeze(mean(my,1));   
        eTun{inx_scan}(i,:)  = squeeze(std(my,0,1)/sqrt(length(inx)));   

        dr = squeeze(mean(D.(dtype){inx_scan}(inx,5:6,:),2));
        db = squeeze(mean(D.(dtype){inx_scan}(inx,4,:),2));
        if i ==1,
            dR{inx_scan} = NaN*ones(size(dr,1),8,size(dr,2));
            dB{inx_scan} = NaN*ones(size(dr,1),8,size(dr,2));
            ntr0 = size(dr,1);
        end
        ntr= size(dr,1);
        ntr = min(ntr,ntr0);
        dR{inx_scan}(1:ntr,i,:)=dr(1:ntr,:);
        dB{inx_scan}(1:ntr,i,:)=db(1:ntr,:);

    end

    ncell = size(dR{inx_scan},3);
    ps = inf*ones(1,ncell);
    for i = 1:ncell
        x = dR{inx_scan}(:,:,i);
        if ~any(isnan(x))
            ps(i) = anova1(x,[],'off');
        end
    end

    inxcell{inx_scan} = find(ps<0.05);
end

inxcell_com = intersect(inxcell{1},inxcell{2});

% mean population of pre and post
inx = inxcell_com;
pTun = zeros(8,length(inx_scan));
epTun = pTun;
for inx_scan = 1:2
    mp = nanmean(dR{inx_scan}(:,:,inx),3);
    pTun(:,inx_scan)= mean(mp,1);
    epTun(:,inx_scan) = std(mp,0,1)/sqrt(size(mp,1));    
end   
figure; hold on;
errorbar(22.5:22.5:180,pTun(:,1), epTun(:,1),'b');
errorbar(22.5:22.5:180,pTun(:,2), epTun(:,2),'r');
legend('pre','post')
title('population tuning function pre-/post-learning')


% ratio 

mp1 = nanmean(dR{1}(:,:,inx),1);
mp2 = nanmean(dR{2}(:,:,inx),1);
pTun= mean(mp2./mp1,3);
epTun = std(mp2./mp1,0,3)/sqrt(size(mp1,3));    

figure; hold on;
errorbar([22.5:22.5:180],pTun, epTun,'b');
title('response change ratio of single cells')


% tuning changes
clr ={'b','r'}
for i0 = 1 : length(inxcell_com)
    i = inxcell_com(i0);
    if mod(i0,35)==1,
        figure;
        k = 1;
    end
    subplot(5,7,k);
    hold on;
    for inx_scan = 1:2
        mp = dR{inx_scan}(:,:,i);
        Tun= mean(mp,1);
        eTun = std(mp,0,1)/sqrt(size(mp,1));    
        errorbar(Tun,eTun,clr{inx_scan});
    end   
    k = k+1;
    
end

%%

[inxcell_pre,peakinx_pre,ucid]= get_coarseORItun(D,'nhat',cond_idx,1,5:6);
[inxcell_post,peakinx_post,ucid]= get_coarseORItun(D,'nhat',cond_idx,2,5:6);

inxcell_com = intersect(inxcell_pre,inxcell_post);
inxcell_45pref = find(peakinx_pre>=1 & peakinx_pre<=3);
inxcell_com = intersect(inxcell_com,inxcell_45pref);
% mean population of pre and post
inx = inxcell_com;
pTun = zeros(8,length(inx_scan));
epTun = pTun;
for inx_scan = 1:2
    mp = nanmean(dR{inx_scan}(:,:,inx),3);
    pTun(:,inx_scan)= mean(mp,1);
    epTun(:,inx_scan) = std(mp,0,1)/sqrt(size(mp,1));    
end   
figure; hold on;
errorbar(22.5:22.5:180,pTun(:,1), epTun(:,1),'b');
errorbar(22.5:22.5:180,pTun(:,2), epTun(:,2),'r');
legend('pre','post')
title('population tuning function pre-/post-learning')

%% relative ratio of cells sharing  preferred orientation
% but different cell population between pre - and post tests
prefOinx =1

inxcell0 = cell(1,2);
peakinx = cell(1,2);
[inxcell0{1},peakinx{1}]= get_coarseORItun(D,'nhat',cond_idx,1,5:7);
[inxcell0{2},peakinx{2},ucid]= get_coarseORItun(D,'nhat',cond_idx,2,5:7);
 
inxcell = cell(1,2);
inxcell_pref = find(peakinx{1}==prefOinx);
inxcell{1} = intersect(inxcell0{1},inxcell_pref);
inxcell_pref = find(peakinx{2}==prefOinx);
inxcell{2} = intersect(inxcell0{2},inxcell_pref);
% mean population of pre and post

pTun = zeros(8,length(inx_scan));
epTun = pTun;
for inx_scan = 1:2
    X = dR{inx_scan}(:,:,inxcell{inx_scan});
    X0 = dR{inx_scan}(:,:,inxcell0{inx_scan});
    nX = bsxfun(@rdivide,X, nanmean(X0,3));
    mp = nanmean(nX,3);
    pTun(:,inx_scan)= mean(mp,1);
    epTun(:,inx_scan) = std(mp,0,1)/sqrt(size(mp,1));    
end   
figure; hold on;
errorbar(22.5:22.5:180,pTun(:,1), epTun(:,1),'b');
errorbar(22.5:22.5:180,pTun(:,2), epTun(:,2),'r');
legend('pre','post')
title('population tuning function pre-/post-learning')

%% signal/noise correlation
inxcell = cell(1,2);
peakinx = cell(1,2);
dtype ='nhat';
inxresp = 5:6;
[inxcell{1},peakinx{1}]= get_coarseORItun(D,dtype,cond_idx,1,inxresp);
[inxcell{2},peakinx{2}]= get_coarseORItun(D,dtype,cond_idx,2,inxresp);

% separate two stim group 
% one is close to 45 deg
% the other is close to 135 deg
% training orientation is 45 deg
inxgrp = {[1 2 3], [5 6 7]}; 
SCA = NaN(length(inxgrp),length(inxgrp),2);
eSCA = NaN(length(inxgrp),length(inxgrp),2);
NCA = NaN(length(inxgrp),length(inxgrp),2,length(inxgrp));
eNCA = NaN(length(inxgrp),length(inxgrp),2,length(inxgrp));
for is = 1 : 2
    X = D.(dtype){is};
    cidx = cond_idx{is};
    cg = contgain(X,{'ori_idx'},cidx);
    [SC,NC,uevt] = cg.get_corr(inxcell{is},inxresp,'ori_idx');
    NCi = NaN(size(NC,1), size(NC,2),2);
    for igrp = 1: length(inxgrp)
        NCi(:,:,igrp) = mean(NC(:,:,inxgrp{igrp}),3);
    end
    peakinx1 = peakinx{is}(inxcell{is});
    for j1 = 1: length(inxgrp)
        for j2 = 1 : length(inxgrp)
            inxc1  = ismember(peakinx1,inxgrp{j1});
            inxc2  = ismember(peakinx1,inxgrp{j2});
            M =tril(SC(inxc1,inxc2),-1);
            tmp =tril(ones(size(M)));
            inx1 = find(tmp(:)==1);
            SCA(j1,j2,is) = mean(M(inx1));
            eSCA(j1,j2,is) = std(M(inx1))/sqrt(length(inx1));
            
            for k = 1: length(inxgrp)
                M =tril(NCi(inxc1,inxc2,k),-1);
                NCA(j1,j2,is,k) = mean(M(inx1));
                eNCA(j1,j2,is,k) = std(M(inx1))/sqrt(length(inx1));
            end
            
           
        end
    end
end

figure; 
errorbar([diag(SCA(:,:,1)) diag(SCA(:,:,2))],...
    [diag(eSCA(:,:,1)) diag(eSCA(:,:,2))]) 

figure; 
hold on;
errorbar([diag(NCA(:,:,1,1)) diag(NCA(:,:,2,2))],...
    [diag(eNCA(:,:,1,1)) diag(eNCA(:,:,2,2))]) 



%% adaptation
[inxcell_pre,peakinx_pre]= get_coarseORItun(D,'nhat',cond_idx,1,5:6);
[inxcell_post,peakinx_post]= get_coarseORItun(D,'nhat',cond_idx,2,5:6);

inxcell_com = intersect(inxcell_pre,inxcell_post);

% adaptation effect
key = struct;
key.animal_id = 'SL_thy1_0220_ML';
key.session_id = '0527_D1';
key.scan_id = 5;
[DA.nhat,DA.dff,DA.dffn,frtime,condA_idx]=...
    fetchn(slee_tp_ve.Datsort&key,'nhat','dff','dffn','frtime','cond_idx');
dtype='nhat'

inx_scan=1;
nhat = DA.nhat{inx_scan};
cidx = condA_idx{inx_scan};
adpi = 2; % 45

nblk = 5;
n_blk = length(cidx)/nblk;
idxtA = cell(1,nblk);
idxtT = cell(1,nblk);
for i = 1 : nblk
    J = n_blk*(i-1)+1:n_blk*i;
    cidxb = cidx(J);
    
    inx1 = diff(cidxb);
    inx2 = [0; inx1(1:end-1)];
    a =find(inx1==0 & inx2==0);
    idxtA{i}= [a; a(end)+1]+J(1);
    idxtT{i} = setdiff(J,idxtA{i});
end

ir = 5:6;
ib = 4;

ph1 = cell(1,nblk);
ph2 = cell(1,nblk);
ph3 = cell(1,nblk);
for i = 1: nblk
    I = idxtT{i};    
    ph1{i} = I(1: floor(length(I)/3));
    ph2{i} = I(floor(length(I)/3)+1: floor(length(I)*2/3));
    ph3{i} = I(floor(length(I)*2/3)+1: end);    
end

Iph{1} = cell2mat(ph1);
Iph{2} = cell2mat(ph2);
Iph{3} = cell2mat(ph3);
N = zeros(3,8);
dRA = cell(3,8);
for iori = 1 : 8
    for iph = 1 : 3
        J = cidx(Iph{iph})==iori;
        itr = Iph{iph}(J);
        N(iph,iori) = length(itr);
        x= squeeze(nanmean(nhat(itr,ir,:),2));
        dRA{iph,iori}=x';  
    end    
end
fun1 = @(x)mean(x,2);
fun2 = @(x)std(x,0,2);
ATun = cellfun(fun1,dRA,'UniformOutput' , false);
eATun    = cellfun(fun2,dRA,'UniformOutput' , false);
ATuni = cell2mat(ATun(1,:))';
eATuni= bsxfun(@rdivide,cell2mat(eATun(1,:)),sqrt(N(1,:)))';

% tuning changes
clr ={'b','r','g'}
for i0 = 1 : length(inxcell_com)
    i = inxcell_com(i0);
    if mod(i0,35)==1,
        figure;
        k = 1;
    end
    subplot(5,7,k);
    hold on;
    for inx_scan = 1:2
        mp = dR{inx_scan}(:,:,i);
        Tun= mean(mp,1);
        eTun = std(mp,0,1)/sqrt(size(mp,1));    
        errorbar(Tun,eTun,clr{inx_scan});
    end   
    errorbar(ATuni(:,i),eATuni(:,i),clr{3});
    k = k+1;
    
end

