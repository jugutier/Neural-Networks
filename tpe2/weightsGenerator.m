function weightsGenerator(HiddenUnitsPerLvl)
	unitsPerlevel =[3 HiddenUnitsPerLvl.+1 1]		;#1
	connectedUnits = [0 HiddenUnitsPerLvl 1]							;#2
	levels = columns(unitsPerlevel)										;#4
	#INITIALIZE WEIGHTS
	wValues = cell(levels,1);	###wValues: connections between 'i' layer and the i-1 one, lvl 1 has NO wValues		
	for i=1:levels-1
		wValues{i+1} = -0.5+rand(connectedUnits(i+1),unitsPerlevel(i));
	endfor
	trainedNetwork = wValues;
	hiddenUnitsPerLvl = HiddenUnitsPerLvl;
	save('generatedWeights.dump','trainedNetwork' ,'hiddenUnitsPerLvl' );
endfunction