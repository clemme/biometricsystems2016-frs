from __future__ import division
import numpy as np
import openface
import pandas as pd

from compare import getRepresentation


def print_full(x):
    pd.set_option('display.max_rows', len(x))
    print(x)
    pd.reset_option('display.max_rows')

raw_data_path = "../../../openbr/data/lfw"

name = ""
limit = 100

columns = ['Name', 'Template', 'Rep']
df = pd.DataFrame(columns=columns)

print "Enrolling..."
i = 1
for data in openface.data.iterImgs(raw_data_path):

    if len(df) >= limit:
        break

    if (name != data.cls):
        name = data.cls
        df.loc[len(df)] = [name, data.path, getRepresentation(data.path, False)]
        print "[{}%] Enrolled {}".format(i/limit * 100, name)
        i = i + 1

# print_full(df)

print "Scanning probe..."
probe = '../../../openbr/data/lfw/Dominik_Garcia-Lorido/Dominik_Garcia-Lorido_0002.jpg'
probe_rep = getRepresentation(probe, False)

#print probe_rep - df[df['Name'] == 'Sharon_Davis']['Rep'].values[0]

print "Comparing with enrolled templates..."

def calc_dist(row):
    d = row['Rep'] - probe_rep
    return np.dot(d, d) # distance

df['Distance'] = df.apply(calc_dist, axis=1)

df = df.sort_values(by='Distance', ascending=True).iloc[0]
print_full(df)
