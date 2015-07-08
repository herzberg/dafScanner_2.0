import json
import pdb



def getDaf(dafNumber, mesechtaText):
	daf = mesechtaText[dafNumber]
	digWords = []
	for i in range(len(daf)):
		digWords +=  daf[i].split(' ')
	return digWords
	

def getMesText(fileName):
	json_data=open(fileName)
	data = json.load(json_data)
	json_data.close()
	return data['text']
	
def flag():
	print("SAD FACE")
	
		
def getWordCounts(fileName):
	with open(fileName) as f:
		lines = f.read().splitlines()
	wordCounts = [int(x) for x in lines]
	return wordCounts

	
def combine(digWords, wordCounts):
	print(len(digWords))
	print(sum(wordCounts))
	correctDaf = []
	if(len(digWords) != sum(wordCounts)):
		flag()
	
	
	wordNum = 0
	for i in range(len(wordCounts)):
		line = []
		for j in range(wordCounts[i]):
			line +=	[digWords[wordNum]]
			wordNum +=1
		correctDaf += [line]
	return correctDaf	


		
#pdb.set_trace()
fileName = 'merged.json'
fileName = 'english.json'
mesechtaText = getMesText(fileName)
digWords = getDaf(2,mesechtaText)
wordCounts = getWordCounts('wordCounts.txt')

correctDaf = combine(digWords,wordCounts)
print(correctDaf)



