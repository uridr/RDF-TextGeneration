from benchmark_reader import Benchmark
from benchmark_reader import select_files


# where to find the corpus
path_to_corpus = '../benchmark/original/test'

# initialise Benchmark object
b = Benchmark()

# collect xml files
files = select_files(path_to_corpus)

# load files to Benchmark
b.fill_benchmark(files)

entities = set()

for entry in b.entries:
   entity = entry.modifiedtripleset.triples[0].s
   entities.add(entity)
   entity = entry.modifiedtripleset.triples[0].o
   entities.add(entity)

#print(entities)
for entity in entities:
    print(entity.replace('_',' '))


