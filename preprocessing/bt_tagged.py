import argparse

def write(tagged_lines, args):
	
	filepath = args["file"]
	if not args["overwrite"]:
		filepath += ".tagged"
	
	with open(filepath, 'w') as file:
		for line in tagged_lines:
			file.write(line)


def tagging(args):

	with open(args["file"]) as fp:
		line = fp.readline()
		target = []
		i = 0

		while line:
			if i >= args["line"]:
				tagged_line = "<BT> " + line
				target.append(tagged_line)
			else:
				target.append(line)

			line = fp.readline()
			i += 1

	return target
	
def main():
	ap = argparse.ArgumentParser()
	
	ap.add_argument("-f", "--file", type=str, help="input path to file")
	ap.add_argument("-l", "--line", type=int, default=0, help="line to start tagging")
	ap.add_argument("-o", "--overwrite", type=bool, default=False, help="overwrite input file")

	args = vars(ap.parse_args())	

	tagged_lines = tagging(args)
	write(tagged_lines, args)


if __name__ == '__main__':
	main()