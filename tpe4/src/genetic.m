function out  = genetic(crossOver, crossoverProbability, mutationMethod, backpropagationProbability, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability,alleleMutationProbability, HiddenUnitsPerLvl, Input, ExpectedOutput, g, g_derivate, TestInput, TestExpectedOutput)

	% Add threshold
	testPatterns = horzcat(linspace(-1,-1,rows(Input))', Input); 			 	
	
	inputNodes = columns(Input);
	outputNodes = columns(ExpectedOutput);

	% Initialize the population with random values
	% Each individual is a matrix of weights (floats)
	population = cell(populationSize, 1);
	for i = 1 : populationSize 
		%Weights matrix for individual i (trained)
		weights{i} =  trainNetwork(weightsGenerator(HiddenUnitsPerLvl, i), Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate);
		%Transform the matrix to an array
		populationInArrays{i} =  weightsArray(weights{i}); 
	endfor
	weightsStructure = weights{1};
	

	% Calculate the fitness for all the individuals in the population
	[populationInArrays fitnessAll] = evaluateFitness(populationInArrays, weightsStructure, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput,0);

	%while (condicion de corte)
	%	Seleccionar individuos para reproduccion
	%	Recombinar individuos
	%	Mutar individuos
	%	evaluar fitness de los individuos obtenidos
	%	generar nueva poblacion


	generation = 1;
	while (finalizeCriterion(generation, maxGenerations))
		printf('Generation %d>',generation);
		fflush(stdout);
		% Choose the individuals
		printf('Selecting... ');
		fflush(stdout);
		% Select k,            population is N-k now
		[individualsToReproduce individualsToReproduceFitness populationInArrays populationInArraysFitness] = selectionMethod(populationInArrays, fitnessAll, progenitorsNumber);
		% Shuffle the individuals to reproduce 
        n = rand(length(individualsToReproduce),1); 
        [garbage index_] = sort(n); 
        individualsToReproduce = individualsToReproduce(index_); 
		% Apply crossover between individuals
		printf('Apply operator... ');
		fflush(stdout);
		tic
		newIndividuals =  cell(progenitorsNumber/2, 1);
		for i = 1 : 2 : progenitorsNumber
			if(rand() <= crossoverProbability)
				out = crossOver(individualsToReproduce{i},individualsToReproduce{i+1});
				newIndividuals{i} = out{1};
				newIndividuals{i+1} = out{2}; 
			else
				newIndividuals{i} = individualsToReproduce{i};
				newIndividuals{i+1} = individualsToReproduce{i+1};
			endif
		endfor
		toc
		% Apply any mutation to the new children
		printf('Mutating the individuals... ');
		fflush(stdout);
		tic
		for i = 1 : length(newIndividuals)-1
			if(rand() < mutationProbability)
				newIndividuals = mutationMethod(newIndividuals{i}, alleleMutationProbability);
			endif
		endfor
		toc
		% Train the new children
		printf('Evaluating fitness of new individuals... ');
		tic
		fflush(stdout);
		[newIndividuals newIndividualsFitenss] = evaluateFitness(newIndividuals, weightsStructure, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput,backpropagationProbability); % ONLY CALCULATE FOR THE NEW! THE OTHERS DIDN'T CHANGE!
		toc
		% Obtain the new population (replacement)
		printf('Generating the new population... \n');
		fflush(stdout);
		tic
		[populationInArrays  populationInArraysFitness]= replacementMethod(newIndividuals,newIndividualsFitenss,individualsToReproduce,individualsToReproduceFitness, populationInArrays , populationInArraysFitness);
		generation++;
		toc
	endwhile
	[garbage index] = max(populationInArraysFitness);
	out = weightsFromArray(populationInArrays{index}, weightsStructure);
endfunction


% Fitness function. Receives the populationa as a list of list of matrixes 
%returns an array with fitnessValues
%the population with the modificationes to the ones that had backpropagation
function [population fitnessValues] = evaluateFitness(population, weightsModel, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput,backpropagationProbability_) 
	individuals = (size(population))(2);
	for i = 1 : individuals
		individual = population{i};
		if(rand()<backpropagationProbability_)
			population{i} = weightsArray(trainNetwork(weightsFromArray(individual, weightsModel), Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate));
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

function a = weightsArray(weights)
	a = [];
	for i = 1 : size(weights)(1)
		a = [a weights{i}(:)'];
	endfor
endfunction

function w = weightsFromArray(weightsArray, weightsModel)
	j = 1;
	floors = size(weightsModel)(1);
	if(floors!=4)
		printf('WARNING: floors is not 4, did you change the structure?');
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

function trainedNetwork = trainNetwork(Network, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate)
	max_epocs = 100;
	EtaAdaptativeEnabled = 0;
	MomentumEnabled = 0;
	[MAX_EPOC, train_error, eta_adaptation, train_learning_rate, epocs, trainedNetwork] = trainPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, MomentumEnabled, EtaAdaptativeEnabled, Network, max_epocs);
endfunction