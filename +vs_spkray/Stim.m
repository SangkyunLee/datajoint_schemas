%{
# Stim
stimfilename :varchar(50)
-----
classname : varchar(50)
%}

classdef Stim < dj.Lookup
    properties
        contents={
            'GratingExperiment2PhotonbySang.mat' 'Grating'
            'SquareMappingExperiment2Photon.mat' 'Squaremap'
            }
        
    end
end