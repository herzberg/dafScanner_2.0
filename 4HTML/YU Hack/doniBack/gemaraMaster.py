# Josh Hertzberg
# Noah Santacruz
# Eli Friedman
# Katie Kroik
# Doni Schwartz

# ********************************************
# Hack Cooper, 2015 / YU Hack 2015
# ********************************************
    
# TODO : 
# 	Katie TODO : 
#		- EVERYTHING
#
#   Doni TODO :
#		- Eat Katya

# ********************************************

# Makes the HTML file

# Input: 
#	Currently: writeInFile(a,b)
#		a = [gemara-line-size, gemara-line-text]
#		b = [rashi-line-size, rashi-line-text]
#
#	Goal: writeInFile(a,b,c)
#		a = [gemara-line-size, gemara-line-text]
#		b = [rashi-line-size, rashi-line-text]
#		c = [tosafot-line-size, tosafot-line-text]

# lineSize guide:
# 	Gemara:
#		1: small lines - center of the amud
#		2: medium wide, left (extends out under commentator to the left)
#		3: medium wide, right (extends out under commentator to the right)
#		4: wide lines - use up entire line
#		
#	Rashi:
#		1: wide Rashi line, like top of amud
#		2: standard small Rashi line
#
#


#input
fname = 'gemara'  #'gemara'
fname += '/myDaf.txt'
with open(fname) as f:
    gemaraText = f.readlines()

fname = 'rashi'  #'rashi'
fname += '/myDaf.txt'
with open(fname) as f:
    rashiText = f.readlines()

def writeInFile(gemaraText, rashiText):


	# TODO : Will be a modular name
	# Opens a new HTML file
	daf = open("testCode.html", "w")

	# Writes the top of the HTML File
	# AUTOMATE THINGS LIKE TITLE, KEYWORDS, DESCRIPTION
	openFile = """<!DOCTYPE html>

	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/> 
		<meta name="description" content=" " />
		<meta name="keywords" content="" />
		
		<title> INSERT TITLE </title> 
	            
		<link rel="stylesheet" href="main.css" type="text/css" media="all"/>
		<link rel="stylesheet" href="index.css" type="text/css" media="all"/>
		<link rel="stylesheet" href="talmudBavli.css" type="text/css" media="all"/>  
			
	</head>
	<body dir="rtl">


	<div id="content">


	<div id='talmud-bavli'><span id="comment-show" hidden=''></span>'

	<divid='gpt'>
	"""

	# Write the beginning before the line stuff
	daf.write(openFile)

	# Writing the other stuff

	# ********************************************
	# ********************************************


	# Gemara
	# ********************************************
	gBeginning = '<div class="gmara">\n'
	daf.write(gBeginning)

	# For each line of the gemara, make the divisions
	
	for gLine in gemaraText:
		lineSize = gLine[0]
		gText = gLine[1]

		#structure line of Gemara text
		gBody = ''
		if(lineSize == 1): #small Gemara line, in center of amud
			gBody = '<span class="center"><span class="lb">{0}</span></span>\n'.format(gText[0:-1])
		if(lineSize == 2): #medium-wide line that extends under commentator to the left
			gBody = '<span class="left"><span class="lb">{0}</span></span>\n'.format(gText[0:-1])
		if(lineSize == 3): #medium-wide line that extends under commentator to the right
			gBody = '<span class="right"><span class="lb">{0}</span></span>\n'.format(gText[0:-1])
		if(lineSize == 4): #wide line, covers width of amud
			gBody = '<span class="all"><span class="lb">{0}</span></span>\n'.format(gText[0:-1])

		daf.write(gBody)

	gEnd = '</div>\n'
	daf.write(gEnd)


	# Rashi
	# ********************************************
	gBeginning = '<div class="rashi">\n'
	daf.write(gBeginning)

	# For each line of the rashi, make the divisions
	for rLine in rashiText:
		lineSize = rLine[0]
		rText = rLine[1]

		#****** bold dibbur hamatchil
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
		#******

		#structure line of Rashi text
		rBody = ''		
		if(lineSize == 1): #wide Rashi line, like top of amud
			rBody = '<span class="h-left"><span class="lb">{0}</span></span>\n'.format(rText[0:-1])
		if(lineSize == 2): #standard small Rashi line
			rBody = '<span class="t-left"><span class="lb">{0}</span></span>\n'.format(rText[0:-1])
		if(lineSize == 3): #placeholder for other line formats
			pass
		daf.write(rBody)


	gEnd = '</div>\n'
	daf.write(gEnd)


	closeFile = """</div> 
	</div>

	</body>

	</html>
	"""
	daf.write(closeFile)


# 
def main():
	writeInFile(gemaraText, rashiText)

if __name__ == "__main__":
	main()
	#writeInFile(gemaraText, rashiText)

# **** POTENTIALLY USEFUL DELETED STUFF ****
# ********************************************

# We're goooooood