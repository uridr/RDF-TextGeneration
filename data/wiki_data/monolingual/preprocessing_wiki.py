import re


with open('monolingual.txt', 'r') as in_:
	lines = in_.readlines()

for line in lines:
	line = re.sub("[\(\[].*?[\)\]]", "", line)

	print(line, file = open('monolingual_processed.txt', 'a'))
