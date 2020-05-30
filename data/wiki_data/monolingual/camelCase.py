import re


name = 'birth Date'

splitted = re.sub('([A-Z][a-z]+)', r' \1', re.sub('([A-Z]+)', r' \1', name)).split()

print(" ".join(str(x) for x in splitted))