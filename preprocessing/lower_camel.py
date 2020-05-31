from itertools import chain
from glob import glob
import sys
import re

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, 'r') as in_:
	lines = in_.readlines()

for line in lines:
	splitted = re.sub('([A-Z][a-z]+)', r' \1', re.sub('([A-Z]+)', r' \1', line)).split()
	line = " ".join(str(x) for x in splitted)
	line = line.lower()
	print(line, file = open(output_file, 'a'))