%
%
%@return
%trainedNetwork the trained network
%
%
function trainedNetwork = trainPerceptron(Input, ExpectedOutput , Network,max_epocs)
	HiddenUnitsPerLvl = [4 3];
	startTime = time();
	wValues = Network;
	ETA = 0.1;
	COTA_ETA_ADAPTATIVO = 0.5;	
	EPSILON = 0.001;
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
	hit = 0;
	MIN_LEARN_RATE = 0.7;
	effectiveEpocs = 0;

	%%START EPOC
	while(hasLearnt != 1 && epocs < max_epocs)
		epocs ++;
		hasLearnt = 0;
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
					vValues{j+1} = [-1 tanh(0.5*hj)];	
				else 
					vValues{j+1} = tanh(0.5*hj);
				endif
					
			endfor  

			outputValues = vValues{levels};
			%% END FEED FORWARD

			%% BACKPROPAGATION START
			deltaValues{levels} = (0.5*(1-tanh(0.5*hj).^2)) *(currentExpectedOutput - outputValues );			
			for k = levels :-1: 2		

				displacementIndexes = linspace(1,HiddenUnitsPerLvl(k-1),HiddenUnitsPerLvl(k-1)).+1     ;	#hay que sacar el peso del -1, el peso del umbral, la primer columna, para volver
				
				currentLvlWValues = wValues{k};  
				
				currentLvlWValues = currentLvlWValues(:,displacementIndexes)     	;	# ahora empiezo a volver entonces es desde la raiz hacia abajo, hacer el dibujo del arbol dado vuelta

				h = hValues{k-1} 		;
				
				delta = deltaValues{k} 	;


				tempCurrentLvlDeltaValues=0;
				for i=1 :columns(currentLvlWValues)
					deltai = 0.5*(1-tanh(0.5*h(i)).^2)* (delta * currentLvlWValues(:,i))		;

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
				wValues{i} = wValues{i} + oldCDeltaValues{i} * ALPHA ;%momentum

				oldCDeltaValues{i} = calculationWithDelta ;
			endfor
			%%END CORRECT Ws
		endfor
		%%END EPOC
		elapsedTime = time() - startTime;
		if(epocs == 1 || epocs == 50 || epocs == 100)
			printf('\nEpoca: %d - tTotal %f\n',epocs,elapsedTime);
			fflush(stdout);
		endif
	endwhile
	%%END TRAINING
	trainedNetwork = wValues;	
endfunction