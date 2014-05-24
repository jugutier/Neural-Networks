%
%@return
%test_error (array) error between each input and expected output
%learning_rate (scalar) percentage of hits
%mean_error (scalar) mean cuadratic error
%
function [test_error, learning_rate,mean_error]  = testPerceptron( TrainInput,TrainExpectedOutput,HiddenUnitsPerLvl,g ,g_derivate,Network)
	inputNodes = columns(TrainInput)		;
	outputNodes = columns(TrainExpectedOutput)		;
	wValues = Network;
	trainPatterns = cat(2,-1*ones(rows(TrainInput),1),TrainInput)	;
	levels = columns(HiddenUnitsPerLvl)+2	;
	vValues = cell(levels,1);
	hValues = cell(levels,1);
	test_error = [];
	mean_error = 0;
	learning_rate = 0;%%hits over total training
	EPSILON = 0.001;	
	%%START TESTING
	for i = 1:rows(TrainInput)
		currentPattern = trainPatterns(i,:) 		;    

		currentExpectedOutput = TrainExpectedOutput(i,:);

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

		errorMedioTest = power((outputValues - currentExpectedOutput),2);

		test_error = [test_error errorMedioTest];

		if(errorMedioTest < EPSILON)
			learning_rate++;
		endif
	endfor
	%%END TESTING
	mean_error = sum(test_error) / (2* rows(TrainExpectedOutput));
	learning_rate = learning_rate /rows(TrainExpectedOutput);
endfunction