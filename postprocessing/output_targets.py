import sys


def main(argv):

	filepath = argv[0]
	filename = argv[1]

	targets = {}

	#Read line by line: Keep only targets
	with open(filepath+filename) as fp:
		line = fp.readline()
		
		if line[0] == 'H':
			line_el = line.split("\t")
			line_num = line_el[0].split("-")[1]
			targets[line_num] = line.split("\t")[2]
		
		while line:
			if line[0] == 'H':
				line_el = line.split("\t")
				try:
					line_num = line_el[0].split("-")[1]
				except:
					print(line_el)
				targets[int(line_num)] = line.split("\t")[2]

			line = fp.readline()

		#Sort target sentences by order in data (not processed order)
		sorted_targets = {}
		with open(filepath+'delex_'+filename, 'w') as file:
			for key, value in sorted(targets.items()):
				file.write(value)


if __name__ == '__main__':
	main(sys.argv[1:])