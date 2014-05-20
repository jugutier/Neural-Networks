function out  = genetic(geneticOperator, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability, HiddenUnitsPerLvl, Input, ExpectedOutput, g, g_derivate)

	% Add threshold
	testPatterns = horzcat(linspace(-1,-1,rows(Input))', Input); 			 	
	
	inputNodes = columns(Input);
	outputNodes = columns(ExpectedOutput);

	% Initialize the population with random values
	% Each individual is a matrix of weights (floats)
	population = cell(populationSize, 1);
	for i = 1 : populationSize 
		weights{i} = weightsGenerator(HiddenUnitsPerLvl, i); %Weights matrix for individual i
		populationInArrays{i} =  weightsArray(weights{i}); %Transform the matrix to an array
	endfor

	% Re transform the array to matrix to verify its ok
	%for i = 1 : populationSize 
	%	weights2{i} = weightsFromArray(populationInArrays{i}, weights{i});
	%endfor
	%weights
	%population
	%weights2
	
	% Calculate the fitness for all the individuals in the population
	fitnessAll = evaluateFitness(populationInArrays, weights, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate);

	%while (condicion de corte)
	%	Seleccionar individuos para reproduccion
	%	Recombinar individuos
	%	Mutar individuos
	%	evaluar fitness de los individuos obtenidos
	%	generar nueva poblacion

	% For testing the function because finalizeCriterion has not implemented yet
	individualsToReproduce = selectionMethod(populationInArrays, fitnessAll)
	out = classicCrossover(individualsToReproduce{1}, individualsToReproduce{2})
	% End testing zone

	generation = 1;
	while (finalizeCriterion(generation, maxGenerations))
		% Choose the individuals
		individualsToReproduce = selectionMethod(populationInArrays, fitnessAll);
		% Apply a genetic operator between individuals
		newIndividuals = geneticOperator(individualsToReproduce{1},individualsToReproduce{2});
		% Apply any mutation to the new children
		%newIndividuals = mutateIndividuals(newIndividuals, mutationProbability);
		% Train the new children
		evaluateFitness(newIndividuals, weights, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate); % ONLY CALCULATE FOR THE NEW! THE OTHERS DIDN'T CHANGE!
		% Obtain the new population
		%populationInArrays = generatePopulation(newIndividuals, evaluateFitness, populationInArrays);
		generation++;
	endwhile

	out = weightsFromArray(populationInArrays{1}, weights{1}); %TODO: Returns the first element just for now
endfunction


% Fitness function. Receives the population matrix and returns a new matrix with 
% the values of the fitness for each individual
function out = evaluateFitness(population, weightsModel, Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate) 
	individuals = (size(population))(2);
	for i = 1 : individuals
		out(i) =  1 / meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, population{i}, weightsModel{i}); % How do we calculate the fitness for an individual
	endfor
endfunction

% Returns the mean square error for the weights matrix m
function e = meanSquareError(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, Individual, weightsModel)
	[test_error, learning_rate, error_dif] = testPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, weightsFromArray(Individual, weightsModel));
	e = learning_rate;
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