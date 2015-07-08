# Josh Hertzberg
# Noah Santacruz
# Eli Friedman
# Katie Kroik
# Doni Schwartz

# ********************************************
# Hack Cooper, 2015
# ********************************************
    
# TODO : 
# 	Katie TODO : 
#		- EVERYTHING

# 	Need from other people TODO : 	
# 		- files
#		- measurements
#		- somehow get names of each outputted html

# ********************************************


# Makes the HTML file
# Takes in the height of each line, and the width of whatever, and inserts that into the HTML File
# Do we have a certain amount of lines, to parse?
# TODO : The arrays of Rashi and stuff are all going to be [[line], [line], [line]]
# TODO : need width of each one 
# TODO : Measurements is also an array, of measurements

def writeInFile(rashiText, gemaraText, tosafosText, mRashi, mGemara, mTosafos):

	# TODO : I hardcoded linehieght. Just saying. 
	numlineHeight = 15

	#writeInFile(lineHeight, Xs)

	# TODO : Will be a modular name
	# Opens a new HTML file
	daf = open("testCode.html", "w")

	# Writes the top of the HTML File
	openFile = ' <!DOCTYPE html><html><link rel="stylesheet" href="hi.css"><body>'

	# Write the beginning before the line stuff
	daf.write(openFile)

	# Writing the other stuff

	# ********************************************
	# ********************************************

	# Rashi
	# ********************************************
	rBeginning = '<div class="rashi">'
	daf.write(rBeginning)

	# Divide the measurements
	rMeasurements = mRashi.split('|')

	# Putting in the breaks and the text
	rashi = ' '
	rNumLine = 0

	# For each line of the rashi, make the divisions
	for line in rashiText:
		width = rMeasurements[rNumLine].split(",")
		rashiDiv = '<div style="float:left;clear:left;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[1])
		rashiDivTwo = '<div style="float:right;clear:right;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[2])
		# TODO : NOT WRITING IN SHAPES

		daf.write(rashiDiv)
		daf.write(rashiDivTwo)
		rNumLine += 1
		for word in line: 
			rashi = rashi + word

		rashi = rashi + '<br>'

	rText = '<p> {} </p>'.format(rashi)
	rEnd = ' </div>'

	daf.write(rText)
	daf.write(rEnd)

	# ********************************************
	# ********************************************

	# Gemara
	# ********************************************

	gBeginning = '<div class="gemara">'
	daf.write(gBeginning)

	gMeasurements = mGemara.split('|')

	gemara = ' '
	gNumLine = 0

	# For each line of the gemara, make the divisions
	for line in gemaraText:
		# Split the divs
		width = gMeasurements[gNumLine].split(",")
		gemaraDiv = '<div style="float:left;clear:left;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[1])
		gemaraDivTwo = '<div style="float:right;clear:right;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[2])
		# TODO : NOT WRITING IN SHAPES

		daf.write(gemaraDiv)
		daf.write(gemaraDivTwo)
		rNumLine += 1
		for word in line: 
			gemara = gemara + word

		gemara = gemara + '<br>'

	gText = '<p>{}</p>'.format(gemara)
	gEnd = '</body></div>'

	daf.write(gText)
	daf.write(gEnd)

	# ********************************************
	# ********************************************

	# Tosafos
	# ********************************************

	tBeginning = '<div class="tosafos">'
	daf.write(tBeginning)

	tMeasurements = mTosafos.split('|')

	tosafos = ' '
	tNumLine = 0

	# For each line of the tosafos, make the divisions
	for line in tosafosText:
		width = tMeasurements[gNumLine].split(",")
		tosafosDiv = '<div style="float:left;clear:left;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[1])
		tosafosDivTwo = '<div style="float:right;clear:right;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[2])
		# TODO : NOT WRITING IN SHAPES

		daf.write(tosafosDiv)
		daf.write(tosafosDivTwo)
		rNumLine += 1
		
		for word in line: 
			tosafos = tosafos + word
		
		tosafos = tosafos + '<br>'

	tText = '<p>{}</p>'.format(tosafos)

	tEnd = '</div>'

	daf.write(tText)
	daf.write(tEnd)

	# ********************************************
	# ********************************************

	# Close file
	closeFile = '</body></html>'

	daf.write(closeFile)
	daf.close()

	"""
	out = ''
    Xvalues = Xs.split('|')
    for i in range(len(Xvalues)):
        parts = Xvalues[i].split(',');
        out += '<div style="float:left;clear:left;height:'+lineHeight+'px;width:'+ parts[0]+'px"></div>\n';
        out += '<div style="float:right;clear:right;height:'+lineHeight+'px;width:'+ parts[1]+'px"></div>\n';
    print(out)
    """
     
     
