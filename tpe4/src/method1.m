function [mostEvolvedNetwork mean_fitness_generations best_fitness_generations elapsed_generations]  = method1(weights, populationInArrays, weightsStructure,fitnessAll,crossOver, crossoverProbability, mutationMethod, backpropagationProbability, selectionMethod, replacementCriterion, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability,alleleMutationProbability, Input, ExpectedOutput, TestInput, TestExpectedOutput)
	% Initialize the population with random values
	% Each individual is a matrix of weights (floats)
	%populationInArrays = cell(populationSize, 1);
	%for i = 1 : populationSize 
		%Weights matrix for individual i (trained)
	%	weights{i} =  trainNetwork(weightsGenerator([4 3], i), Input, ExpectedOutput);
		%Transform the matrix to an array
	%	populationInArrays{i} =  weightsArray(weights{i}); 
	%endfor
	%weightsStructure = weights{1};
	
	% Calculate the fitness for all the individuals in the population
	%[populationInArrays fitnessAll] = evaluateFitness(populationInArrays, weightsStructure, Input, ExpectedOutput, TestInput, TestExpectedOutput,0);

	%while (condicion de corte)
	%	Seleccionar individuos para reproduccion
	%	Recombinar individuos
	%	Mutar individuos
	%	evaluar fitness de los individuos obtenidos
	%	generar nueva poblacion

	generation = 1;
	populationInArraysFitness = [];
	prevPopulation = cell(populationSize,1);
	prevPopulationFitness = [];
	mean_fitness_generations = [];
	best_fitness_generations = [];
	while (finalizeCriterion(generation, maxGenerations, best_fitness_generations))
		printf('Generation %d>\n',generation);
		fflush(stdout);
		sons = 0;
		newIndividuals =  cell(progenitorsNumber, 1);
		newIndividualsFitness = [];

		%%%%%%%
		%%%%%%%
		progenitorsNumber = 2;
		%%%%%%%
		%%%%%%%
		while (sons < populationSize)
			newSons = cell(2,1);
			tic
			
			% Choose the individuals
			printf('\tSelecting... ');
			fflush(stdout);
				% Select 2 parents
			[selectedIndexes remainingIndexes] = selectionMethod(populationInArrays, fitnessAll, progenitorsNumber);
			individualsToReproduce = populationInArrays(selectedIndexes);
	    	individualsToReproduceFitness = selectedIndexes(1 : progenitorsNumber);
	    	%Don't take the individuals to reproduce from original population
	    	%populationInArrays = populationInArrays(remainingIndexes);
	    	%populationInArraysFitness = remainingIndexes(1:(populationSize-progenitorsNumber));
			
			% Shuffle the individuals to reproduce 
			% I think it is not necesary anymore
			
			% Apply crossover between individuals
			printf('Crossover... ');
			fflush(stdout);
			
			for i = 1 : 2 : progenitorsNumber
				if(rand() <= crossoverProbability)
					descendants = crossOver(individualsToReproduce{i},individualsToReproduce{i+1});
					newSons{i} = descendants{1};
					newSons{i+1} = descendants{2}; 
				else
					newSons{i} = individualsToReproduce{i};
					newSons{i+1} = individualsToReproduce{i+1};
				endif
			endfor
			
			% Apply any mutation to the new children
			printf('Mutating... ');
			fflush(stdout);
			for i = 1 : length(newSons)
				if(rand() < mutationProbability)
					newSons{i} = mutationMethod(newSons{i}, alleleMutationProbability);
				endif
			endfor
			
			% Train the new children
			printf('Evaluating fitness of new... ');
			fflush(stdout);
				% ONLY CALCULATE FOR THE NEW! THE OTHERS DIDN'T CHANGE!
			[newSons newSonsFitness] = evaluateFitness(newSons, weightsStructure, Input, ExpectedOutput, TestInput, TestExpectedOutput,backpropagationProbability,generation);
			
			% Obtain the new population (replacement)
			printf('Generating the new population...\n');
			fflush(stdout);
			
			sons = sons+1;
			newIndividuals{sons} = newSons{1};
			sons = sons+1;
			newIndividuals{sons} = newSons{2};
			newIndividualsFitness = [newIndividualsFitness newSonsFitness];
		endwhile
		
		populationInArrays = {newIndividuals{:} populationInArrays{:}}';
		populationInArraysFitness = [newIndividualsFitness populationInArraysFitness];
		
		generation++;
		toc
		[maxValue garbage] = max(populationInArraysFitness);
		best_fitness = maxValue;
		mean_fitness = sum(populationInArraysFitness)/length(populationInArraysFitness);
		mean_fitness_generations = [mean_fitness_generations mean_fitness];
		best_fitness_generations = [best_fitness_generations best_fitness];
	endwhile
	elapsed_generations = generation-1;
	[garbage index_] = max(populationInArraysFitness);
	mostEvolvedNetwork = weightsFromArray(populationInArrays{index_}, weightsStructure);
endfunction


% Fitness function. Receives the populationa as a list of list of matrixes 
%returns an array with fitnessValues
%the population with the modificationes to the ones that had backpropagation
function [population fitnessValues] = evaluateFitness(population, weightsModel, Input, ExpectedOutput, TestInput, TestExpectedOutput,backpropagationProbability_,generationNumber) 
	individualsNumber = (size(population))(1);
	for i = 1 : individualsNumber
		individual = population{i};
		if(rand()<backpropagationProbability_*log(generationNumber/2))
			population{i} = weightsArray(trainNetwork(weightsFromArray(individual, weightsModel) , Input, ExpectedOutput));
		endif
		% One option is to add the two errors
		% e1 = meanSquareError(Input, ExpectedOutput, population{i}, weightsModel{i});
		% e2 = meanSquareError(TestInput, TestExpectedOutput, population{i}, weightsModel{i});
		% Now calculate the fitness for an individual
		% out(i) =  1 / (e1 + e2); 
		% The other option is to pass all the input together and calculate that error
		e1 = meanSquareError([Input; TestInput], [ExpectedOutput; TestExpectedOutput], individual, weightsModel);
		% Now calculate the fitness for an individual
		if(e1 == 0)
			fitnessValues(i) = 0;
		else
			fitnessValues(i) =  1 / e1; 
		endif	
	endfor
endfunction

% Returns the mean square error for the weights matrix m
function learning_rate = meanSquareError(Input, ExpectedOutput, Individual, weightsModel)
	[test_error, learning_rate, mean_error] = testPerceptron(Input, ExpectedOutput, weightsFromArray(Individual, weightsModel));
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

function trainedNetwork = trainNetwork(Network, Input, ExpectedOutput)
	max_epocs = 30;
	trainedNetwork = trainPerceptron(Input, ExpectedOutput, Network, max_epocs);
endfunction