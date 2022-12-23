import os,sys,glob,csv
import pandas as pd

study='EcritApp'
FD_thr=0.9

init='/scratch/jsein/BIDS/'+study+'/derivatives/fmriprep'

list_sub=[dir for dir in glob.glob(init+'/sub*') if os.path.isdir( dir)]
mylist = ' '.join(list_sub).replace(init+'/','').split()
mylist.sort()
mylist=['sub-006']
print(mylist)
for sub in mylist:
    list_tsv=[dir for dir in glob.glob(init+'/'+sub+'/func/'+sub+'_task-regularity_run-*_desc-confounds_timeseries.tsv')]
    print(list_tsv)#if os.path.isfile(init+'/'+sub+'/func/'+sub+'_task-regularity_run-1_desc-confounds_timeseries.tsv'): 
    for tsv in list_tsv:
            print(tsv)
            p=0
            data=pd.read_csv(tsv,sep= '\t' )
            cols = [c for c in data.columns if c.lower()[:14] != 'motion_outlier']
            df=data[cols]
            column_1 =df['framewise_displacement']
            for i in range(0,len(column_1)):
                if column_1[i] > FD_thr:
                    new_column='motion_outlier'+"%.2d" % p
                    df[new_column] = 0.0
                    df.loc[i,new_column] = 1.0
                    p=p+1
            myfile,toto=os.path.splitext(os.path.basename(tsv))
            df.to_csv(init+'/'+sub+'/func/'+myfile+'_new.tsv',sep='\t',na_rep='n/a',index=False)