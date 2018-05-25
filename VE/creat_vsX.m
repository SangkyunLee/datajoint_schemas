function [vs, table] = creat_vsX(d1)

switch d1.fn
    case{'GratingExperiment2PhotonbySang.mat'}

        vs = dj_vsGrating(d1.stim_path,d1.fn);
        table = vs_spkray.Grating;
    case{'SquareMappingExperiment2Photon.mat'}
        vs = dj_vsSquaremap(d1.stim_path,d1.fn);
        table = vs_spkray.Squaremap;
    otherwise
        error('%s not implemented yet',d1.fn);
end