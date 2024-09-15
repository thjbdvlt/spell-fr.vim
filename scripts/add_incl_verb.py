import re

fp = "../affixes/verbs.aff"

with open(fp, 'r') as f:
    lines = f.readlines()

lines = [i.strip() for i in lines]

newlines = []

for i in lines:
    newlines.append(i)
    if 'is:ppas' in i and 'is:fem' in i:
        i = re.sub(r'(es?/)', r'·\1', i)
        i = i.replace('is:fem', 'is:incl')
        newlines.append(i)
        newlines.append(i.replace('·', '.'))

with open(fp, 'w') as f:
    f.write('\n'.join(newlines))
