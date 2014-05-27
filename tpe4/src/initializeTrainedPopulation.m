function initializeTrainedPopulation(populationSize)
	populationInArrays = cell(populationSize, 1);
	[data testData] = data_import('../samples8.txt' , 0.6,1);
	Input = data(:,[1 2]);
	ExpectedOutput = data(:,3);
	TestInput = testData(:,[1 2]);
	TestExpectedOutput = testData(:,3);
	max_epocs = 100;
	for i = 1 : populationSize 
		Network = weightsGenerator(HiddenUnitsPerLvl, i);
		[MAX_EPOC, train_error, eta_adaptation, train_learning_rate, epocs, trainedNetwork] = trainPerceptron(Input, ExpectedOutput, Network, max_epocs);
		weights{i} = trainedNetwork;
		%Transform the matrix to an array
		populationInArrays{i} =  weightsArray(weights{i}); 
	endfor
	weightsStructure = weights{1};
	[populationInArrays fitnessAll] = evaluateFitness(populationInArrays, weightsStructure, Input, ExpectedOutput,  TestInput, TestExpectedOutput);
	save('trained.pop','weights' ,'populationInArrays','weightsStructure','fitnessAll' );
endfunction

function a = weightsArray(weights)
	a = [];
	for i = 1 : size(weights)(1)
		a = [a weights{i}(:)'];
	endfor
endfunction

% Fitness function. Receives the populationa as a list of list of matrixes 
%returns an array with fitnessValues
%the population with the modificationes to the ones that had backpropagation
function [population fitnessValues] = evaluateFitness(population, weightsModel, Input, ExpectedOutput, TestInput, TestExpectedOutput) 
	individualsNumber = (size(population))(1);
	for i = 1 : individualsNumber
		fitnessValues(i) = meanSquareError([Input; TestInput], [ExpectedOutput; TestExpectedOutput],  population{i}, weightsModel);
	endfor
endfunction

% Returns the mean square error for the weights matrix m
function learning_rate = meanSquareError(Input, ExpectedOutput,  Individual, weightsModel)
	[test_error, learning_rate, mean_error] = testPerceptron(Input, ExpectedOutput, weightsFromArray(Individual, weightsModel));
endfunction

function w = weightsFromArray(weightsArray, weightsModel)
	j = 1;
	floors = size(weightsModel)(1);
	individualLenght = length(weightsArray);
	if(floors != 4)
		printf('WARNING: floors is not 4, did you change the structure?');
	endif
	if(individualLenght!=31)
		printf('WARNING: length not 31');
	endif
	w = cell(floors,1);
	for i = 1 : floors
		currentN = size(weightsModel{i})(1);
		currentM = size(weightsModel{i})(2);
		values = weightsArray(j : (j + (currentN * currentM ) - 1) );
		w{i} = reshape(values, currentN, currentM);
		j = j + currentN * currentM;
	endfor
endfunction