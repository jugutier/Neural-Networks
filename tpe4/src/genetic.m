function out  = genetic(crossOver, crossoverProbability, mutationMethod, backpropagationProbability, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability, HiddenUnitsPerLvl, Input, ExpectedOutput, g, g_derivate, TestInput, TestExpectedOutput)
	% Initialize the population with random values
	% Each individual is a list of weight matrixes (floats)
	population = cell(populationSize, 1);
	for i = 1 : populationSize 
		%Transform the individual to an array
		weights{i} = weightsGenerator(HiddenUnitsPerLvl, i);
		populationInArrays{i} =  weightsArray(weights{i}); 
	endfor

	%while (condicion de corte)
	%	Seleccionar individuos para reproduccion
	%	Recombinar individuos
	%	Mutar individuos
	%	evaluar fitness de los individuos obtenidos
	%	generar nueva poblacion

	fitnessAll = [];
	indexes = 1:populationSize;
	generation = 1;
	while (finalizeCriterion(generation, maxGenerations))
		printf('Generation %d>',generation);
		fflush(stdout);
		% Train the newborns
		printf('Training newborns & calculating fitness... ');
		fflush(stdout);
		tic
		newbornsCount = length(indexes);
		for i =1 : newbornsCount
			currentIndex = indexes(i);
			currentNewbornOldWeights = weights{currentIndex};
			currentNewborn = populationInArrays{currentIndex};
			currentNewbornNewWeights = weightsFromArray(currentNewborn, currentNewbornOldWeights);
			trainedNewborn = trainNetwork(currentNewbornNewWeights, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, backpropagationProbability);
			weights{currentIndex} = trainedNewborn;
			populationInArrays{currentIndex} =  weightsArray(trainedNewborn);
			% Calculate the fitness for the newborn
			fitnessNewborn = evaluateFitness(trainedNewborn, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput);
			fitnessAll(currentIndex) = fitnessNewborn;
		endfor
		toc
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
		newIndividualsFitenss = evaluateFitness(newIndividuals, weights, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput); % ONLY CALCULATE FOR THE NEW! THE OTHERS DIDN'T CHANGE!
		% Obtain the new population (replacement)
		printf('Generating the new population... \n');
		fflush(stdout);
		[populationInArrays  populationInArraysFitness indexes]= replacementMethod(newIndividuals,newIndividualsFitenss,individualsToReproduce,individualsToReproduceFitness, populationInArrays , populationInArraysFitness);
		generation++;
	endwhile

	out = weights{1};%weightsFromArray(populationInArrays{1}, weights{1}); %TODO: Returns the first element just for now
endfunction


% Fitness function. Receives the individual (as a network) and returns
% a scalar value with its fitness
function out = evaluateFitness(IndividualWeights, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, TestInput, TestExpectedOutput) 
		% One option is to add the two errors
		% e1 = meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i});
		% e2 = meanSquareError(TestInput, TestExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i});
		% Now calculate the fitness for an individual
		% out(i) =  1 / (e1 + e2); 
		% The other option is to pass all the input together and calculate that error
		e1 = meanSquareError([Input; TestInput], [ExpectedOutput; TestExpectedOutput], HiddenUnitsPerLvl, g, g_derivate,IndividualWeights);
		% Now calculate the fitness for an individual
		out =  1 / e1; 
endfunction

% Returns the mean square error for the weights matrix m
function mean_error = meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, IndividualWeights)
	[test_error, learning_rate, mean_error] = testPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, IndividualWeights);
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
