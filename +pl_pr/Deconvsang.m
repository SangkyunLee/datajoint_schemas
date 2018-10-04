%{
# pl_pr.Deconvsang : deconvolution with Sang's algorithm
-> pl_pr.Ext
-----
parname : varchar(256) # estimation parameter names separated by '/'
parval : varchar(256) # estimation parameter values separated by '/'

a : longblob  # spatail filter
dff0 : longblob # dFF simply with a=1;
dff : longblob # obtained from optimal a estimated from algorithm
nhat : longblob # estimated spikerate
dffn : longblob # dff for neuropil with a=1;
suc :longblob  # with success, suc=1 otherwise =0 
deconvsang_ts=CURRENT_TIMESTAMP: timestamp 
%}

classdef Deconvsang < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
            
            % GCaMP6s : tau=0.85
            % GcaMP7f : tau =0.2;
            par = struct('dt',[],'dff_fac',[],'dffn_fac',0,...
                'rel_tol',0.05,'lambda1',10,...
                'tau',0.2,'chunk',1000,'ctm_scale',0.7,...
                'ndct_time',100, 'bspatial', true, 'F0cutoffthr',50);
            if par.bspatial
                par.dff_fac =3;
            else
                par.dff_fac =0;
            end
            
            rel = pl_pr.Syncvs2tpscan&key;
            if rel.count==0
                
            else
                [ft,t] = fetch1(rel,'frame_times','t');
            end
            [Fs, Fns ] = fetchn(pl_pr.ExtROI&key,'f','n');
            
            T = fetch1(pl_pr.Align&key,'nframes');
            if par.ndct_time>0,
                ndct = round(par.dt*T/par.ndct_time);            
            else
                ndct=0;
            end
            nc = length(Fs);
            key.suc = zeros(1,nc);
            key.a = cell(1, nc);
            key.dff = NaN(T,nc);
            key.dff0 = NaN(T,nc);
            key.nhat = NaN(T,nc);
            for ir = 1: nc
                F = double(Fs{ir});
                Fn = double(Fns{ir});
                
                if isempty(F)
                    key.suc(ir) =0;
                else
                    par.dt = mean(diff(t(ft==1)));
                    
                    [~, Beta, DCT]=applyhighDCTfilter(F,ndct);
                    F = F- DCT(:,2:end)*Beta(2:end,:);

                    [~, Beta, DCT]=applyhighDCTfilter(Fn,ndct);
                    Fn = Fn - DCT(:,2:end)*Beta(2:end,:);
                    F= bsxfun(@minus,F, par.ctm_scale*Fn);

                    if par.bspatial
                        F01 = zeros(1,size(F,2));
                        for inxp=1:size(F,2)
                           [mu,sigma] = normfit(F(:,inxp));
                           inxf = (F(:,inxp)<(mu + par.dff_fac*sigma));
                           F01(inxp) = mean(F(inxf,inxp));
                        end

                        inxpix_posF0 = find(F01>par.F0cutoffthr);

                        dFF1 = bsxfun(@rdivide,bsxfun(@minus,F(:,inxpix_posF0),...
                            F01(:,inxpix_posF0)),F01(:,inxpix_posF0));

                    else
                        mF1 =mean(F,1);
                        inxpix_posF0 = find(mF1>F0cutoffthr);
                        mF = mean(F(:,inxpix_posF0),2);
                        [mu,sigma] = normfit(mF);
                        inxf = (mF<(mu + dff_fac*sigma));
                        F01 = mean(mF(inxf));
                        dFF1 = (mF-F01)/F01;
                        par.MAX_ITER=10;

                    end

                    % estimate spike
                    [Nhat1, dFF2, a, ~, history1]=getspikes4(double(dFF1),par);
                    atmp = zeros(size(F01));
                    atmp(inxpix_posF0)=a;
                    a1 = atmp;

                    if ~isnan(history1.posts(end))
                        key.suc(ir) = 1;
                    else
                        key.suc(ir) = 0;
                    end

                    [mu,sigma] = normfit(Fn);
                    inxf = (Fn<(mu+par.dffn_fac*sigma));
                    Fn0 = mean(Fn(inxf));

                    dFFn = bsxfun(@rdivide,bsxfun(@minus,Fn,Fn0),Fn0);
                    key.dffn(:,ir) = dFFn(1:T);
                    key.a{ir} = a1;            
                    key.nhat(:,ir) = Nhat1(1:T);
                    key.dff0(:,ir) = mean(dFF1(1:T,:),2);
                    key.dff(:,ir) = mean(dFF2(1:T,:),2);

                end
                
                
                
                
            end
            [parname, parval] = convert(par);
            key.parname = parname;
            key.parval = parval;
		%!!! compute missing fields for key here
			 self.insert(key)
		end
	end


end

function [parname, parval] = convert(par)
    fn = fieldnames(par);
    parname = cell(1,length(fn));
    parval = cell(1, length(fn));
    for i = 1 : length(fn)
        parname{i} = [fn{i} '/'];
        parval{i} = [num2str(par.(fn{i})),'/'];
    end
    parname = cell2mat(parname);
    parval = cell2mat(parval);
    parname = parname(1:end-1);
    parval = parval(1:end-1);
end