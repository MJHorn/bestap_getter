import re

with open('Some_Taps') as f:
        taplist = [tuple(map(str, re.split(r'\t+',i))) for i in f]

with open('Some_Taps_old') as f:
        taplist_old = [tuple(map(str, re.split(r'\t+',i))) for i in f]

newbeers=[]
changedbeers=[]
errors=[]
offbeers=[]

for a in taplist:

    k = 0

    for b in taplist_old:

        if a == b:
            k = k+1
            break
        elif a[0:5] == b[0:5]:
            changedbeers.append(a)
            k = k+1
            break
    if k==0:
        newbeers.append(a)
    elif k > 1:
        errors.append(a)

for c in taplist_old:

    l = 0
    
    for d in taplist:
        if c[0:5] == d[0:5]:
            l = l + 1
            break

    if l == 0:
        offbeers.append(c)
    elif l > 1: 
        errors.append(c)

with open('OffPy', 'w') as file:
        file.writelines('\t'.join(i) for i in offbeers)
with open('NewPy', 'w') as file:
        file.writelines('\t'.join(i) for i in newbeers)
with open('UpPy', 'w') as file:
        file.writelines('\t'.join(i) for i in changedbeers)
with open('ErrorPy', 'w') as file:
        file.writelines('\t'.join(i) for i in errors)


