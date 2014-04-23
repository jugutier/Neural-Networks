function retVal = part1_multilayer_simetry(Input, ExpectedOutput ,HiddenUnitsPerLvl , g ,g_derivate)
	startTime = time();
	#########
	##Adding a column of -1 at the beginning with the input value of the threshold,
	##concat that with all the columns exept the last one, which is the expected answer
	#########
	testPatterns =cat(2,-1*ones(rows(Input),1),Input);
	#########
	##taking the last column which will be the expected output
	#########
	inputNodes = columns(Input);
	outputNodes = columns(ExpectedOutput);

 
	levels = columns(HiddenUnitsPerLvl)+2 ##add inputlayer and outputlayer
	###wValues: this matrix will have in each row the connections between the previous layer and current one
	network(1).wValues = rand(HiddenUnitsPerLvl(1),inputNodes+1);##+1 because of the extra node
	for i=2:levels-2 ##outputLevel will be a special case
		network(i+1).wValues = rand(HiddenUnitsPerLvl(i+2),HiddenUnitsPerLvl(i+1)+1);

	endfor
	##outputLevel:
	network(levels).wValues = rand(outputNodes,HiddenUnitsPerLvl(levels)+1)


	ETA = 0.05;
	EPSILON = 0.01;
	hasLearnt = 0;

	while(hasLearnt != 1)
		hasLearnt = 1; 
		for i = 1:rows(testPatterns)
			currentPattern = testPatterns(i,:)     

			currentExpectedOutput = ExpectedOutput(i,:);

			network(1).vValues = currentPattern

			for j=1:levels

				currentLvlWValues = network(j).wValues;

				currentLvlVValues = network(j).vValues;
				
				hj = (currentLvlWValues * (currentLvlVValues') )' 

				network(j).hValues = hj;

				network(j+1).vValues = cat(2,-1,arrayfun(@g, hj)) ##when j is levels this value has no sense

			endfor  

			outputValues = arrayfun(@g,hj)



			if(abs(outputValues - currentExpectedOutput) > EPSILON) 
				hasLearnt = 0;
			endif

			network(levels).deltaValues = g_derivate(hj) *(currentExpectedOutput - outputValues )

			for k = levels-1 : 1			

				displacementIndexes = linspace(1,HiddenUnitsPerLvl(k-1),HiddenUnitsPerLvl(k-1)).+1     #hay que sacar el peso del -1, el peso del umbral, la primer columna, para volver

				lavariable = network(k).wValues(:,displacementIndexes)'     # ahora empiezo a volver entonces es desde la raiz hacia abajo, hacer el dibujo del arbol dado vuelta
				
				h = network(k-1).hValues ;
				
				delta = network(k-1).deltaValues ;

				network(k).deltaValues =   g_derivate(h) * sum(lavariable * delta )       

				network(k).wValues = network(k).wValues + ETA * network(k).deltaValues* network(k).vValues ;     

				
			endfor 

			network(1).wValues  = network(1).wValues + ETA * (network(1).deltaValues)' * currentPattern 

		endfor
	endwhile



##	ElapsedTime = time() - startTime
##	disp("Checking result...")
##	for i = 1:rows(testPatterns)
##		currentPattern = testPatterns(i,:);
##
##		currentExpectedOutput = ExpectedOutput(i,:);
##
##		h1 = (currentWValues * (currentPattern'))';
##
##		inputNodesLvl2 = cat(2,-1,arrayfun(@g, h1));		
##
##		h2 = (currentWValuesLvl2 * (inputNodesLvl2'))';
##
##		outputValues = arrayfun(@g,h2);
##		outputValues
##		currentExpectedOutput
##		if(abs(outputValues - currentExpectedOutput) > EPSILON) 
##			disp("Stupid network... didn't learn")
##		endif
##	endfor
endfunction