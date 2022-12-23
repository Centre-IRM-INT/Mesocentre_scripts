import os,sys,glob,json,argparse
import pandas as pd
import numpy as np
import random
from matplotlib import pyplot as plt
import statistics
import csv
import seaborn as sns

study='EcritApp'

init='/scratch/jsein/BIDS/'+study+'/derivatives'
list_sub=[dir for dir in glob.glob(init+'/fmriprep/sub*') if os.path.isdir( dir)]
mylist = ' '.join(list_sub).replace(init+'/fmriprep/','').split()
mylist.sort()
#print(mylist)
myList = []


for sub in mylist:
    for run in range(1,5):
        if os.path.isfile(init+'/fmriprep/'+sub+'/func/'+sub+'_task-regularity_run-'+str(run)+'_desc-confounds_timeseries.tsv'): 
            data=pd.read_csv(init+'/fmriprep/'+sub+'/func/'+sub+'_task-regularity_run-'+str(run)+'_desc-confounds_timeseries.tsv',sep= '\t' )
            json_file=init+'/fmriprep/'+sub+'/func/'+sub+'_task-regularity_run-'+str(run)+'_desc-confounds_timeseries.json'
            print(json_file)
            with open(json_file, 'r') as json_file:
                js = json.load(json_file)
            a_comp_cor_csf, a_comp_cor_wm = ([] for _ in range(2))
            for i in js.keys():
                if i.startswith('a_comp_cor'):
                    if js[i]['Mask'] == 'WM' and js[i]['Retained']:
                        a_comp_cor_wm.append(i)
            a_comp_cor_wm.sort(key=lambda x: '{0:0>18}'.format(x).lower())
            compo_wm_name=a_comp_cor_wm[0]
            csf = data['csf']
            wm = data['white_matter']
            column_1 = data['a_comp_cor_00']
            column_2 = data[compo_wm_name]
            correlation1 = csf.corr(column_1)
            correlation2 = csf.corr(column_2)
            correlation3 = wm.corr(column_1)
            correlation4 = wm.corr(column_2)
            myList.append([sub+'_task-regularity_run-1_desc-confounds_timeseries.tsv',correlation1, correlation2, correlation3, correlation4])
            #print(sub+'_task-regularity_run-1_desc-confounds_timeseries.tsv',correlation1, correlation2, correlation3, correlation4)
df = pd.DataFrame(myList, columns=['Run','Cor_CSF_acompcorCSF','Cor_CSF_acompcorWM','Cor_WM_acompcorCSF','Cor_WM_acompcorWM'])
df.to_csv(init+'/'+study+'_aCompCor_Corr.tsv',sep='\t',index=False)