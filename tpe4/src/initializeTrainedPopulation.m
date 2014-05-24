function initializeTrainedPopulation(populationSize)
	populationInArrays = cell(populationSize, 1);
	[data testData] = data_import('../samples8.txt' , 0.6,1);
	Input = data(:,[1 2]);
	ExpectedOutput = data(:,3);
	TestInput = testData(:,[1 2]);
	TestExpectedOutput = testData(:,3);
	max_epocs = 100;
	EtaAdaptativeEnabled = 0;
	MomentumEnabled = 1;
	HiddenUnitsPerLvl = [4 3];
	g=@hiperbolic_tangent;
	g_derivate = @hiperbolic_tangent_derivative;
	for i = 1 : populationSize 
		Network = weightsGenerator(HiddenUnitsPerLvl, i);
		[MAX_EPOC, train_error, eta_adaptation, train_learning_rate, epocs, trainedNetwork] = trainPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, MomentumEnabled, EtaAdaptativeEnabled, Network, max_epocs);
		weights{i} = trainedNetwork;
		%Transform the matrix to an array
		populationInArrays{i} =  weightsArray(weights{i}); 
	endfor
	weightsStructure = weights{1};
	[populationInArrays fitnessAll] = evaluateFitness(populationInArrays, weightsStructure, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput,0);
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
function [population fitnessValues] = evaluateFitness(population, weightsModel, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput,backpropagationProbability_) 
	individualsNumber = (size(population))(1);
	for i = 1 : individualsNumber
		individual = population{i};
		if(rand()<backpropagationProbability_)
			population{i} = weightsArray(trainNetwork(weightsFromArray(individual, weightsModel) , Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate));
		endif
		% One option is to add the two errors
		% e1 = meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i});
		% e2 = meanSquareError(TestInput, TestExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i});
		% Now calculate the fitness for an individual
		% out(i) =  1 / (e1 + e2); 
		% The other option is to pass all the input together and calculate that error
		e1 = meanSquareError([Input; TestInput], [ExpectedOutput; TestExpectedOutput], HiddenUnitsPerLvl, g, g_derivate, individual, weightsModel);
		% Now calculate the fitness for an individual
		fitnessValues(i) =  1 / e1; 
	endfor
endfunction

% Returns the mean square error for the weights matrix m
function mean_error = meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, Individual, weightsModel)
	[test_error, learning_rate, mean_error] = testPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, weightsFromArray(Individual, weightsModel));
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