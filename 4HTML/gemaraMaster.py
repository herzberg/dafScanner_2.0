# Josh Hertzberg
# Noah Santacruz
# Eli Friedman
# Katie Kroik
# Doni Schwartz
import traceback


def main():
	meschta = 'avodah_zara' #'brachos'
	startPage = 3
	maxPage = 152 #123
	createAllDafs(meschta,maxPage,startPage)
	
	
def createAllDafs(meschta,maxPage,startPage = 3):
	for pageNum in range(startPage,maxPage+1):
		try:
			createFullDaf(meschta, pageNum)
		except:
			logger(traceback.format_exc().splitlines(),meschta, '', pageNum)

def createFullDaf(meschta, pageNum):
	body  = headers # Write the beginning before the line stuff

	types = ['gemara', 'rashi','tosfos'] #tosfos
	for type in types:
		text = getText(type, meschta, pageNum)
		lineTypes = getLineTypes(type, meschta, pageNum)
		if len(lineTypes) != len(text):
			logger("ocr_stat_line_miscount: %s %s" % (len(text),len(lineTypes)),meschta, type, pageNum)

		body += '<div class="' + type + '"><span>\n'
		body += writeLines(text, lineTypes)
		
	body += '</div>\n</div>\n</body>\n</html>'
	daf = open("../gemara/" + meschta + "/" + str(pageNum) + "_fullDaf.html", "w")
	daf.write(body)
	daf.close()
	

def getLineTypes(type, meschta, pageNum):
	fname = '../' + type + '/' + meschta + '/' + str(pageNum) +  '_stats.txt'
	typeDict = {'gemara21':'left','gemara31':'all','gemara12':'center','gemara22':'right',
		'rashi22':'h-right', 'rashi13':'t-right', 'rashi21':'h-left','rashi11':'t-left','rashi33':'all',
		'tosfos22':'h-right', 'tosfos13':'t-right', 'tosfos21':'h-left','tosfos11':'t-left','tosfos33':'all'}
	
	with open(fname) as f:
		lines = f.readlines()
	i = 0
	lineTypes = []
	for line in lines:
		nums = line.split(',') #1:width,2:start
		try:
			lineType = typeDict[type + nums[1] + nums[2]]
		except:
			logger('unknown line type: ' + nums[1] + nums[2],meschta, type, pageNum, i)
			
		lineTypes.append(lineType)
		i += 1
	return lineTypes
	

def formatedLine(line,lineType):
	text =''
	if(formatedLine.lastType != lineType):
		text +='</span>\n'
		text += '<span class="' + lineType + '">\n'
	line = line.replace("\n","")
	text += '<span class="lb">' + line + '</span>\n'
	formatedLine.lastType = lineType
	return text
formatedLine.lastType = ''
	
def writeLines(text,lineTypes):
	output = ''
	for i in range(len(text)):
		line = text[i]
		lineType = lineTypes[i]
		output += formatedLine(line,lineType)
	output += '</span></div>\n'
	return output
	

def getText(type, meschta, pageNum):
	fname = '../' + type + '/' + meschta + '/' + str(pageNum) +  '_myDaf.txt'
	with open(fname) as f:
		text = f.readlines()
	return text
	

def logger(message,meschta='',type='',dafNum='',line='',doPrint=True):
	line = '%s:%s:%s:%s: %s' % (meschta,type,dafNum,line,message)
	if doPrint:
		print(line)
	logger.file.write(line + '\n')

logger.file = open('log.txt','w')
	
def getDivriHamasKil(rText): #not sure how much it can do
	start = rText.find(':')
	if(start >= 0):
		temp = rText
		rText = temp[0:start-1]
		rText += '<\b>'
		rText += temp[start:]
	end = rText.find('-')
	if(end >= 0):
		temp = rText
		rText = temp[0:end]
		rText += '<b>'
		rText += temp[end+1:]

# Writes the top of the HTML File
	# AUTOMATE THINGS LIKE TITLE, KEYWORDS, DESCRIPTION

headers = """<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/> 
<meta name="description" content=" " />
<meta name="keywords" content="" />

<title> AWESOME DAF!!! </title> 

<link rel="stylesheet" href="../../4HTML/main.css" type="text/css" media="all"/>
<link rel="stylesheet" href="../../4HTML/index.css" type="text/css" media="all"/>
<link rel="stylesheet" href="../../4HTML/talmudBavli.css" type="text/css" media="all"/>  

</head>
<body dir="rtl">


<div id="content">


<div id='talmud-bavli'><span id="comment-show" hidden=''></span>

<div id='gpt'>
"""

	
if __name__ == "__main__":
	main()
	
	
