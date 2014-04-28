function [MAX_EPOC, train_error, test_error, eta_adaptation,train_learning_rate,learning_rate, epocs] = part1_multilayer_simetry(Input, ExpectedOutput ,HiddenUnitsPerLvl , g ,g_derivate,MomentumEnabled, EtaAdaptativeEnabled,TrainInput,TrainExpectedOutput,Filename)
	startTime = time();
	trainPatterns = cat(2,-1*ones(rows(TrainInput),1),TrainInput)	;
	if(Filename)
		load(Filename)
	else
		#########
		##Adding a column of -1 at the beginning with the input value of the threshold,
		##concat that with all the columns exept the last one, which is the expected answer
		#########
		testPatterns =cat(2,-1*ones(rows(Input),1),Input)	;			
		#########
		##taking the last column which will be the expected output
		#########
		inputNodes = columns(Input)		;
		outputNodes = columns(ExpectedOutput)		;

		unitsPerlevel =[inputNodes+1 HiddenUnitsPerLvl.+1 outputNodes]		;
	 	connectedUnits = [0 HiddenUnitsPerLvl 1]		;
	 	HiddenUnitsPerLvl = [0 HiddenUnitsPerLvl 0]		;
		levels = columns(unitsPerlevel)		;
		###wValues: this matrix will have in each row the connections between n+1 layer and current one,
		##in this way level one should have NO wValues
		for i=1:levels-1
			network.(num2str(i+1)).wValues = rand(connectedUnits(i+1),unitsPerlevel(i));
			network.(num2str(i+1)).oldCDeltaValues = 0;
		endfor
		##network		;

		ETA = 0.01;
		EPSILON = 0.01;
		ALPHA = 0.9;
		hasLearnt = 0;
		MAX_EPOC = 10;
		epocs = 1;
		etaDecrement = ETA*0.025;
		etaIncrement = ETA*0.25;
		currK=0;
		K=5;
		errorMedio=0;
		errorMedioAnterior = 0;
		train_error = 0;
		test_error = 0;
		learning_rate = 0;
		eta_adaptation = ETA;
		hit = 0;
		MIN_LEARN_RATE = 0.7;
		train_learning_rate = 0;
		while(hasLearnt != 1 && epocs <= MAX_EPOC)
			hit=0;
			hasLearnt = 1;
			epocStartTime = time();
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
						network.(num2str(j+1)).vValues = cat(2,-1,arrayfun(g, hj)) 	;	
					else 
						network.(num2str(j+1)).vValues = arrayfun(g, hj)	;
					endif
						
				endfor  

				outputValues = network.(num2str(levels)).vValues;
				## END FEED FORWARD

				errorMedioAnterior = errorMedio;
				errorMedio = .5*sum(power((outputValues - currentExpectedOutput),2));
				train_error = [train_error errorMedio]; 
				
				if(abs(outputValues - currentExpectedOutput) > EPSILON)
					hasLearnt = 0;
				else
					hit++;
				endif
				if(hit/rows(Input) > MIN_LEARN_RATE) 
					hasLearnt = 1;
				endif
				train_learning_rate = [train_learning_rate hit/rows(Input)];
				
				network.(num2str(levels)).deltaValues =g_derivate(hj) *(currentExpectedOutput - outputValues );

				## BACKPROPAGATION START
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

					network.(num2str(k-1)).deltaValues =   tempCurrentLvlDeltaValues ;

				endfor 
				##BACKPROPAGATION END

				##CORRECT Ws
				for i=2:levels
					currentLvlWValues = network.(num2str(i)).wValues   		;
					currentLvlVValues = network.(num2str(i-1)).vValues  	;
					currentLvlDeltaValues = (network.(num2str(i)).deltaValues)		;

					calculationWithDelta = ETA * currentLvlDeltaValues' * currentLvlVValues ;
					network.(num2str(i)).wValues =  currentLvlWValues + calculationWithDelta ; 
					if(MomentumEnabled ==1)
						network.(num2str(i)).wValues = network.(num2str(i)).wValues + network.(num2str(i)).oldCDeltaValues * ALPHA ;
					endif

					network.(num2str(i)).oldCDeltaValues = calculationWithDelta ;
				endfor
				##END CORRECT Ws

			endfor
			
			elapsedTime = time() - startTime;
			elapsedEpocTime = time() - epocStartTime;
			printf('Epoca: %d   errorMedio %f eta %f tiempoTotal %f tiempoEpoca %f\n',epocs,errorMedio,ETA,elapsedTime,elapsedEpocTime);
			if(EtaAdaptativeEnabled)
				deltaError = errorMedio - errorMedioAnterior;
				if(deltaError >0)
					ETA = ETA - etaDecrement * ETA;
				else
					if(currK < K)
						currK++;
					else
						ETA+=etaIncrement;
						currK=0;
					endif
						
				endif
					
			endif
			epocs ++;
			eta_adaptation = [eta_adaptation ETA] ; 
		endwhile
		##END TRAINING
		save('trainedNetwork.dump');
	endif
	##START TESTING
	for i = 1:rows(TrainInput)
		currentPattern = trainPatterns(i,:) 		;    

		currentExpectedOutput = TrainExpectedOutput(i,:);

		network.(num2str(1)).vValues = currentPattern;

		network.(num2str(1)).hValues = currentPattern;

		## FEED FORWARD
		for j=1:levels-1

			currentLvlWValues = network.(num2str(j+1)).wValues 		;

			currentLvlVValues = network.(num2str(j)).vValues 		;
			
			hj = (currentLvlWValues * (currentLvlVValues') )' 		;

			network.(num2str(j+1)).hValues = hj;
			if(j!=levels-1)
				network.(num2str(j+1)).vValues = cat(2,-1,arrayfun(g, hj)) 	;	
			else 
				network.(num2str(j+1)).vValues = arrayfun(g, hj)	;
			endif
				
		endfor  

		outputValues = network.(num2str(levels)).vValues;
		## END FEED FORWARD

		errorMedioAnterior = errorMedio;
		errorMedio = .5*sum(power((outputValues - currentExpectedOutput),2));
		test_error = [test_error errorMedio]; 
		if(abs(outputValues - currentExpectedOutput) < EPSILON)
			learning_rate++;
		endif
	endfor
	##END TESTING
	learning_rate = learning_rate /rows(TrainExpectedOutput);
endfunction