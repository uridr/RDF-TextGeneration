import time
import requests
from bs4 import BeautifulSoup

filter_link = 'https://en.wikipedia.org/wiki/'


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

		url = filter_link + entity
		soup = getSoup(url)

		if soup:
			getWkDataIntro(soup)


if __name__ == '__main__':
	
	start = time.time()
	print('Exploring...')
	explore(['Barcelona', 'Madrid', 'Tokyo', 'Delhi', 'Mexico City', 'California', 'France', 'Germany', 'Lady Gaga', 'Bruno Mars','Emminem','Beethoven', 'Big Ben', 'Stanford', 'Google', 'Colosseum','Italy', 'George_W._Bush', 'Barack Obama','Merkel','ESADE_Business_School','Eiffel_Tower','Lionel Messi', 'Batman','Spyderman', 'Michael Phelps', 'Rafael Nadal','Francesco Totti','Audi R8','Pizza','Salad','Bread'])
	finish = time.time()
	print(finish-start)
