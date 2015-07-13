import json
import pdb
import sys
from fuzzywuzzy import fuzz
import re
import copy

#globals
log = open('log.txt','w')
quotesLog = open('quotesLog.txt','w')
flagLog = open('flagLog.txt','w')
allHebBooks = []


def showFoundQuotes(pattern,text,doRemove):
	found = re.findall(pattern,text)
	if(len(found) >0):
		displayFound =  ""
		if doRemove:
			removeType = "Removing: " 
		else:
			removeType = "Keeping: " 
		for item in found:
			displayFound += removeType+ item + ' from ' + text + "\n" 
		if not doRemove:
			print(removeType + "Source")
		log.write(displayFound)
		quotesLog.write(displayFound)
		if doRemove:
			text = re.sub(pattern, "", text)
			quotesLog.write("\t" + text + "\n")
	return text

def removeQuotes(text):
	for hebBook in allHebBooks:
		hebBook = hebBook.encode('utf8')
		pattern = '\(' + hebBook + ' .{1,6}\)'
		text = showFoundQuotes(pattern,text,True)
		pattern = '\(' + hebBook + ' .{1,6}, .{1,6}\)'
		text = showFoundQuotes(pattern,text,True)
		pattern = '\(' + hebBook + ' .{1,16}\)'
		text = showFoundQuotes(pattern,text,False)
	return text

def splitWords(text):
	text = text.encode('utf8')
	text = removeQuotes(text)
	if len(text) < 1:
		return []
	if(text[0] == ' '):
		text = text[1:]
	if(text[-1] == ' '):
		text = text[:-1]
	text = re.sub(' {2,}',' ',text)
	text = text.split(' ')
	return text
	
def getDaf(dafNumber, mesechtaText):
	daf = mesechtaText[dafNumber]
	digWords = []
	for i in range(len(daf)):
		text =  daf[i]
		digWords += splitWords(text)
	return digWords

def getRashiDaf(dafNumber, mesechtaText):
	daf = mesechtaText[dafNumber]
	digWords = []
	for i in range(len(daf)):
		for j in range(len(daf[i])):
			text = daf[i][j]
			digWords += splitWords(text)
	return digWords
	

def getMesText(fileName):
	json_data=open(fileName)
	data = json.load(json_data)
	json_data.close()
	return data['text']
	
def flag(lineNum, error = "unknown", printIt = False):
	errorExpression = "Error: " + str(lineNum)+ " " + error  
	log.write(errorExpression + "\n")
	flagLog.write(errorExpression + "\n")
	if printIt:
		print(errorExpression)
	pass
		
def getWordCounts(fileName):
	with open(fileName) as f:
		lines = f.read().splitlines()
	wordCounts = [int(x) for x in lines]
	return wordCounts

def getLetCounts(fileName):
	with open(fileName) as f:
		lines = f.read().splitlines()
	letCounts = []
	for line in lines:
		letCounts += [[int(x) for x in line.split(',')]]

""""
def correctDaf2Lines(correctDaf):
	for line in correctDaf:
		textline = ''
		for word in line:
			textline += word.encode('utf8') + " "
		print(textline)
"""
	
def getScanWords(fileName):
	with open(fileName) as f:
			lines = f.readlines()
	return lines
	
def findPeak(fuzzNum):
	lastNum = 0
	for i in range(len(fuzzNum)):
		if lastNum > fuzzNum[i]:
			if (len(fuzzNum) > i + 1) and (fuzzNum[i]  > fuzzNum[i+1]):
				return i - 1
		lastNum = fuzzNum[i]
	return i
		
	
