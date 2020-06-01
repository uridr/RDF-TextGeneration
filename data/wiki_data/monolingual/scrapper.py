import json
import time
import requests
import closest_entities           
from bs4 import BeautifulSoup

filter_link = 'https://en.wikipedia.org/wiki/'
JSON_PATH = "delex_dict.json"

def readJSON():
	with open(JSON_PATH) as json_file:
		data = json.load(json_file)

	return data


def getWkDataIntro(soup):

	results = []
	for paragraph in soup.select('p')[:4]:
		print(paragraph.getText())
	

def getSoup(url):                                                   # Try/Catch block to prevent Bad Content being processed.
	try:
		response = requests.get(url)     				
		return BeautifulSoup(response.text, "html.parser")                  
	except:
		print("Error: Bad Content, skipping link. Do not stop.")
		return None                                                 # Return None if the URL could not be processed. The Crawler will understand.


def explore(entities):

	''' Explore the urls (Wikipedia) to get the corresponding intro '''

	for entity in entities:

		closest = closest_entities.closestEntities(entity)
		closest.append(entity)
		
		for close_entity in closest:
		
			url = filter_link + close_entity
			soup = getSoup(url)

			if soup:
				getWkDataIntro(soup)


if __name__ == '__main__':
	
	start = time.time()
	print('Loading Embeddings...')
	closest_entities.load_embeddings()
	print('Exploring...')
	#explore(['Barcelona', 'Madrid', 'Tokyo', 'Delhi', 'Mexico City', 'California', 'France', 'Germany', 'Lady Gaga', 'Bruno Mars','Emminem','Beethoven', 'Big Ben', 'Stanford', 'Google', 'Colosseum','Italy', 'Barack Obama','Mariano Rajoy','ESADE_Business_School','Ronaldinho','Usain Bolt','Lionel Messi','Tiger Woods' ,'Batman','Spyderman', 'Michael Phelps', 'Rafael Nadal','Francesco Totti','Audi R8','Seat Ibiza','Pizza','Salad','Bread','Potatoes','Rice','Fideua','Range Rover Velar','French fries','Hamburger','Adele','Ozuna','Eiffel Tower','Golden Gate'])
	data = readJSON()
	global_entities = []
	for key in data:
		entities = []
		for entity in data[key]:
			word = ' '.join(entity.split('_'))
			if not word in global_entities: 
				entities.append(word)
				global_entities.append(word)
		explore(entities)
	finish = time.time()
	print(finish-start)
	print(len(global_entities))
