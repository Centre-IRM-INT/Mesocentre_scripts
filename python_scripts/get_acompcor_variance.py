import json
import sys, argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('path',
                    help='an integer for the accumulator')

args = parser.parse_args()

with open(args.path, 'r') as json_file:
    js = json.load(json_file)
        
a_comp_cor_csf, a_comp_cor_wm = ([] for _ in range(2))
        
for i in js.keys():
    if i.startswith('a_comp_cor'):
        if js[i]['Mask'] == 'CSF' and js[i]['Retained']:
                a_comp_cor_csf.append(i)
                
        if js[i]['Mask'] == 'WM' and js[i]['Retained']:
            a_comp_cor_wm.append(i)

a_comp_cor_csf.sort(key=lambda x: '{0:0>18}'.format(x).lower())

a_comp_cor_wm.sort(key=lambda x: '{0:0>18}'.format(x).lower())

#a_comp_cor = a_comp_cor_csf[:12] + a_comp_cor_wm[:12]


#if len(a_comp_cor_csf)>11:
#	csf_var=js[a_comp_cor_csf[11]]['CumulativeVarianceExplained']
#else :
#	csf_var=js[a_comp_cor_csf[-1]]['CumulativeVarianceExplained']

#if len(a_comp_cor_wm)>11:
#	wm_var=js[a_comp_cor_wm[11]]['CumulativeVarianceExplained']
#else :
#	wm_var=js[a_comp_cor_wm[-1]]['CumulativeVarianceExplained']
csf_var=js[a_comp_cor_csf[11]]['CumulativeVarianceExplained']
wm_var=js[a_comp_cor_wm[11]]['CumulativeVarianceExplained']
print(csf_var,wm_var)



