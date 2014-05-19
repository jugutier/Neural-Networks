function out  = genetic(geneticOperator, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability,HiddenUnitsPerLvl,Input, ExpectedOutput,g ,g_derivate)

	testPatterns = horzcat(linspace(-1,-1,rows(Input))' , Input); %add threshold			 	
	inputNodes = columns(Input)		;
	outputNodes = columns(ExpectedOutput)		;

	% Initialize the population with random values
	% Each individual is a matrix of weights (floats)
	population = cell(populationSize, 1);
	for i = 1 : populationSize 
		weights{i} = weightsArray(weightsGenerator(HiddenUnitsPerLvl,i));
		population{i} = weights{i}; %Matriz de pesos para el individuo i
	endfor


	%Calculate the fitness for all the individuals in the population
	fitnessAll = evaluateFitness(population,Input,ExpectedOutput,HiddenUnitsPerLvl,g,g_derivate);

	%while (condicion de corte)
	%	Seleccionar individuos para reproduccion
	%	Recombinar individuos
	%	Mutar individuos
	%	evaluar fitness de los individuos obtenidos
	%	generar nueva poblacion

	individualsToReproduce = selectionMethod(population, fitnessAll)

	while (!finalizeCriterion)
		individualsToReproduce = chooseIndividuals(population, fitnessAll);
		newIndividuals = geneticOperator(individualsToReproduce);
		newIndividuals = mutateIndividuals(newIndividuals);
		evaluateFitness(newIndividuals);
		population = generatePopulation(newIndividuals, evaluateFitness, population);
	endwhile
	out = population
endfunction


% Fitness function. Receives the population matrix and returns a new matrix with 
% the values of the fitness for each individual
function out = evaluateFitness(population, Input,ExpectedOutput,HiddenUnitsPerLvl,g,g_derivate) 
	individuals = (size(population))(1);
	for i = 1 : individuals
		out(i) =  1 / meanSquareError(Input,ExpectedOutput,HiddenUnitsPerLvl,g,g_derivate,population{i}); % How do we calculate the fitness for an individual
	endfor
endfunction

% Returns the mean square error for the weights matrix m
function e = meanSquareError(Input,ExpectedOutput,HiddenUnitsPerLvl,g,g_derivate,Individual)
	[test_error, learning_rate, error_dif] = testPerceptron( Input,ExpectedOutput,HiddenUnitsPerLvl,g,g_derivate,Individual);
	e = learning_rate ;
endfunction

function a = weightsArray(weights)
	a = [];
	for i = 1 : size(weights)
		a = [a toArray(weights(i))];
	endfor
endfunction

function w = weightsFromArray(weightsArray, weightsModel)
	for i = 1 : size(weightsModel)

		%w{i} = 
	endfor
endfunction