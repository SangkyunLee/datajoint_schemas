%{
#slee_tp_ve.Oritun4comcell
->slee_tp_ve.Gratingexp
dtype : varchar(20) # datatype

-----
# add additional attributes
oritun : blob # orientation tuning
sem_oritun : blob # sem of orientation tuning
ori : tinyblob # orientation
dimorder : varchar(256) # 
contrast : tinyblob # visual contrast
%}

classdef Oritun4comcell < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			 
            Info = fetch(slee_tp_ve.Gratingexp&key,'*');
            cont = fetchn(vs_spkray.Grating&key,'contrast');
            ucont = unique(cont);
            dtype ={'nhat','dff','dffn'};
            
            ORI = ORItun(Info,key);
            
            for j = 1: length(dtype)
                
                
                for i = 1: length(ucont)
                           
                    [tun,etun,ori]=get_oritun(ORI,dtype{j},[],ucont(i),true);    
                    if i==1,
                        tun1 = NaN([size(tun{1}),length(tun), length(ucont)]);
                        etun1 = tun1;
                    end
                    for iscan = 1 :length(tun)                        
                        tun1(:,:,iscan,i)=tun{iscan};
                        etun1(:,:,iscan,i)=etun{iscan};
                    end
                    
                end
                table = key;
                table.dtype = dtype{j};
                table.oritun = tun1;
                table.sem_oritun =etun1;
                table.ori = ori;
                table.contrast = ucont;
                table.dimorder ='ori/cell/scan/contrast';
                self.insert(table);
            end
		end
	end

end