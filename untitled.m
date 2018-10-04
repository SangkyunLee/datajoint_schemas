
key.animal_id ='SL_SST_0416_MC'
key.session_id='0814'
key.fov='FOV1'

dff = fetchn(pl_pr.Deconvsang&key,'dff');
celinx = fetchn(slee_tp_oddball.Selvrcell&key,'cell_nhat')

c1 = celinx{2};
df1 = dff{2};

a=bsxfun(@plus,df1(:,c1(1:60)),cumsum(4*ones(1,60)));
figure; plot(a)