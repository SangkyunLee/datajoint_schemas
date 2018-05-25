function plot_respchange(vsl, dtype,prec_cinx,fign)
    if nargin<4 || isempty(prec_cinx)
        prec_cinx = 1:length(vsl.cell_common);    
    end

    dataname = vsl.animal_id;
    prescaninx = (vsl.groups == grpid(1));    
    postscaninx = (vsl.groups == grpid(2)); 
    
    

    % get tunning functions from all the scans selected
    resptime = [0 0.5]; % timewindow for caculation of tuning function
    % resptime = [0 0.5]+0.1388; % timewindow for caculation of tuning function
    
    [y100]= ...
        get_oritun(vsl, dtype,resptime,100);
    [y40,  ~, ori]= ...
        get_tuning_scan(vsl.tp,vsl.vs,vsl.cell_common,vsl.cellinx, dtype,resptime,40);




    y100(y100(:)==0) =NaN;
    y40(y40(:)==0) =NaN;



    

    y100_pre = nanmean(y100(:,prec_cinx,prescaninx),3);
    y100_post = nanmean(y100(:,prec_cinx,postscaninx),3);
    y40_pre = nanmean(y40(:,prec_cinx,prescaninx),3);
    y40_post = nanmean(y40(:,prec_cinx,postscaninx),3);


    r100 = y100_post./y100_pre;
    r40  = y40_post./y40_pre;

    figure;
    hold on;
    errorbar(ori,mean(y100_pre,2),std(y100_pre,0,2)/sqrt(size(y100_pre,2)),'r--');
    errorbar(ori,mean(y100_post,2),std(y100_post,0,2)/sqrt(size(y100_post,2)),'r');
    errorbar(ori,mean(y40_pre,2),std(y40_pre,0,2)/sqrt(size(y40_pre,2)),'b--');
    errorbar(ori,mean(y40_post,2),std(y40_post,0,2)/sqrt(size(y40_post,2)),'b');

    legend('y100pre-pop','y100post-pop','y40pre-pop','y40post-pop')
    print(['./fig/' dataname '_' dtype fign '-1.tif'],'-dtiff')

    figure;
    hold on;
    plot(ori,mean(y100_post,2)./mean(y100_pre,2)-1,'r');
    plot(ori,mean(y40_post,2)./mean(y40_pre,2)-1,'b');
    legend('r100-pop','r40-pop')
    plot(ori,zeros(size(ori)),'k--');
    print(['./fig/' dataname '_' dtype fign '-2.tif'],'-dtiff')

    figure;
    hold on;
    errorbar(ori,mean(r100,2)-1,std(r100,0,2)/sqrt(size(r100,2)),'r');
    errorbar(ori,mean(r40,2)-1,std(r40,0,2)/sqrt(size(r40,2)),'b');
    legend('r100-ind','r40-ind')
    plot(ori,zeros(size(ori)),'k--');
    print(['./fig/' dataname '_' dtype fign '-3.tif'],'-dtiff')
    
     
    

end

