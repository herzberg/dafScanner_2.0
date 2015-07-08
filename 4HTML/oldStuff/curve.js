function shapeWrapper(lineHeight,Xs) {
	var out = '';
	Xvalues = Xs.split('|');
	for(i=0; i < Xvalues.length; i++) {
		parts = Xvalues[i].split(',');
		out += '<div class="background" style="float:left;clear:left;height:'+lineHeight+'px;width:'+ parts[1]+'%"></div>';
		out += '<div class="background" style="float:right;clear:right;height:'+lineHeight+'px;width:'+ parts[2]+'%"></div>';
	}
	document.write(out);
}