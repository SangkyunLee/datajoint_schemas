% loading animal info
% xlsfn = '/media/sde_WD6T/slee_tp_data/doc/Animal.xlsx'
xlsfn = '/media/sde_WD6T/slee_tp_data/doc/SL_thy1_0206_MB.xlsx'
sheet =1;



finfo = xls2dj_session(xlsfn,sheet);
ses_inx = finfo.get_sessions(finfo.aniUIDs{1});

%% insert common.Animal
fldlist={'animal_id','dob','line','owner','sex','wdate'};
finfo.insert(common.Animal,ses_inx(1),fldlist);

%% insert common.Session
fldlist={'animal_id','session_id','session_date', 'pre_session_id','post_session_id'};
finfo.insert(common.Session,ses_inx,fldlist);

%% insert common.TTpscan
k=1;
failed = cell(1,length(ses_inx));
for inx = 1: length(ses_inx)
    try
        dat = finfo.finfo(ses_inx(inx));
        main_datpath='/media/sde_WD6T/slee_tp_data/VE/';

        ses_path = fullfile(main_datpath, dat.animal_id, dat.session_id);
        ss = xls2dj_Tpscan(ses_path,1, dat.animal_id, dat.session_id);
        ss = ss.autofill({'ch1_color','red','ch2_color','green',...
            'scanmethod','spiral','area','V1',...
            'dwell_time',0.8,'pixres',0.89,'objective','16x',...          
            'fov','FOV1','depth',145,'layer','L2/3'});
        ss = ss.gen_datfn;
        scanlist = ss.get_validscanlist;
        
        fldlist={'animal_id','session_id', 'scan_id', 'data_path',...
            'data_fn2','ch2_color', 'scanmethod','anesthesia',...
            'dwell_time','pixres','objective',...
            'area', 'layer', 'depth', 'laser_wavelength', 'fov','scan_notes'};

        ss = ss.create_datstr(fldlist,scanlist);
        ss = ss.insert(common.Tpscan, [],fldlist);
        
       
    catch
        fprintf('failed:%s,%s\n ',...
            dat.animal_id, dat.session_id);
        failed{k}=[inx ]';
        k = k+1;
    end

end



%% insert common.DAQ

k=1;
failed = cell(1,length(ses_inx));
for inx = 1: length(ses_inx)
    try
        dat = finfo.finfo(ses_inx(inx));
        main_datpath='/media/sde_WD6T/slee_tp_data/VE/';

        ses_path = fullfile(main_datpath, dat.animal_id, dat.session_id);
        if exist(ses_path,'dir')
            if exist(fullfile(ses_path,'rota'),'dir')
                ss = xls2dj_Daq(ses_path,1, dat.animal_id, dat.session_id,'rota');
            else
                ss = xls2dj_Daq(ses_path,1, dat.animal_id, dat.session_id,'2pimage');
            end
            ss = ss.autofill({'nch',4,'fs' 5000, 'frame_trigger',0,...
                'pd', 1, 'wheel_ch1',2,'wheel_ch2',3,'recorder','Pairie 5.4'});
            ss = ss.gen_datfn;
            scanlist = ss.get_validscanlist;
            fldlist={'animal_id','session_id', 'scan_id','data_path',...
                'data_fn','wheel_ch1','wheel_ch2' ,'recorder',...
                'nch','fs','frame_trigger','pd'};

            ss = ss.create_datstr(fldlist,scanlist);
                
            if ~exist(fullfile(ses_path,'2pimage'),'dir')
                fldlist0={'animal_id','session_id', 'scan_id'};
                ss = ss.insert(common.Tpscan, [],fldlist0);                
            end
            ss = ss.insert(common.Daq, [],fldlist);
            fprintf('completed session %s(inx:%d)\n',ss.session_id,inx);
            
        end
            
        
    catch
        fprintf('failed:%s,%s\n ',...
            dat.animal_id, dat.session_id);
        failed{k}=[inx ]';
        k = k+1;
    end

end

%% insert eye info

