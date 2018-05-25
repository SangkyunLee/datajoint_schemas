function [vs, table]=creat_vsX(header)
% function [vs, table] =creat_vsX(header)
% create object for dj_vs and get specific table pointer
% 2018-05-15


    fn = header.fn;
    fn1 = strsplit(fn,'.');

    fn1 = fn1{1};
    switch fn1
        case {'GratingExperiment2PhotonbySang'}
            vs = dj_vsGrating(header);
            table = vs_spkray.Grating;
        case {'SquareMappingExperiment2Photon'}
            vs = dj_vsSquaremap(header);
            table = vs_spkray.Squaremap;
        otherwise
            vs=[];
            table=[];
            warning('%s not implemented yet',fn);
    end
end
