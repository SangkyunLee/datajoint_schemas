
[ses_id] = fetchn(slee_tp_oddball.Datasort,'session_id');


ses_id = unique(ses_id);

i =3;
qstr = sprintf('session_id ="%s"',ses_id{i}); 
[stmgrp_id,scan_id] = fetchn(vs_spkray.Scan & qstr,'grp_id','scan_id');

%%
scan_stmgrp = cell(max(scan_id),3);
for i = 1 : length(scan_id)
    scan_stmgrp{scan_id(i),2}=stmgrp_id{i};
end

[sid, depth]=fetchn(common.Tpscan&qstr,'scan_id','depth');
ustm = unique(stmgrp_id);
udepth = unique(depth);
for i = 1: length(sid)
    scan_stmgrp{sid(i),1}=find(udepth==depth(i));
end

% scan & stim group index
i = sid(1);
k=1;
scan_stmgrp{i,3}=k;
for j=i+1 : max(sid)
    
    if isempty(scan_stmgrp{j,1})
        continue;
    end
    if scan_stmgrp{j,1}==scan_stmgrp{i,1} &&...
            strcmp(scan_stmgrp{j,2},scan_stmgrp{i,2})
        scan_stmgrp{j,3}=k;
    else
        k = k+1;
        scan_stmgrp{j,3}=k;
        i=j;
    end
end
%% -------------------
rel1 = slee_tp_oddball.Oritun & qstr;
dat = fetch(rel1,'*');
rel2 = slee_tp_oddball.Selvrcell &qstr;
[sid, cellinx]= fetchn(rel2,'scan_id','cell_nhat');

for i = 1: length(dat)
    if dat(1).scan_id ~= sid(i)
        continue;
    end
    
end
    
    







