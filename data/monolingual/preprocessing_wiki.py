import re
import sys

with open(sys.argv[1], 'r') as in_:
	lines = in_.readlines()

for line in lines:
	line = re.sub("[\(].*?[\)]", "", line)
	line = re.sub("[\[].*?[\]]", "", line)

	print(line, file = open(sys.argv[2], 'a'))
