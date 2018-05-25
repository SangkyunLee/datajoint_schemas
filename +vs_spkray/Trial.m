%{
#  vs_spkray.Trial (manual) : This is vstim trial within each recording
->vs_spkray.Scan
trial_id : smallint unsigned #trial index
-----
->vs_spkray.Condition # stimulus condition index
stim_dur : float # stimulation duration in second
blank_dur : float # blank duration in second
trial_ts = CURRENT_TIMESTAMP : timestamp  # automatic
%}

classdef Trial < dj.Manual
end