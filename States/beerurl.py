import ratebeer
rb = ratebeer.RateBeer()

f = open('examp', 'r')
bbrewer = f.readline()[:-1]
bbeer = f.readline()[:-1]

brewery = rb.search(bbrewer)
brew = brewery['breweries'][0].url
beers = rb.get_brewery(brew).get_beers()

test = -1

while test ==-1:
	testbeer = next(beers)
	a = testbeer.name
	test = a.find(bbeer)

url = testbeer.url
fullurl = 'www.ratebeer.com'+url


fout=open('./url', 'w+')
fout.write(fullurl)
