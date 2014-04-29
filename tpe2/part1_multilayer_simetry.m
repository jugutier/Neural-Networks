function [MAX_EPOC, train_error, test_error, eta_adaptation,train_learning_rate,learning_rate, epocs ,trainedNetwork, hiddenUnitsPerLvl] = part1_multilayer_simetry(Input, ExpectedOutput ,HiddenUnitsPerLvl , g ,g_derivate,MomentumEnabled, EtaAdaptativeEnabled,TrainInput,TrainExpectedOutput,Network)
	hiddenUnitsPerLvl = HiddenUnitsPerLvl;
	startTime = time();
	trainPatterns = cat(2,-1*ones(rows(TrainInput),1),TrainInput)	;
	wValues = Network
	if(rows(wValues)==0)
		testPatterns = horzcat(linspace(-1,-1,rows(Input))' , Input); #add threshold
		inputNodes = columns(Input)		;
		outputNodes = columns(ExpectedOutput)		;
		unitsPerlevel =[inputNodes+1 HiddenUnitsPerLvl.+1 outputNodes]		;
	 	connectedUnits = [0 HiddenUnitsPerLvl 1]		;
	 	HiddenUnitsPerLvl = [0 HiddenUnitsPerLvl 0]		;
		levels = columns(unitsPerlevel)		;		
		vValues = cell(levels,1);
		hValues = cell(levels,1);
		deltaValues = cell(levels,1);
		oldCDeltaValues = cell(levels,1);
		#INITIALIZE WEIGHTS
		wValues = cell(levels,1);	###wValues: connections between 'i' layer and the i-1 one, lvl 1 has NO wValues
		for i=1:levels-1
			wValues{i+1} = rand(connectedUnits(i+1),unitsPerlevel(i));
			oldCDeltaValues{i+1} = 0;
		endfor

		ETA = 0.01;
		EPSILON = 0.05;
		ALPHA = 0.9;
		hasLearnt = 0;
		MAX_EPOC = 20;
		epocs = 0;
		etaDecrement = ETA*0.025;
		etaIncrement = ETA*0.25;
		currK=0;
		K=5;##maximum number of steps before changing adaptative ETA
		errorMedio=0;
		errorMedioAnterior = 0;
		train_error = 0;
		learning_rate = 0;
		eta_adaptation = ETA;
		hit = 0;
		MIN_LEARN_RATE = 0.7;
		train_learning_rate = [];
		test_error = [];

		##START EPOC
		while(hasLearnt != 1 && epocs < MAX_EPOC)
			epocs ++;
			hit=0;
			hasLearnt = 1;
			epocStartTime = time();
			for i = 1:rows(testPatterns)
				currentPattern = testPatterns(i,:) 		;    

				currentExpectedOutput = ExpectedOutput(i,:);

				vValues{1} = currentPattern;

				hValues{1} = currentPattern;

				## FEED FORWARD
				for j=1:levels-1

					currentLvlWValues = wValues{j+1} 		;

					currentLvlVValues = vValues{j} 		;
					
					hj = (currentLvlWValues * (currentLvlVValues') )' 		;

					hValues{j+1} = hj;
					if(j!=levels-1)
						vValues{j+1} = cat(2,-1,arrayfun(g, hj)) 	;	
					else 
						vValues{j+1} = arrayfun(g, hj)	;
					endif
						
				endfor  

				outputValues = vValues{levels};
				## END FEED FORWARD

				if( abs(outputValues - currentExpectedOutput) > EPSILON)
					hasLearnt = 0;
				else
					hit++;
				endif
				currentLearnRate = hit/rows(Input);
				if(currentLearnRate > MIN_LEARN_RATE) 
					hasLearnt = 1;
				endif
				
				deltaValues{levels} =g_derivate(hj) *(currentExpectedOutput - outputValues );

				## BACKPROPAGATION START
				for k = levels :-1: 2		

					displacementIndexes = linspace(1,HiddenUnitsPerLvl(k-1),HiddenUnitsPerLvl(k-1)).+1     ;	#hay que sacar el peso del -1, el peso del umbral, la primer columna, para volver
					
					currentLvlWValues = wValues{k};  
					
					currentLvlWValues = currentLvlWValues(:,displacementIndexes)     	;	# ahora empiezo a volver entonces es desde la raiz hacia abajo, hacer el dibujo del arbol dado vuelta

					h = hValues{k-1} 		;
					
					delta = deltaValues{k} 	;


					tempCurrentLvlDeltaValues=0;
					for i=1 :columns(currentLvlWValues)
						deltai = g_derivate(h(i))* (delta * currentLvlWValues(:,i))		;

						tempCurrentLvlDeltaValues(i) = deltai;
					endfor

					deltaValues{k-1} =   tempCurrentLvlDeltaValues ;

				endfor 
				##BACKPROPAGATION END

				##CORRECT Ws
				for i=2:levels
					currentLvlWValues = wValues{i}   		;
					currentLvlVValues = vValues{i-1}  	;
					currentLvlDeltaValues = deltaValues{i}		;

					calculationWithDelta = ETA * currentLvlDeltaValues' * currentLvlVValues ;
					wValues{i} =  currentLvlWValues + calculationWithDelta ; 
					if(MomentumEnabled ==1)
						wValues{i} = wValues{i} + oldCDeltaValues{i} * ALPHA ;
					endif

					oldCDeltaValues{i} = calculationWithDelta ;
				endfor
				##END CORRECT Ws
			endfor
			##END EPOC
			currentLearnRate = hit/rows(Input);
			if(currentLearnRate > MIN_LEARN_RATE) 
				hasLearnt = 1;
			endif
			errorMedioAnterior = errorMedio;
			errorMedio = .5*sum(power((outputValues - currentExpectedOutput),2));			
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
			
			eta_adaptation = [eta_adaptation ETA] ;
			train_error = [train_error errorMedio];
			train_learning_rate = [train_learning_rate currentLearnRate] ;
		endwhile
		##END TRAINING
		trainedNetwork = wValues;		
	endif
	##START TESTING


	for i = 1:rows(TrainInput)
		currentPattern = trainPatterns(i,:) 		;    

		currentExpectedOutput = TrainExpectedOutput(i,:);

		vValues{1} = currentPattern;

		hValues{1} = currentPattern;

		## FEED FORWARD
		for j=1:levels-1

			currentLvlWValues = wValues{j+1} 		;

			currentLvlVValues = vValues{j} 		;
			
			hj = (currentLvlWValues * (currentLvlVValues') )' 		;

			hValues{j+1} = hj;
			if(j!=levels-1)
				vValues{j+1} = cat(2,-1,arrayfun(g, hj)) 	;	
			else 
				vValues{j+1} = arrayfun(g, hj)	;
			endif
				
		endfor  

		outputValues = vValues{levels};
		## END FEED FORWARD

		errorMedioTest = .5*sum(power((outputValues - currentExpectedOutput),2));

		test_error = [test_error errorMedioTest];

		if(abs(outputValues - currentExpectedOutput) < EPSILON)
			learning_rate++;
		endif
	endfor
	##END TESTING
	learning_rate = learning_rate /rows(TrainExpectedOutput);
endfunction