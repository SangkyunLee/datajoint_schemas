table.animal_id ='SL_thy1_0206_MB';
table.learnses_id = 1;
table.start_sesid= '0418_D1';
table.start_date= '2018-04-18';
table.end_sesid = '0502_D15';%{'0425_D8','0501_D14'};
table.end_date= '2018-05-02';
table.learning_stim ='grating_D60_cont100'
insert(slee_tp_ve.Seslearn,table);

slee_tp_ve.Datsort

rel = slee_tp_ve.Seslearn*common.Session&...
    'session_date between start_date and end_date';

slee_tp_ve.Datsort&(vs_spkray.Scan&'grp_id="cont-ori-48R"')&rel
