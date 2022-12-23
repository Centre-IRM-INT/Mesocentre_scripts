import pandas as pd
import sys, argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('path',
                    help='an integer for the accumulator')

args = parser.parse_args()

with open(args.path, 'r') as tsv_file:
    df = pd.read_csv(tsv_file,sep= '\t' )

col=df.columns[pd.Series(df.columns).str.contains("cos")]
        
k=0
for i in col:
    k=k+1
cos_list=[]
for i in range(k):
    cos_list.append('cosine0'+str(i))
print(cos_list)