def combine(digWords, wordCounts, letCounts, scanWords, outPath):
	#print("dig Word count:", len(digWords))
	#print(sum(wordCounts))
	f = open(outPath,'w')
	correctDaf = []
	countsDiff = abs(len(digWords) - sum(wordCounts))
	#print("countsDiff: " + str(countsDiff))
	if(countsDiff >300): ##seems silly
		flag(-300)
		

	wordNum = 0
	startPoint = 0
	for i in range(len(wordCounts)):
		myLine = ''
		fuzzNum = []
		if(wordCounts[i] <= 2 and i - len(wordCounts) >= -2):
			if(wordCounts[i] == 2):
				flag(i,"TwoWordLastLine",True)
			if(startPoint == len(digWords)):
				print(str(i) + " - ChuckingLastWord")
				log.write(str(i) + " - ChuckingLastWord\n")
				f.close()
				return correctDaf	
			else:
				flag(i,"singleWordLastLine",True)
		for j in range(int(wordCounts[i]*1.8)):
			if j + startPoint >= len(digWords):
				break
			myLine += " " + digWords[j + startPoint]#.encode('utf8')
			fuzzNum += [fuzz.ratio(scanWords[i],myLine)]
		try:
			fuzzMax = max(fuzzNum)
		except:
			flag(i,'maxArgIsEmpty',True)
			f.close()
			return correctDaf
		maxIndex = fuzzNum.index(fuzzMax)
		maxPeak = findPeak(fuzzNum)
		maxToUse = maxPeak #maxIndex
		#print(i, fuzzMax, (fuzzNum))
		#log.write("wordCounts[i]: " + str(wordCounts[i]) + str(fuzzNum) + "\tlen(myLine): " + str(len(myLine)) + "\t" + myLine + "\t" + str(digWords[startPoint:startPoint + j]) + "\tj: " + str(j))
		log.write(str(i) + "\t" + str(fuzzMax) +"\t"+ str(fuzzNum) + "\n")
		correctLine = ''
		for j in range(maxToUse + 1):
			if j != 0:
				correctLine += " "
			correctLine += digWords[startPoint + j]#.encode('utf8')
		if(fuzzMax < 45 or maxIndex != maxPeak):
			flag(i,"maxNotPeak - " + str(maxIndex) + "\t" + str(maxPeak),True)
			print(i, maxIndex, maxPeak, fuzzNum)
			log.write(correctLine + "\n")
			flagLog.write(correctLine + "\n")
#		print(str(i))
		f.write(correctLine + "\n")
		log.write(correctLine + "\n")
		startPoint += maxToUse +1
		#letPerLine = sum(letCount[i])
		#line +=	[digWords[wordNum]]
		#wordNum +=1
		correctDaf += [correctLine]
	f.close()
	
	return correctDaf	

	
	
	

def getGemaraAndComm(type, meschta, dafName, dafNum):
	folder = '../2ocr/' + type + '/' + meschta
	fileName = folder + '/merged.json'
	folder += '/' + dafName
	mesechtaText = getMesText(fileName)
	if type != 'gemara':
		digWords = getRashiDaf(dafNum,mesechtaText)
	else:
		digWords = getDaf(dafNum,mesechtaText)

	wordCounts = getWordCounts(folder + '/dafNumWords.txt')
	letCounts = getLetCounts(folder + '/dafNumChars.txt')
	scanWords = getScanWords(folder + '/daf.txt')

	return combine(digWords,wordCounts, letCounts, scanWords, folder)
	
def getGemara(meschta, maxPage, startPage = 3, type = 'gemara'):
	folder = '../' + type + '/' + meschta + '/'
	fileName = folder + 'merged.json'
	mesechtaText = getMesText(fileName)
	global log
	global quotesLog
	global flagLog
	log = open('log/' + meschta + '.txt', 'w')
	quotesLog = open('log/quotesLog_' + meschta + '.txt', 'w')
	flagLog = open('log/flagLog_' + meschta + '.txt', 'w')
	
	for dafNum in range(startPage, maxPage+1):
		locationRef = "\n" + meschta + "_" + type + " " + str(dafNum) + "\n"
		log.write(locationRef)
		quotesLog.write(locationRef)
		flagLog.write(locationRef)
		print(locationRef + "\b")
		realDafNum = dafNum-1
		if(meschta == "brachos" and dafNum >= 15):
			realDafNum += 2
		if(meschta == "brachos" and dafNum >= 45):
			realDafNum += 2
		if type != 'gemara':
			digWords = getRashiDaf(realDafNum,mesechtaText)
		else:
			digWords = getDaf(realDafNum,mesechtaText)
		#testingDigWords = open(folder + str(dafNum)  + '_digWords.txt', 'w')
		#for word in digWords:
			#pass
			#testingDigWords.write(word + "\n")
		
		
		wordCounts = getWordCounts(folder + str(dafNum)  + '_dafNumWords.txt')
		letCounts = getLetCounts(folder + str(dafNum)  + '_dafNumChars.txt')
		scanWords = getScanWords(folder + str(dafNum)  + '_daf.txt')
		outPath = folder + str(dafNum) + '_myDaf.txt' 
		
		
		combine(digWords,wordCounts, letCounts, scanWords, outPath)
		try:
			#combine(digWords,wordCounts, letCounts, scanWords, outPath)
			pass
		except:
			print(sys.exc_info())
		
	log.close()
	quotesLog.close()
	return 

