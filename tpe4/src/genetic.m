function out  = genetic(crossOver, crossoverProbability, mutationMethod, backpropagationProbability, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability, HiddenUnitsPerLvl, Input, ExpectedOutput, g, g_derivate, TestInput, TestExpectedOutput)

	% Add threshold
	testPatterns = horzcat(linspace(-1,-1,rows(Input))', Input); 			 	
	
	inputNodes = columns(Input);
	outputNodes = columns(ExpectedOutput);

	% Initialize the population with random values
	% Each individual is a matrix of weights (floats)
	population = cell(populationSize, 1);
	for i = 1 : populationSize 
		%Weights matrix for individual i (trained)
		weights{i} = trainNetwork(weightsGenerator(HiddenUnitsPerLvl, i), Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, backpropagationProbability);
		%Transform the matrix to an array
		populationInArrays{i} =  weightsArray(weights{i}); 
	endfor


	% Re transform the array to matrix to verify its ok
	%for i = 1 : populationSize 
	%	weights2{i} = weightsFromArray(populationInArrays{i}, weights{i});
	%endfor
	%weights
	%population
	%weights2
	
	% Calculate the fitness for all the individuals in the population
	fitnessAll = evaluateFitness(populationInArrays, weights, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput);

	%while (condicion de corte)
	%	Seleccionar individuos para reproduccion
	%	Recombinar individuos
	%	Mutar individuos
	%	evaluar fitness de los individuos obtenidos
	%	generar nueva poblacion

	% For testing the function because finalizeCriterion has not implemented yet
	individualsToReproduce = selectionMethod(populationInArrays, fitnessAll);
	out = classicCrossover(individualsToReproduce{1}, individualsToReproduce{2});
	% End testing zone

	generation = 1;
	while (finalizeCriterion(generation, maxGenerations))
		printf('Generation %d>',generation);
		fflush(stdout);
		% Choose the individuals
		printf('Selecting... ');
		fflush(stdout);
		% Select k population is N-k now
		[individualsToReproduce populationInArrays] = selectionMethod(populationInArrays, fitnessAll, progenitorsNumber);
		% Shuffle the individuals to reproduce 
        n = rand(length(individualsToReproduce),1); 
        [garbage index] = sort(n); 
        individualsToReproduce = individualsToReproduce(index); 
		% Apply a genetic operator between individuals
		printf('Apply operator... ');
		fflush(stdout);
		newIndividuals = [];
		for i = 1 : 2 : progenitorsNumber
			if(rand() <= crossoverProbability)
				newIndividuals = [newIndividuals crossOver(individualsToReproduce{i},individualsToReproduce{i+1})];
			else
				newIndividuals = [newIndividuals individualsToReproduce{i} individualsToReproduce{i+1}];
			endif
		endfor
		% Apply any mutation to the new children
		printf('Mutating the individuals... ');
		fflush(stdout);
		newIndividuals = mutationMethod(newIndividuals, mutationProbability);
		% Train the new children
		printf('Evaluating fitness of new individuals... ');
		fflush(stdout);
		evaluateFitness(newIndividuals, weights, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput); % ONLY CALCULATE FOR THE NEW! THE OTHERS DIDN'T CHANGE!
		% Obtain the new population (replacement)
		printf('Generating the new population... \n');
		fflush(stdout);
		populationInArrays = replacementMethod(newIndividuals,individualsToReproduce, populationInArrays);
		generation++;
	endwhile

	out = weightsFromArray(populationInArrays{1}, weights{1}); %TODO: Returns the first element just for now
endfunction


% Fitness function. Receives the population matrix and returns a new matrix with 
% the values of the fitness for each individual
function out = evaluateFitness(population, weightsModel, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput) 
	individuals = (size(population))(2);
	for i = 1 : individuals
		% One option is to add the two errors
		% e1 = meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i});
		% e2 = meanSquareError(TestInput, TestExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i});
		% Now calculate the fitness for an individual
		% out(i) =  1 / (e1 + e2); 
		% The other option is to pass all the input together and calculate that error
		e1 = meanSquareError([Input; TestInput], [ExpectedOutput; TestExpectedOutput], HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i});
		% Now calculate the fitness for an individual
		out(i) =  1 / e1; 
	endfor
endfunction

% Returns the mean square error for the weights matrix m
function mean_error = meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, Individual, weightsModel)
	[test_error, learning_rate, mean_error] = testPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, weightsFromArray(Individual, weightsModel));
endfunction

function a = weightsArray(weights)
	a = [];
	for i = 1 : size(weights)(1)
		a = [a weights{i}(:)'];
	endfor
endfunction

function w = weightsFromArray(weightsArray, weightsModel)
	j = 1;
	w = cell(size(weightsModel)(1),1);
	for i = 1 : size(weightsModel)(1)
		values = weightsArray(j : (j + (size(weightsModel{i})(1) * size(weightsModel{i})(2)) - 1) );
		w{i} = reshape(values, size(weightsModel{i})(1), size(weightsModel{i})(2));
		
		j = j + size(weightsModel{i})(1) * size(weightsModel{i})(2);
	endfor
endfunction

function trainedNetwork = trainNetwork(Network, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, backpropagationProbability)
	max_epocs = 100;
	EtaAdaptativeEnabled = 0;
	MomentumEnabled = 0;
	[MAX_EPOC, train_error, eta_adaptation, train_learning_rate, epocs, trainedNetwork] = trainPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, MomentumEnabled, EtaAdaptativeEnabled, Network, max_epocs, backpropagationProbability);
endfunction
