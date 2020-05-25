import numpy
import sys


def main(argv):
	filepath = argv[0]
	i = 1
	#Read line by line: Keep only targets
	with open(filepath) as fp:
		paragraph = fp.readline()
		while paragraph:
			length = len(paragraph)
			if length > 80:
				if length > 4*80:
					new_line = ''
					for sentence in paragraph.split('.')[:-1]:
						if len(new_line) > 4*80:
							print(new_line)
							new_line = ''
							new_line = sentence
						else:
							new_line += sentence + '.'
					if len(new_line) > 80:
						print(new_line[:-1])
					new_line = ''
				else:
					print(paragraph[:-1])
			paragraph = fp.readline()

if __name__ == '__main__':
	main(sys.argv[1:])