k=1;
failed = cell(1,length(ses_inx));
for inx = 1: length(ses_inx)
    try
        dat = finfo.finfo(ses_inx(inx));
        main_datpath='/media/sde_WD6T/slee_tp_data/VE/';

        ses_path = fullfile(main_datpath, dat.animal_id, dat.session_id);
        if exist(fullfile(ses_path,'eye'),'dir')
            
            ss = xls2dj_Eye(ses_path,1, dat.animal_id, dat.session_id,'eye');            
            ss = ss.autofill({'daq_ch1',1,'daq_ch2',2,'recorder','eyetrack_ver2.0'});
            ss = ss.gen_datfn;
            scanlist = ss.get_validscanlist;
            fldlist={'animal_id','session_id', 'scan_id', 'data_path',...
                'data_fn','daq_ch1','daq_ch2' ,'recorder'};

            ss = ss.create_datstr(fldlist,scanlist);
                
 
            ss = ss.insert(common.Eye, [],fldlist);
            fprintf('completed session %s(inx:%d)\n',ss.session_id,inx);
            
        end
            
        
    catch
        fprintf('failed:%s,%s\n ',...
            dat.animal_id, dat.session_id);
        failed{k}=[inx ]';
        k = k+1;
    end

end


%% insert vs_spkray.Session
finfo = xls2dj_session(xlsfn,sheet);
ses_inx = finfo.get_sessions(finfo.aniUIDs{1});
fldlist={'animal_id','session_id'};
finfo.insert(vs_spkray.Session,ses_inx,fldlist);


%% insert vs_spkray.Stimgrp and vs_spkray.Scan

finfo = xls2dj_session(xlsfn,sheet);
ses_inx = finfo.get_sessions(finfo.aniUIDs{1});
k=1;
failed = cell(1,length(ses_inx));
for inx = 1: length(ses_inx)
    try
        dat = finfo.finfo(ses_inx(inx));

        main_datpath='/media/sde_WD6T/slee_tp_data/VE/';
        ses_path = fullfile(main_datpath, dat.animal_id, dat.session_id);

        ss = xls2dj_vstpscan(ses_path,1, dat.animal_id, dat.session_id);
        vstim_path = fullfile(main_datpath, 'vstim');
        ss = ss.gen_stimfn(vstim_path,dat.session_date);
        scanlist = ss.get_validscanlist;
        
        datstr = ss.get_stimdatstr;
        insert(vs_spkray.Stimgrp,datstr);
        %--------------------
        fldlist={'animal_id','session_id', 'scan_id', 'stim_path',...
                        'fn','grp_id','ntrial' };
        ss = ss.create_datstr(fldlist,scanlist);
        ss = ss.insert(vs_spkray.Scan, [],fldlist);

        fprintf('completed session %s(inx:%d)\n',ss.session_id,inx);
    catch
        fprintf('failed:%s,%s\n ',...
            dat.animal_id, dat.session_id);
        failed{k}=[inx ]';
        k = k+1;
    end
end
%% insert vstim Condition,Trial and stimulus paramter
finfo = xls2dj_session(xlsfn,sheet);
ses_inx = finfo.get_sessions(finfo.aniUIDs{1});

failed = cell(1,100);
k=1;
for inx = 1: length(ses_inx)
    dat = finfo.finfo(ses_inx(inx));

    main_datpath='/media/sde_WD6T/slee_tp_data/VE/';
    ses_path = fullfile(main_datpath, dat.animal_id, dat.session_id);

    rel =vs_spkray.Scan & ...
        sprintf('animal_id = "%s"',dat.animal_id) & ...
        sprintf('session_id = "%s"',dat.session_id);

    dat = fetch(rel,'stim_path','fn','grp_id');
    [ugrp,inx2] = unique({dat.grp_id});
    for i = 1 : length(dat)

        d1 = dat(i);            
        % create vs object depending on stimulus type
        [vs, table] = creat_vsX(d1);
        vs = vs.gen_stimdat;
        try
            if find(inx2(:)'==i)                
                % insert vs_spkray.Condition
                datcond = vs.create_Condition;            
                insert(vs_spkray.Condition,datcond);            

                % insert vs_spkray.table(e.g., Grating..)
                vs= vs.create_datstr;
                vs = vs.insert(table);
            end

            % insert vs_spkray.Trial
            datTrial = vs.create_Trial;
            insert(vs_spkray.Trial,datTrial);
        catch

            fprintf('failed:%s,%s,%d\n ',...
                dat(i).animal_id, dat(i).session_id, dat(i).scan_id);
            failed{k}=[inx i length(dat)]';
            k = k+1;
        end

    end

end


