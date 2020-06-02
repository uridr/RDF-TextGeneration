import numpy as np
from wikipedia2vec import Wikipedia2Vec

EMBEDDING_PATH = "embeddings/enwiki_20180420_100d.pkl"
wiki2vec = None

def load_embeddings():
	global wiki2vec
	wiki2vec = Wikipedia2Vec.load(EMBEDDING_PATH)


def parseFormat(closest):
	entities = []
	for close in closest:
		try:	
			word_type = str(close[0]).split()[0][1:]
			word = ' '.join(str(close[0]).split()[1:])
			word = word[:-1]
			if word_type == 'Entity':
				entities.append(word)
		except:
			pass

	return entities


def find_closest_embeddings(entity, n=30):
	return wiki2vec.most_similar(wiki2vec.get_entity(entity), n)


def closestEntities(entity):
	try:
		closest = find_closest_embeddings(entity)
		return parseFormat(closest)
	except:
		return []

