import sys

RDF_ALIGNED_PATH = "./rdf_aligned.txt"
TXT_ALIGNED_PATH = "./text_aligned.txt"

MIN_CHRS = 80 	# minimum characters in a sentence

def writeText(text):
	with open(TXT_ALIGNED_PATH, 'a') as file:
		for _, sentence in text.items():
			sentence = sentence.split('\n')
			sentc = ''
			for word in sentence:
				sentc += word
			file.write(sentc + '.' + '\n')


def writeRDF(rdf):
	with open(RDF_ALIGNED_PATH, 'a') as file:
		for _, triple in rdf.items():
			file.write(triple + '\n')


def readText(path):
	text = {}
	i = 0

	with open(path) as fp:
		line = fp.readline()
		while line:
			lines = line.split('.')
			for line in lines:
				text[i] = line
				i += 1
			line = fp.readline()
	
	return text


def readRDF(path):
	rdf = {}
	i = 0
	
	with open(path) as fp:
		line = fp.readline()
		while line:
			rdf[i] = line
			i += 1
			line = fp.readline()
	
	return rdf


def alignCorpus(rdf, text):
	rdf_aligned = {}
	text_aligned = {}

	prev_triple   = ''
	prev_sentence =''
	
	i = 0

	for key in rdf.keys():
		triple = rdf[key][1:-1] 			# remove: \n 
		sentence = text[key]
		els = triple.split("  ")
		if len(els) >= 3:
			prev_triple   += triple + ' '
			prev_sentence += sentence + ' '
			if len(prev_sentence) > MIN_CHRS:
				rdf_aligned[i]  = prev_triple
				text_aligned[i] = prev_sentence
				prev_triple   = ''
				prev_sentence = ''
				i += 1

	return rdf_aligned, text_aligned


def main():
	
	rdf  = readRDF(sys.argv[1])
	text = readText(sys.argv[2])

	rdf_aligned, text_aligned = alignCorpus(rdf, text)

	writeRDF(rdf_aligned)
	writeText(text_aligned)


if __name__ == '__main__':
	main()










