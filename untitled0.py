# -*- coding: utf-8 -*-
"""
Created on Tue Jun 12 11:51:15 2018

@author: slee
"""

import datajoint as dj
import numpy as np


#ve = dj.schema('slee_tp_ve', locals())
#dj.ERD(schema).draw()




VE = dj.create_virtual_module('VEa','slee_tp_ve')
