function retVal = part1_multilayer_simetry(Input, ExpectedOutput ,HiddenUnitsPerLvl , g ,g_derivate)
	startTime = time();
	#########
	##Adding a column of -1 at the beginning with the input value of the threshold,
	##concat that with all the columns exept the last one, which is the expected answer
	#########
	testPatterns =cat(2,-1*ones(rows(Input),1),Input)		
	#########
	##taking the last column which will be the expected output
	#########
	inputNodes = columns(Input)		
	outputNodes = columns(ExpectedOutput)		

	unitsPerlevel =[inputNodes+1 HiddenUnitsPerLvl.+1 outputNodes]		
 	connectedUnits = [0 HiddenUnitsPerLvl 1]		
 	HiddenUnitsPerLvl = [0 HiddenUnitsPerLvl 0]		
	levels = columns(unitsPerlevel)		
	###wValues: this matrix will have in each row the connections between n+1 layer and current one,
	##in this way level one should have NO wValues
	for i=1:levels-1
		network.(num2str(i+1)).wValues = rand(connectedUnits(i+1),unitsPerlevel(i));
	endfor
	##network		;

	ETA = 0.01;
	EPSILON = 0.1;
	hasLearnt = 0;
	MAX_EPOC = 200;
	epocs = 1;
	while(hasLearnt != 1 && epocs <= MAX_EPOC)
		hasLearnt = 1; 
		for i = 1:rows(testPatterns)
			currentPattern = testPatterns(i,:) 		;    

			currentExpectedOutput = ExpectedOutput(i,:);

			network.(num2str(1)).vValues = currentPattern;

			network.(num2str(1)).hValues = currentPattern;

			## FEED FORWARD
			for j=1:levels-1

				currentLvlWValues = network.(num2str(j+1)).wValues 		;

				currentLvlVValues = network.(num2str(j)).vValues 		;
				
				hj = (currentLvlWValues * (currentLvlVValues') )' 		;

				network.(num2str(j+1)).hValues = hj;
				if(j!=levels-1)
					network.(num2str(j+1)).vValues = cat(2,-1,arrayfun(@g, hj)) 	;	
				else 
					network.(num2str(j+1)).vValues = arrayfun(@g, hj)	;
				endif
					
			endfor  

			outputValues = network.(num2str(levels)).vValues;
			## END FEED FORWARD

			
			errorMedio = .5*sum(power((outputValues - currentExpectedOutput),2)) 
			if(abs(outputValues - currentExpectedOutput) > EPSILON) 
				hasLearnt = 0;
			endif

			network.(num2str(levels)).deltaValues =g_derivate(hj) *(currentExpectedOutput - outputValues );

			##network
			for k = levels :-1: 2		

				displacementIndexes = linspace(1,HiddenUnitsPerLvl(k-1),HiddenUnitsPerLvl(k-1)).+1     ;	#hay que sacar el peso del -1, el peso del umbral, la primer columna, para volver
				
				currentLvlWValues = network.(num2str(k)).wValues;  
				
				currentLvlWValues = currentLvlWValues(:,displacementIndexes)     	;	# ahora empiezo a volver entonces es desde la raiz hacia abajo, hacer el dibujo del arbol dado vuelta

				h = network.(num2str(k-1)).hValues 		;
				
				delta = network.(num2str(k)).deltaValues 	;


				tempCurrentLvlDeltaValues=0;
				for i=1 :columns(currentLvlWValues)
					deltai = g_derivate(h(i))* (delta * currentLvlWValues(:,i))		;

					tempCurrentLvlDeltaValues(i) = deltai;
				endfor


				##tempCurrentLvlDeltaValues

				network.(num2str(k-1)).deltaValues =   tempCurrentLvlDeltaValues ;

				##temp = (currentLvlWValues * delta')


				##gderivateh = g_derivate(h)
				##for i=1:columns(gderivateh) 
				##	gderivateh(i) * temp
				##endfor

				##currentLvlDeltaValues = (g_derivate(h) * (currentLvlWValues * delta')' )			

				##network.(num2str(k-1)).deltaValues =   currentLvlDeltaValues ;    

				
			endfor 
			##network

			##subir corrigiendo los ws
			for i=2:levels
					currentLvlWValues = network.(num2str(i)).wValues   		;
					currentLvlVValues = network.(num2str(i-1)).vValues  	;
					currentLvlDeltaValues = (network.(num2str(i)).deltaValues)		;

					network.(num2str(i)).wValues =  currentLvlWValues + ETA * currentLvlDeltaValues' * currentLvlVValues ;
					
					currentLvlWValues = network.(num2str(i)).wValues   ;
					
					##network(1).wValues  = network(1).wValues + ETA * (network(1).deltaValues)' * currentPattern 
			endfor
			##end subir

		endfor
		epocs = epocs +1;
	endwhile
epocs
network

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