filepath = 'output.txt'
targets = {}

#Read line by line: Keep only targets
with open(filepath) as fp:
	line = fp.readline()
	
	if line[0] == 'T':
		line_el = line.split("\t")
		line_num = line_el[0].split("-")[1]
		targets[line_num] = line.split("\t")[1]
	
	while line:
		if line[0] == 'T':
			line_el = line.split("\t")
			line_num = line_el[0].split("-")[1]
			targets[int(line_num)] = line.split("\t")[1]

		line = fp.readline()

	#Sort target sentences by order in data (not processed order)
	sorted_targets = {}
	with open('sorted_targets.txt', 'w') as file:
		for key, value in sorted(targets.items()):
			file.write(value+"\n")