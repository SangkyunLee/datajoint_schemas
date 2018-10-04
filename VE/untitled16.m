 rel=slee_tp_ve.Oritun4comcell&'animal_id="SL_thy1_0206_MB"'&...
     'dtype="dffn"'&'stmgrp_id="cont-ori-48R"';
 
 [oritun, sem,ori,order,cont]= fetchn(rel,'oritun','sem_oritun','ori','dimorder','contrast');
 
 pre=squeeze(nanmean(nanmean(oritun{1},3),2));
 post=squeeze(nanmean(nanmean(oritun{2},3),2));
 figure; plot(pre)
 figure; plot(post)
 
 figure; plot(post./pre)
 
 
 pre = squeeze(nanmean(oritun{1},3));
 post = squeeze(nanmean(oritun{2},3));
 ratio = post./pre;
 mr = squeeze(mean(ratio,2));
 er = squeeze(std(ratio,0,2)/sqrt(size(pre,2)));
 figure;  
errorbar(ori{1},mr(:,2),er(:,2))
 
 
%  
%  animal_id ='SL_thy1_0206_MB';
% ses_ids = {'0425_D8','0501_D14'};
% stmgrp = 'cont-ori-48R';
% dtype ='nhat'
% 
% vsl= GratingLearn(animal_id,ses_ids,stmgrp);
% [vsl, binx,rinx] = vsl.get_contgain;
% [vsl,  celln]= vsl.select_cell_vresp([],binx,rinx);
% 
%  vsl = vsl.get_common_cellinx;
%  
% ncell1 = mean(cellfun(@length,vsl.cellinx{1})./celln{1});
% ncell2 = mean(cellfun(@length,vsl.cellinx{2})./celln{2});
% fprintf('vresp_cell=%2.0f(pre),%2.0f(post) %%, pre-post_common_cell=%d\n',ncell1*100,ncell2*100,length(vsl.cell_common));
% 
% 
%  % plot_respchange(vsl,dtype,[],[])
%  
%  y100=vsl.CGA{1}(1).get_oritun(vsl.cell_common,'contrast',100);
 
 
 
 