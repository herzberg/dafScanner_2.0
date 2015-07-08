# Josh Hertzberg
# Noah Santacruz
# Eli Friedman
# Katie Kroik
# Doni Schwartz

# ********************************************
# Hack Cooper, 2015 / YU Hack 2015
# ********************************************
#input

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

def formatedLine(line,type):
	text =''
	if(formatedLine.lastType != type):
		if(formatedLine.lastType != ''):
			text +='</span>\n'
		text += '<span class="' + type + '">\n'
	line = line.replace("\n","")
	text += '<span class="lb">' + line + '</span>\n'
	formatedLine.lastType = type
	return text
formatedLine.lastType = ''
	

def writeInFile(gemaraText, rashiText, tosText, headers,meschta, pageNum,gStats,rStats,tStats):
	# TODO : Will be a modular name
	daf = open("../gemara/" + meschta + "/" + str(pageNum) + "_fullDaf.html", "w")

	daf.write(headers)# Write the beginning before the line stuff

	# Gemara
	body = ''
	body += '<div class="gmara">\n'
#	for line in gemaraText:
	for i in range(len(gemaraText)):
		line = gemaraText[i]
		"""
		type = 'center' # 'left' 'right' 'all'
		if i >= len(gemaraText) -3:
			type = 'left'
		if i >= len(gemaraText) -1:
			type = 'all'
		"""
		type =gStats[i]
		body += formatedLine(line,type)
	body += '</span></div>'	
	daf.write(body)

	#rashi
	body = '<div class="rashi"><span class="h-left">\n'
	for i in range(len(rashiText)):
		line = rashiText[i]
		type = 'h-left'	# 't-left' 'h-left' 'h-right' 't-left'
		if(i >= 4):
			type = 't-left'
		body += formatedLine(line,type)
	body += '</span></div>\n'
	daf.write(body)

	#tosfot
	body = '<div class="tosfot"><span class="h-right">\n'
	for i in range(len(tosText)):
		line = tosText[i]
		if(i == 4):
			body += '</span><span class="t-right">'
		body += '<span class="lb">' + line + '</span>\n'
	body += '</span></div>\n'
	daf.write(body)

	closeFile = '</div>\n</div>\n</body>\n</html>'
	daf.write(closeFile)




def getText(type, meschta, pageNum):
	fname = '../' + type + '/' + meschta + '/' + str(pageNum) +  '_myDaf.txt'
	with open(fname) as f:
		text = f.readlines()
	return text
	
def getGemaraLineWidth(meschta, pageNum):
	fname = '../' + 'gemara' + '/' + meschta + '/' + str(pageNum) +  '_stats.txt'
	lineTypes = []
	lineType =''
	with open(fname) as f:
		lines = f.readlines()
	i = 0
	for line in lines:
		nums = line.split(',') #width,start
		if nums[2] == '1' and nums[1] == '2':
			lineType = 'left'
		elif nums[2] == '1' and nums[1] == '3':
			lineType = 'all'
		elif nums[2] == '2' and nums[1] == '1':
			lineType = 'center'
		elif nums[2] == '2' and nums[1] == '2':
			lineType = 'right'
		else: #if nums[2] == '1' and nums[1] == '1': elif nums[2] == '2' and nums[1] == '3':
			logState = meschta + " " + str(pageNum) + " " + str(i) + ' - unknown line type'
			print(logState)
			log.write(logState+'\n')
		lineTypes.append(lineType)
		i += 1
	return lineTypes
	
def createFullDaf(meschta,maxPage,startPage = 3):
	for pageNum in range(startPage,maxPage+1):
		try:
			type = 'gemara'
			gText = getText(type, meschta, pageNum)
			gStats = getGemaraLineWidth(meschta,pageNum)
			rStats = gStats
			tStats = gStats
			#type = 'rashi'
			rText = getText(type, meschta, pageNum)
			#type = 'tosfos'
			tText = getText(type, meschta, pageNum)
			writeInFile(gText, rText, tText,headers,meschta, pageNum,gStats,rStats,tStats)
		except:
			logState = meschta + " " + str(pageNum) + ' - createFullDaf fail'
			print(logState)
			log.write(logState +'\n')

log = open('log.txt','w')
def main():
	meschta = 'brachos'
	startPage = 3
	maxPage = 123
	createFullDaf(meschta,maxPage,startPage)
	
if __name__ == "__main__":
	main()