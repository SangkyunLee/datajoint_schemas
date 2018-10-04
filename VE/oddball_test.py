# -*- coding: utf-8 -*-
"""
Created on Tue Jun 12 11:51:15 2018

@author: slee
"""

import datajoint as dj
import numpy as np
import scipy.stats as stats

#ve = dj.schema('slee_tp_ve', locals())
#dj.ERD(schema).draw()


#key.animal_id='SL_thy1_0220_ML'
#key.session_id ='0527_D1'
#inx_scan = 1;
key={'animal_id':'SL_thy1_0220_ML', 'session_id' :'0527_D1' }

VE = dj.create_virtual_module('VEa','slee_tp_ve')
rel =VE.Datsort()&key
nhat, dff, dffn, frtime, cond_idx = rel.fetch('nhat','dff','dffn','frtime','cond_idx' )
nscan =len(nhat)

#for i in range(0,nscan):
#    print(i)
#    

inx_scan=1

y=nhat[inx_scan-1]
cid = cond_idx[inx_scan-1]
ucid = np.unique(cid)
def indices(a, func):
    return [i for (i, val) in enumerate(a) if func(val)]


sz = y.shape;
Tun = np.zeros((len(ucid),sz[-1]));
eTun = np.zeros((len(ucid),sz[-1]));
                
for k in range(len(ucid)):   
    i = ucid[k];
    inds = indices(cid, lambda x:x==i)
    x=np.mean(y[inds,4:6,:],axis=1);
    Tun[k,:] = np.mean(x,axis=0);
    n = len(inds)
    eTun[k,:] = np.std(x,axis=0)/np.sqrt(n);
    if k==0:
        dr = np.zeros((n,len(ucid),sz[-1]));
    dr[:,k,:]=x;


sz = dr.shape
pval = np.ones((sz[-1]))
for i in range(sz[-1]):
    x = dr[:,:,i]
    p= stats.f_oneway(*x)
    pval[i]=p.pvalue
cellinx = indices(pval, lambda x:x<0.05)

