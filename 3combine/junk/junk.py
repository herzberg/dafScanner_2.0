	
#pdb.set_trace()
fileName = 'rashi/merged.json'
#fileName = 'english.json'
mesechtaText = getMesText(fileName)
#digWords = getDaf(3,mesechtaText)
digWords = getRashiDaf(3,mesechtaText)
#print(digWords)
wordCounts = getWordCounts('rashi/dafNumWords.txt')
letCounts = getLetCounts('rashi/dafNumChars.txt')
scanWords = getScanWords('rashi/daf.txt')

correctDaf = combine(digWords,wordCounts, letCounts, scanWords)
#print(correctDaf)
correctDaf2Lines(correctDaf)

