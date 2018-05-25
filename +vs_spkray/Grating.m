%{
# vs_spkray.Grating (Manual)
->vs_spkray.Condition
-----

stimcenter_x=0 : float # stimulus center in deg, 0 = screen center
stimcenter_y=0 : float # stimulus center in deg, 0 = screen center
stimrad      : float # stimulus radius in deg
stimmargin=0   : float # stimulus margin in deg
gratingwaveform ='square' : enum('sine','square') 
contrast      : float # in %
orientation   : float # in degree
sf            : float # cycle/deg
tf            : float # Hz
dir=1         : smallint # drifting direction: -1, 0, 1, dir=0 for static
ph = 0        : float # in radian    0 to pi
grating_ts = CURRENT_TIMESTAMP : timestamp  # automatic


%}

classdef Grating < dj.Manual
end