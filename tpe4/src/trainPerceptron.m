%
%
%@return
%MAX_EPOC maximum number of epocs for training
%train_error (array) mean cuadratic error per epoc (with train data)
%eta adaptacion (array) value of ETA per epoc
%train_learning_rate percentage of "hits" per epoc (with train data)
%epocs actual number of elapsed epocs
%trainedNetwork the trained network
%
%
function [MAX_EPOC, train_error, eta_adaptation,train_learning_rate, epocs, trainedNetwork] = trainPerceptron(Input, ExpectedOutput ,HiddenUnitsPerLvl , g ,g_derivate,MomentumEnabled, EtaAdaptativeEnabled,Network,max_epocs, probability)
	startTime = time();
	wValues = Network;
	ETA = 0.1;
	COTA_ETA_ADAPTATIVO = 0.5;	
	EPSILON = 0.001;
	train_error = [];
	train_learning_rate = [];
	eta_adaptation = ETA;	
	MAX_EPOC = max_epocs;
	HiddenUnitsPerLvl_ = HiddenUnitsPerLvl;

	testPatterns = horzcat(linspace(-1,-1,rows(Input))' , Input); #add threshold			 	
 	inputNodes = columns(Input)		;
	outputNodes = columns(ExpectedOutput)		;	 	
	unitsPerlevel =[inputNodes+1 HiddenUnitsPerLvl.+1 outputNodes]		;%1
	connectedUnits = [0 HiddenUnitsPerLvl 1]							;%2
	HiddenUnitsPerLvl = [0 HiddenUnitsPerLvl 0]							;%3
	levels = columns(unitsPerlevel)										;%4
	if(rows(wValues)==0)			
		#INITIALIZE WEIGHTS
		wValues = cell(levels,1);	%%wValues: connections between 'i' layer and the i-1 one, lvl 1 has NO wValues		
		for i=1:levels-1
			wValues{i+1} = rand(connectedUnits(i+1),unitsPerlevel(i));
		endfor
	endif 		
	vValues = cell(levels,1);
	hValues = cell(levels,1);
	deltaValues = cell(levels,1);
	oldCDeltaValues = cell(levels,1);
	for i=1:levels-1
		oldCDeltaValues{i+1} = 0;
	endfor
			
			
	ALPHA = 0.9;
	hasLearnt = 0;
	epocs = 0;
	etaDecrement = ETA*0.025;
	etaIncrement = ETA*0.25;
	currK=0;
	K=5;%%maximum number of steps before changing adaptative ETA
	mean_error = 0;
	last_mean_error = 0;		
	hit = 0;
	MIN_LEARN_RATE = 0.7;
	effectiveEpocs = 0;

	%%START EPOC
	while(hasLearnt != 1 && epocs < MAX_EPOC)
		epocs ++;
		hasLearnt = 0;
		epocStartTime = time();	
		if(rand() > probability)
			continue ;
		endif
		for i = 1:rows(testPatterns)
			currentPattern = testPatterns(i,:) 		;    

			currentExpectedOutput = ExpectedOutput(i,:);

			vValues{1} = currentPattern;

			hValues{1} = currentPattern;

			%% FEED FORWARD
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
			%% END FEED FORWARD

			%% BACKPROPAGATION START
			deltaValues{levels} =g_derivate(hj) *(currentExpectedOutput - outputValues );			
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
			%%BACKPROPAGATION END

			%%CORRECT Ws
			for i=2:levels
				currentLvlWValues = wValues{i};
				currentLvlVValues = vValues{i-1};
				currentLvlDeltaValues = deltaValues{i};

				calculationWithDelta = ETA * currentLvlDeltaValues' * currentLvlVValues ;
				wValues{i} =  currentLvlWValues + calculationWithDelta ; 
				if(MomentumEnabled ==1)
					wValues{i} = wValues{i} + oldCDeltaValues{i} * ALPHA ;
				endif

				oldCDeltaValues{i} = calculationWithDelta ;
			endfor
			%%END CORRECT Ws
		endfor
		%%END EPOC

		%Adapt ETA
		if(EtaAdaptativeEnabled && ETA < COTA_ETA_ADAPTATIVO)
			deltaError = errorMedioPromedio - errorMedioPromedioAnterior;
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
		%END ADAPT ETA
		last_mean_error = mean_error;		
		[train_err, currentLearnRate,mean_error] = testPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl_, g ,g_derivate, wValues);
		elapsedTime = time() - startTime;
		elapsedEpocTime = time() - epocStartTime;
		printf('\nEpoca: %d - ErrorCuadraticoMedio: %.10f eta %.2f trainLrate %f \ntiempoTotal %f tiempoEpoca %f\n',epocs,mean_error,ETA,currentLearnRate,elapsedTime,elapsedEpocTime);
		fflush(stdout);
		eta_adaptation = [eta_adaptation ETA] ;
		train_error = [train_error mean_error];
		train_learning_rate = [train_learning_rate currentLearnRate] ; 
		if(currentLearnRate > MIN_LEARN_RATE) 
			hasLearnt = 1;
		endif
	endwhile
	%%END TRAINING
	trainedNetwork = wValues;	
endfunction