import numpy
import sys


def main(argv):
	filepath = argv[0]
	min_characters = 80     # minimum characters within a paragraph
	max_characters = 80*1.5   # maximum characters within a paragraph
	#Read line by line: Keep only targets
	with open(filepath) as fp:
		paragraph = fp.readline()
		while paragraph:
			length = len(paragraph)
			if length > min_characters:  
				if length > max_characters:   # split this paragraph in smaller paragraph
					new_line = ''
					for sentence in paragraph.split('.')[:-1]: # for each sentence in paragraph
						if len(new_line) > max_characters:
							print(new_line)
							new_line = ''
							new_line = sentence
						else:
							new_line += sentence + '.'
					if len(new_line) > min_characters:
						print(new_line[:-1])
					new_line = ''
				else:
					print(paragraph[:-1])
			paragraph = fp.readline()

if __name__ == '__main__':
	main(sys.argv[1:])