allHebBooks = [u'\u05D1\u05E8\u05D0\u05E9\u05D9\u05EA',\
	u'\u05E9\u05DE\u05D5\u05EA',\
	u'\u05D5\u05D9\u05E7\u05E8\u05D0',\
	u'\u05D1\u05DE\u05D3\u05D1\u05E8',\
	u'\u05D3\u05D1\u05E8\u05D9\u05DD',\
	u'\u05D9\u05D4\u05D5\u05E9\u05E2',\
	u'\u05E9\u05D5\u05E4\u05D8\u05D9\u05DD',\
	u'\u05E9\u05DE\u05D5\u05D0\u05DC \u05D0',\
	u'\u05E9\u05DE\u05D5\u05D0\u05DC \u05D1',\
	u'\u05DE\u05DC\u05DB\u05D9\u05DD \u05D0',\
	u'\u05DE\u05DC\u05DB\u05D9\u05DD \u05D1',\
	u'\u05D9\u05E9\u05E2\u05D9\u05D4\u05D5',\
	u'\u05D9\u05E8\u05DE\u05D9\u05D4\u05D5',\
	u'\u05D9\u05D7\u05D6\u05E7\u05D0\u05DC',\
	u'\u05D4\u05D5\u05E9\u05E2',\
	u'\u05D9\u05D5\u05D0\u05DC',\
	u'\u05E2\u05DE\u05D5\u05E1',\
	u'\u05E2\u05D5\u05D1\u05D3\u05D9\u05D4',\
	u'\u05D9\u05D5\u05E0\u05D4',\
	u'\u05DE\u05D9\u05DB\u05D4',\
	u'\u05E0\u05D7\u05D5\u05DD',\
	u'\u05D7\u05D1\u05E7\u05D5\u05E7',\
	u'\u05E6\u05E4\u05E0\u05D9\u05D4',\
	u'\u05D7\u05D2\u05D9',\
	u'\u05D6\u05DB\u05E8\u05D9\u05D4',\
	u'\u05DE\u05DC\u05D0\u05DB\u05D9',\
	u'\u05EA\u05D4\u05D9\u05DC\u05D9\u05DD',\
	u'\u05DE\u05E9\u05DC\u05D9',\
	u'\u05D0\u05D9\u05D5\u05D1',\
	u'\u05E9\u05D9\u05E8 \u05D4\u05E9\u05D9\u05E8\u05D9\u05DD',\
	u'\u05E8\u05D5\u05EA',\
	u'\u05D0\u05D9\u05DB\u05D4',\
	u'\u05E7\u05D4\u05DC\u05EA',\
	u'\u05D0\u05E1\u05EA\u05E8',\
	u'\u05D3\u05E0\u05D9\u05D0\u05DC',\
	u'\u05E2\u05D6\u05E8\u05D0',\
	u'\u05E0\u05D7\u05DE\u05D9\u05D4',\
	u'\u05D3\u05D1\u05E8\u05D9 \u05D4\u05D9\u05DE\u05D9\u05DD \u05D0',\
	u'\u05D3\u05D1\u05E8\u05D9 \u05D4\u05D9\u05DE\u05D9\u05DD \u05D1',\
	u'\u05EA\u05D4\u05DC\u05D9\u05DD']
	
if __name__ == "__main__":
	meschta = 'brachos'
	maxPage = 123
	startPage = 3
	#correctDaf = getGemara(meschta,maxPage, startPage, 'gemara')
	correctRashi = getGemara(meschta,maxPage, startPage, 'rashi')
	#correctTos = getGemaraAndComm('tosfos', meschta, dafName,3)