# Gets the shape of the rashi, gemara, and tosafos
def getShape():
	print("hello")

# Takes in rashi, gemara, and tosafos texts with their measurements 
def main():
	# TODO : Shouldn't be hardcoded. Just saying. 

	rashiArray = [
        ["RASHI : In the beginning God created the heaven and the earth."], ["Now the earth was unformed and void, and darkness was upon the face of the deep; and the spirit of God hovered over the face of the waters."],
        ["Now the earth was unformed and void, and darkness was upon the face of the deep; and the spirit of God hovered over the face of the waters."]]
            
	rashiMeasure = "7.5,0,85|22.5,0,85|37.5,0,85|52.5,0,85|67.5,0,85|82.5,0,85|97.5,0,92|112.5,0,92|127.5,0,92|142.5,0,92|157.5,0,92|172.5,0,92|187.5,0,92|202.5,0,92|217.5,0,92|142.5,0,92|157.5,0,92|172.5,0,92|187.5,0,92|202.5,0,92|217.5,0,92|142.5,0,92|157.5,0,92|172.5,0,92|187.5,0,92|202.5,0,92|217.5,0,92"
	
	gemaraArray = [
        ["GEMARA : In the beginning God created the heaven and the earth."], ["Now the earth was unformed and void, and darkness was upon the face of the deep; and the spirit of God hovered over the face of the waters."],
        ["Now the earth was unformed and void, and darkness was upon the face of the deep; and the spirit of God hovered over the face of the waters."]]

	gemaraMeasure = "7.5,20,15|22.5,20,15|37.5,20,15|52.5,20,15|67.5,20,15|82.5,20,15|97.5,10,15|112.5,10,10|127.5,10,10|142.5,10,10|112.5,10,10|127.5,10,10|142.5,10,10|112.5,10,10|127.5,10,10|142.5,10,10"

	tosafosArray = [
        ["TOSAFOS : In the beginning God created the heaven and the earth."], ["Now the earth was unformed and void, and darkness was upon the face of the deep; and the spirit of God hovered over the face of the waters."],
        ["Now the earth was unformed and void, and darkness was upon the face of the deep; and the spirit of God hovered over the face of the waters."]]

	tosafosMeasure = "7.5,85,0|22.5,85,0|37.5,85,0|52.5,91,0|67.5,91,0|82.5,91,0|97.5,91,0|112.5,91,0|127.5,91,0|142.5,91,0|157.5,91,0|172.5,91,0|187.5,91,0|202.5,91,0|217.5,91,0|232.5,91,0|247.5,91,0|262.5,91,0|277.5,91,0|292.5,91,0|307.5,91,0|322.5,91,0277.5,91,0|292.5,91,0|307.5,91,0|322.5,91,0277.5,91,0|292.5,91,0|307.5,91,0|322.5,91,0"

	writeInFile(rashiArray, gemaraArray, tosafosArray, rashiMeasure, gemaraMeasure, tosafosMeasure)
	

if __name__ == "__main__":
	main()

# **** POTENTIALLY USEFUL DELETED STUFF ****
# ********************************************

# We're goooooood