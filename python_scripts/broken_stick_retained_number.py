import json
import sys, argparse
import numpy as np
import random
import glob
import pandas as pd
import csv

study='EcritApp'

init_dir='/scratch/jsein/BIDS/'+study

list=glob.glob(init_dir+'/derivatives/fmriprep/sub*/func/*timeseries.json')
#list=[ x for x in list if "037" not in x]
list.sort()

data=[]

for json_file in list:
#json_file=init_dir+'/brokensticks/sub-005_task-regularity_run-1_desc-confounds_timeseries.json'
    #print(json_file)


    with open(json_file, 'r') as json_file:
        js = json.load(json_file)

    a_comp_cor_csf, a_comp_cor_wm = ([] for _ in range(2))
    a_comp_cor_csf_var, a_comp_cor_wm_var = ([] for _ in range(2))

    dropped_csf, dropped_wm = ([] for _ in range(2))
    dropped_csf_var, dropped_wm_var = ([] for _ in range(2))
        
    for i in js.keys():
        if i.startswith('a_comp_cor'):
            if js[i]['Mask'] == 'CSF' and js[i]['Retained']:
                    a_comp_cor_csf.append(i)
                    a_comp_cor_csf_var.append(js[i]['VarianceExplained'])
                
            if js[i]['Mask'] == 'WM' and js[i]['Retained']:
                a_comp_cor_wm.append(i)
                a_comp_cor_wm_var.append(js[i]['VarianceExplained'])

    a_comp_cor_csf.sort(key=lambda x: '{0:0>18}'.format(x).lower())
    a_comp_cor_wm.sort(key=lambda x: '{0:0>18}'.format(x).lower())
    a_comp_cor_wm_var.sort(reverse=True)
    a_comp_cor_csf_var.sort(reverse=True)

    for i in js.keys():
        if i.startswith('dropped'):
            if js[i]['Mask'] == 'CSF':
                    dropped_csf.append(i)
                    dropped_csf_var.append(js[i]['VarianceExplained'])
                
            if js[i]['Mask'] == 'WM':
                dropped_wm.append(i)
                dropped_wm_var.append(js[i]['VarianceExplained'])

    dropped_csf.sort(key=lambda x: '{0:0>18}'.format(x).lower())
    dropped_wm.sort(key=lambda x: '{0:0>18}'.format(x).lower())
    dropped_wm_var.sort(reverse=True)
    dropped_csf_var.sort(reverse=True)

    total_csf=len(dropped_csf) + len(a_comp_cor_csf) 
    total_wm=len(dropped_wm) + len(a_comp_cor_wm) 

    new_csf=a_comp_cor_csf +dropped_csf
    new_csf_var=a_comp_cor_csf_var +dropped_csf_var
    new_wm=a_comp_cor_wm +dropped_wm
    new_wm_var=a_comp_cor_wm_var +dropped_wm_var


#calculate broken sticks values for wm

#n = len(a_comp_cor_wm)  
#display(n)
    n=len(new_wm)
    l=1/n
    brokensticks = ([])
    brokensticks.append(1/n)
    for i in range (1,n):
        l=l+1/(n+1-(i+1))
        brokensticks.append(l)

    new=([])
    for i in brokensticks:
        new.append(i/n)    

    new.reverse()


#calculate retained components

    nb_wm=0
    for i in range(0,len(new_wm)):
        if new_wm_var[i] > new[i]:
            nb_wm=nb_wm+1
        else:
            break
    
    #print('the number of wm retained is',nb_wm)        

#p = len(a_comp_cor_wm) 



#calculate broken sticks values for csf

    d = len(new_csf) 

    l=1/d
    brokensticks = ([])
    brokensticks.append(1/d)
    for i in range (1,d):
        l=l+1/(d+1-(i+1))
        brokensticks.append(l)

    bs=([])
    for i in brokensticks:
        bs.append(i/d)    

    bs.reverse()

#number of compoenets retained in CSF
    nb_csf=0
    for i in range(0,len(new_csf)):
        if new_csf_var[i] > bs[i]:
            nb_csf=nb_csf+1
        else:
            break
    
    data.append([json_file.name,nb_wm,nb_csf])
df = pd.DataFrame(data, columns = ['Run_name', 'WM_retained','CSF_retained'])
df.to_csv("EcritApp_brokensticks_new2.tsv", sep="\t", index=False)
