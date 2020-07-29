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

# output some statistics
#print("Number of entries: ", b.entry_count())
#print("Number of texts: ", b.total_lexcount())
#print("Number of distinct properties: ", len(list(b.unique_p_mtriples())))

'''
# get access to each entry info
for entry in b.entries:
    print(f"Info about {entry.id} in category '{entry.category}' in size '{entry.size}':")
    print("# of lexicalisations", entry.count_lexs())
    print("Properties: ", entry.relations())
    print("RDF triples: ", entry.list_triples())
    print("Subject:", entry.modifiedtripleset.triples[0].s)
    print("Predicate:", entry.modifiedtripleset.triples[0].p)
    print("Object:", entry.modifiedtripleset.triples[0].o)
    print("Lexicalisation:", entry.lexs[0].lex)
    print("Another lexicalisation:", entry.lexs[1].lex)
    if entry.dbpedialinks:
        # dbpedialinks is a list where each element is a Triple instance
        print("DB link, en:", entry.dbpedialinks[0].s)  # subject in English
        print("DB link, ru:", entry.dbpedialinks[0].o)  # object in Russian
    break
'''

entities = set()

for entry in b.entries:
   entity = entry.modifiedtripleset.triples[0].s
   entities.add(entity)
   #entity = entry.modifiedtripleset.triples[0].o
   #entities.add(entity)

#print(entities)
for entity in entities:
    print(entity.replace('_',' '))


