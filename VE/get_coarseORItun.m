function [inxcell,peakinx,ucid]= get_coarseORItun(D,dtype,cond_idx,inx_scan,inxframe)
cid = cond_idx{inx_scan};
y = D.(dtype){inx_scan};
ucid = unique(cid);

Tun = zeros(length(ucid),size(y,3));

for i = 1 : length(ucid)
    inx = find(cid==ucid(i));    
    my = mean(y(inx,inxframe,:),2);
    Tun(i,:)  = squeeze(mean(my,1));   

    dr = squeeze(mean(D.(dtype){inx_scan}(inx,inxframe,:),2));
%     db = squeeze(mean(D.(dtype){inx_scan}(inx,4,:),2));
    if i ==1,
        dR = NaN*ones(size(dr,1),8,size(dr,2));
%         dB = dR;
    end
    dR(:,i,:)=dr;
%     dB(:,i,:)=db;
    
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
    [~,peakinx(i) ]= max(Tun(:,i));
end


