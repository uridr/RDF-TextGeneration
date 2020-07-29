import os
import random
import re
import json
import sys
import getopt
from collections import defaultdict
from benchmark_reader import Benchmark

BENCHMARK_TEST = False # Global Variable MODIFY IT!

def select_files(topdir, category='', size=(1, 8)):
	"""
	Collect all xml files from a benchmark directory.
	:param topdir: directory with benchmark
	:param category: specify DBPedia category to retrieve texts for a specific category (default: retrieve all)
	:param size: specify size to retrieve texts of specific size (default: retrieve all)
	:return: list of tuples (full path, filename)
	"""
	finaldirs = [topdir+'/'+str(item)+'triples' for item in range(size[0], size[1])]
	finalfiles = []
	for item in finaldirs:
		if topdir.split('/')[-1] == 'test' and BENCHMARK_TEST:
			finalfiles += [(item, filename) for filename in os.listdir(item)]
			break
		else:
			finalfiles += [(item, filename) for filename in os.listdir(item)]
	if category:
		finalfiles = []
		for item in finaldirs:
			finalfiles += [(item, filename) for filename in os.listdir(item) if category in filename]
	return finalfiles


def relexicalise(predfile, rplc_list, path_pre, part):
	"""
	Take a file from seq2seq output and write a relexicalised version of it.
	:param rplc_list: list of dictionaries of replacements for each example (UPPER:not delex item)
	:return: list of predicted sentences
	"""
	relex_predictions = []
	print(len(rplc_list))
	with open(predfile, 'r') as f:
		predictions = [line for line in f]

	print(len(predictions))
	for i, pred in enumerate(predictions):
		# replace each item in the corresponding example
		rplc_dict = rplc_list[i]
		relex_pred = pred
		for key in sorted(rplc_dict):
			relex_pred = relex_pred.replace(key + ' ',rplc_dict[key] + ' ')
		relex_predictions.append(relex_pred)

	with open(predfile + '.lex', 'w+') as f:
		f.write(''.join(relex_predictions))

	return relex_predictions

def delexicalisation(out_src, out_trg, category, properties_objects):
	"""
	Perform delexicalisation.
	:param out_src: source string
	:param out_trg: target string
	:param category: DBPedia category
	:param properties_objects: dictionary mapping properties to objects
	:return: delexicalised strings of the source and target; dictionary containing mappings of the replacements made
	"""
	with open('../postprocessing/delex_dict.json') as data_file:
		data = json.load(data_file)
	# replace all occurrences of Alan_Bean to ASTRONAUT in input
	delex_subj = data[category]
	delex_src = out_src
	delex_trg = out_trg
	# for each instance, we save the mappings between nondelex and delex
	replcments = {}
	for subject in delex_subj:
		clean_subj = ' '.join(re.split('(\W)', subject.replace('_', ' ')))
		if clean_subj in out_src:
			delex_src = out_src.replace(clean_subj + ' ', category.upper() + ' ')
			replcments[category.upper()] = ' '.join(clean_subj.split())   # remove redundant spaces
		if clean_subj in out_trg:
			delex_trg = out_trg.replace(clean_subj + ' ', category.upper() + ' ')
			replcments[category.upper()] = ' '.join(clean_subj.split())

	# replace all occurrences of objects by PROPERTY in input
	for pro, obj in sorted(properties_objects.items()):
		obj_clean = ' '.join(re.split('(\W)', obj.replace('_', ' ').replace('"', '')))
		if obj_clean in delex_src:
			delex_src = delex_src.replace(obj_clean + ' ', pro.upper() + ' ')
			replcments[pro.upper()] = ' '.join(obj_clean.split())   # remove redundant spaces
		if obj_clean in delex_trg:
			delex_trg = delex_trg.replace(obj_clean + ' ', pro.upper() + ' ')
			replcments[pro.upper()] = ' '.join(obj_clean.split())

	# possible enhancement for delexicalisation:
	# do delex triple by triple
	# now building | location | New_York_City New_York_City | isPartOf | New_York
	# is converted to
	# BUILDING location ISPARTOF City ISPARTOF City isPartOf ISPARTOF
	return delex_src, delex_trg, replcments

def create_source_target(b, options, dataset, delex=True):
	"""
	Write target and source files, and reference files for BLEU.
	:param b: instance of Benchmark class
	:param options: string "delex" or "notdelex" to label files
	:param dataset: dataset part: train, dev, test
	:param delex: boolean; perform delexicalisation or not
	:return: if delex True, return list of replacement dictionaries for each example
	"""
	source_out = []
	target_out = []
	rplc_list = []  # store the dict of replacements for each example
	for entr in b.entries:
		tripleset = entr.modifiedtripleset
		lexics = entr.lexs
		category = entr.category
		for lex in lexics:
			triples = ''
			properties_objects = {}
			for triple in tripleset.triples:
				triples += triple.s + ' ' + triple.p + ' ' + triple.o + ' '
				properties_objects[triple.p] = triple.o
			triples = triples.replace('_', ' ').replace('"', '')
			# separate punct signs from text
			out_src = ' '.join(re.split('(\W)', triples))
			out_trg = ' '.join(re.split('(\W)', lex.lex))
			if delex:
				out_src, out_trg, rplc_dict = delexicalisation(out_src, out_trg, category, properties_objects)
				rplc_list.append(rplc_dict)
			# delete white spaces
			source_out.append(' '.join(out_src.split()))
			target_out.append(' '.join(out_trg.split()))
			if BENCHMARK_TEST and dataset == 'test': break

	
	# shuffle two lists in the same way
	random.seed(10)
	if delex:
		corpus = list(zip(source_out, target_out, rplc_list))
		#random.shuffle(corpus)
		source_out, target_out, rplc_list = zip(*corpus)
   
	return rplc_list



def input_files(path_org, path_pre, filepath, part):
	files = select_files(path_org+part, size=(1, 8))
	b = Benchmark()
	b.fill_benchmark(files)
	rplc_list = create_source_target(b, 'all-delex', part, delex=True)
	relexicalise(filepath, rplc_list, path_pre, part)
	print('Files necessary for training/evaluating are written on disc.')


def main(argv):
	
	path_org = '../data/dataset/original/'
	path_pre = '../data/dataset/preprocessed/'
	
	part = argv[0]
	filepath = argv[1]

	input_files(path_org, path_pre, filepath, part)	


if __name__ == '__main__':
	main(sys.argv[1:])