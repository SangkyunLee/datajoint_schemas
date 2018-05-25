%{
# vs_spkray.Scan (manual) : This is vstim for each Tpscan or recording
->vs_spkray.Session
scan_id : smallint # associated scan id
-----
->vs_spkray.Stimgrp # stimulustype group within session

stim_path='' : varchar(256) # vstim file location
fn ='' : varchar(256)   # vstim file name
ntrial: smallint # number of stimulation trial within scan


scan_ts = CURRENT_TIMESTAMP : timestamp  # automatic
%}

classdef Scan < dj.Manual
end