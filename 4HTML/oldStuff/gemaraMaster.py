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
	rBeginning = '<span class="rashi">'
	daf.write(rBeginning)

	# Divide the measurements
	rWidth = mRashi.split(',')


	# Putting in the breaks and the text

	numLine = 0

	# For each line of the rashi, make the divisions
	
	for rLine in rashiText:
		rashi = ' '
		for rWord in rLine:
			rashi += rWord
		divOne = '<div style="float:left;clear:left;height:{0}px;width:{1}%">{2}</div>'.format(numlineHeight, rWidth[numLine], rashi)
		daf.write(divOne)
	
	"""
	for rWord in rashiText:
		width = measurements[numLine].split(",")
		rashi += rWord
		divOne = '<div style="float:left;clear:left;height:{0}px;width:{1}%">{2}</div>'.format(numlineHeight, width[1], rashi)
		daf.write(divOne)
	"""
	rEnd = '</span>'
	daf.write(rEnd)

	for gLine in gemaraText:
		gemara = ' '
		for gWord in gLine:
			gemara += gWord
		gemara += '<br>'

	for tLine in tosafosText:
		#width = measurements[numLine].split(",")
		tosafos = ' '
		for tWord in tLine:
			tosafos += tWord
		#divTwo = '<div style="float:right;clear:right;height:{0}px;width:{1}%">{2}</div>'.format(numlineHeight, width[2], tosafos)
		#daf.write(divTwo)
		numLine += 1




		# Split it into widths
		#width = rMeasurements[rNumLine].split(",")

		# Float : left, clear : left, height : 15 px, width :  ]
		
		# TODO : NOT WRITING IN SHAPES


		daf.write(gemara)

		#for word in line: 
		#	rashi = rashi + word

		#rashi = rashi + '<br>'

	gText = '<p> {} </p>'.format(gemara)
	rEnd = ' </div>'

	#daf.write(gText)
	daf.write(rEnd)

	# Close file
	closeFile = '</body></html>'

	daf.write(closeFile)
	daf.close()

	# ********************************************
	# ********************************************

	# Gemara
	# ********************************************
	"""
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
		width = gMeasurements[gNumLine].split(",")
		tosafosDiv = '<div style="float:left;clear:left;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[1])
		tosafosDivTwo = '<div style="float:right;clear:right;height:{0}px;width:{1}%"></div>'.format(numlineHeight, width[2])
		# TODO : NOT WRITING IN SHAPES

		daf.write(tosafosDiv)
		daf.write(tosafosDivTwo)
		rNumLine += 1
		
		for word in line: 
			tosafos = tosafos + word
		
		tosafos = tosafos + '<br>'

	gText = '<p>{}</p>'.format(tosafos)

	gEnd = '</div>'

	daf.write(gText)
	daf.write(gEnd)
	"""
	# ********************************************
	# ********************************************


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

	rashiArray = ["s who were moiser nefesh and were niftar to give a chiyus to our nation. Yashrus is mechayev us to do this... Lemaise, hagam the velt won't be goires or machshiv what we speak out here, it's zicher not shayach for them to forget that they tued uf here. We are mechuyav to be meshabed ourselves to the melocha in which these soldiers made a haschala--that vibalt they were moiser nefesh for this eisek, we must be mamash torud in it--that we are all mekabel on ourselves to be moisif on their peula so that their maisim should not be a bracha levatulla-- that Hashem should give the gantze oilam a naiya bren for cheirus-- that a nation that shtams by the oilam, by the oilam, by the oilam, will blaib fest ahd oilam."]
            
	rashiMeasure = '25, 25, 25, 20, 20, 20'
	
	gemaraArray = ["by a geferliche machloikes being machria if this medina, or an andere medina made in the same oifen and with the same machshovos, can have a kiyum. We are all mitztaref on the daled amos where a chalois of that machloikes happened in order to be mechabed the soldiers who dinged zich with each other. We are here to be koiveia chotsh a chelek of that karka as a kever for the bekavodike soldiers who were moiser nefesh and were niftar to give a chiyus to our nation. Yashrus is mechayev us to do this... Lemaise, hagam the velt won't be goires or machshiv what we speak out here, it's zicher not shayach for them to forget that they tued uf here. We are mechuyav to be meshabed ourselves to the melocha in which these soldiers made a haschala--that vibalt they were moiser nefesh for this eisek, we must be mamash torud in it--that we are all mekabel on ourselves to be moisif on their peula so that their maisim should not be a bracha levatulla-- that Hashem should give the gantze oilam a naiya bren for cheirus-- that a nation that shtams by the oilam, by the oilam, by the oilam, will blaib fest ahd oilam."]

	gemaraMeasure = "7.5,20,15|22.5,20,15|37.5,20,15|52.5,20,15|67.5,20,15|82.5,20,15|97.5,10,15|112.5,10,10|127.5,10,10|142.5,10,10|112.5,10,10|127.5,10,10|142.5,10,10|112.5,10,10|127.5,10,10|142.5,10,10"

	tosafosArray = ["s who were moiser nefesh and were niftar to give a chiyus to our nation. Yashrus is mechayev us to do this... Lemaise, hagam the velt won't be goires or machshiv what we speak out here, it's zicher not shayach for them to forget that they tued uf here. We are mechuyav to be meshabed ourselves to the melocha in which these soldiers made a haschala--that vibalt they were moiser nefesh for this eisek, we must be mamash torud in it--that we are all mekabel on ourselves to be moisif on their peula so that their maisim should not be a bracha levatulla-- that Hashem should give the gantze oilam a naiya bren for cheirus-- that a nation that shtams by the oilam, by the oilam, by the oilam, will blaib fest ahd oilam."]

	tosafosMeasure = "7.5,85,0|22.5,85,0|37.5,85,0|52.5,91,0|67.5,91,0|82.5,91,0|97.5,91,0|112.5,91,0|127.5,91,0|142.5,91,0|157.5,91,0|172.5,91,0|187.5,91,0|202.5,91,0|217.5,91,0|232.5,91,0|247.5,91,0|262.5,91,0|277.5,91,0|292.5,91,0|307.5,91,0|322.5,91,0277.5,91,0|292.5,91,0|307.5,91,0|322.5,91,0277.5,91,0|292.5,91,0|307.5,91,0|322.5,91,0"

	writeInFile(rashiArray, gemaraArray, tosafosArray, rashiMeasure, gemaraMeasure, tosafosMeasure)
	

if __name__ == "__main__":
	main()

# **** POTENTIALLY USEFUL DELETED STUFF ****
# ********************************************

# We're goooooood