function b = check_stmval(key)
    key2 = struct('animal_id',key.animal_id,...
        'session_id',key.session_id);
    grpnames = fetchn(vs_spkray.Stimgrp&key2,'grp_id');
    b = false;
    for i = 1: length(grpnames)
        if ~isempty(strfind(grpnames{i},'oddball')) || ...
                ~isempty(strfind(grpnames{i},'adapt'))
            b = true;
            break;

        end            

    end
end