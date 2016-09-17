from numpy import genfromtxt
from numpy import nanmean
from numpy import nanmax
from numpy import concatenate
import csv
import numpy as np

import collections
import numbers
def pformat(thing, formatfunc):
    if isinstance(thing, dict):
        return type(thing)((key, pformat(value)) for key, value in thing.iteritems())
    if isinstance(thing, collections.Container):
        return type(thing)(pformat(value) for value in thing)
    if isinstance(thing, numbers.Number):
        return formatfunc(thing)
    return thing

def formatfloat(thing):
    return "%.3g" % float(thing)

Results = []

Best = ['Nothing','Noone',0]

#f = open('barlist', 'r')

with open('barlist') as f:
	for bar in f: 
		bar = bar.rstrip('\n')	
		
		bar_taps = genfromtxt(bar,delimiter=',', names=True, dtype=("|S200", "|S200", "|S200", "|S200", "|S200", float, "|S200", "|S200", "|S200", float, float))

                bar_taps = np.atleast_1d(bar_taps)

		ratings = bar_taps['Rating']

                ratings = np.atleast_1d(ratings)

		ratings[ratings==0] = np.nan		

		bar_mean = nanmean(bar_taps['Rating'])

		if nanmax(ratings) > Best[2]:
			newbest = nanmax(ratings)
			itemindex = np.where(ratings==newbest)[0][0]
			Best = bar_taps[itemindex] 

		Results.append([bar, round(bar_mean,2)])
		
		try:
                    alltaps=concatenate([alltaps,bar_taps])
		except NameError:
			alltaps=bar_taps

f.close

newstrrate = []

for row in alltaps:
	try:
		newstrrate.append([row[0],row[1],row[2],row[3],row[4],str(row[5]),row[6],row[7],row[8],str(row[9]),str(row[10])])
	except NameError:
		newstrrate=[row[0],row[1],row[2],row[3],row[4],str(row[5]),row[6],row[7],row[8],str(row[9]),str(row[10])]

with open('bestlist', 'w') as b:
	w = csv.writer(b, dialect = 'excel-tab')
	w.writerows(newstrrate)

with open('meanresults', 'w') as o:
	w = csv.writer(o, dialect = 'excel-tab')
	w.writerows(Results)

b.close
o.close
