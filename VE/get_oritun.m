function [oritun_scan,  oritunerr_scan, ori]= ...
    get_oritun(vsl,dtype, resptime, contrast, bavg)

% function [oritun_scan,  oritunerr_scan, ori]= ...
%     get_tuning_scan(tp,vs,cinx1, cinx2,dtype, resptime, contrasts, bavg)

% cinx1: selected cells betwen behvgroups
% cinx2 : selected cells in scan specific way.
% oritun_scan: ori x cell x scan
    
    ises =1
    
    tp = vsl.tp{ises};
    sync = vsl.sync{ises};

    if ~exist('bavg','var')
        bavg = true;
    end
    cinx1 = vsl.cell_common;
    cinx2 = vsl.cellinx{ises};
    
    cinx1_0 = zeros(max(cinx1),1);
    cinx1_0(cinx1) = 1:length(cinx1);
    
    scan_id = fetchn(tp,'scan_id');
    
    for i = 1: length(scan_id)
        scanstr = sprintf('scan_id=%d',scan_id(i));
        tv = Trialvstim(tp&scanstr,sync&scanstr,dtype);
        
        
        [y,  ey,ori]=...
            get_oritun1(tv,cinx1, dtype, resptime,contrast,bavg);

        
        out= setdiff(cinx1,cinx2{i});
        out1 = cinx1_0(out);
        

        if bavg
            y(:,out1)=NaN;
            ey(:,out1)=NaN;

            if i==1
               oritun_scan = NaN*ones(length(ori),length(cinx1), length(tp));
               oritunerr_scan = oritun_scan;
            end
            oritun_scan(:,:,i) = y;        
            oritunerr_scan(:,:,i) = ey;
          
        else
            y(:,:,out1)=NaN;
            ey(:,:,out1)=NaN;


            if i==1
               oritun_scan = NaN*ones(length(ori),size(y,2),length(cinx1), length(tp));
               oritunerr_scan = oritun_scan;

            end
            oritun_scan(:,:,:,i) = y;
            oritunerr_scan(:,:,:,i) = ey;

        end
    end


end


function [y,  ey, ori]=...
    get_oritun1(tv,cinx, dtype, resptime, contrast,bavg)

%     cinx = cell index;
%     resptime = [0 0.5];

       
        Y = tv.sort_data_vstim(dtype, resptime);
        Y1 = NaN*ones(size(Y,1), size(Y,2), max(size(Y,3),max(cinx)));
        Y1(:,:,1:size(Y,3))=Y;

        ORI = contrast_gain (Y1, vs.param, vs.cond.event, vs.cond.StimEventLUT);


        [y, ey, ori] = ORI.get_oritun(cinx,'contrast',contrast);
        y(y(:)==0) =NaN; 
        ey(ey(:)==0) =NaN; 
        
        if bavg
            y = squeeze(nanmean(y,2));
            ey = squeeze(nanmean(ey,2));            
        end
end