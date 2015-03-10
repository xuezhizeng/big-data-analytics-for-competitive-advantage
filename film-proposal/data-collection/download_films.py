import sys
import csv
import requests

filmDataFilename = './data/test_film_urls.csv';
filmDataReader = csv.reader(open(filmDataFilename));
filmDataReader.__next__();
count = 0;
for filmData in filmDataReader:
	count += 1;
	url = filmData[0];
	urlPieces = url.split('/');
	pageName = urlPieces[len(urlPieces) - 1];
	pageFile = open('./data/films/' + pageName + '.html', 'w');
	try:
		response = requests.get(url);
		print(str(count) + '. Writing ' + pageName);
		pageFile.write(response.text);
	except requests.exceptions.RequestException:
		print('Exception: Bad Request for ' + pageName + ' -> ' + url);
	pageFile.close();
