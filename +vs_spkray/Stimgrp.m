%{
# vs_spkray.Stimgrp (manual) : This is vstim group within session
->vs_spkray.Session
grp_id :varchar(20) # stimgroup id
----
stimgrp_ts = CURRENT_TIMESTAMP : timestamp  # automatic
%}

classdef Stimgrp < dj.Manual
end