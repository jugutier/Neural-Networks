function run()
	addpath('crossOver');
	addpath('finalizeCriterions');
	addpath('selectionMethods');
	addpath('mutation');
	
	
	

	disp("Welcome to the genetic algorithm wizard\n")
	option = input("Which crossover method? \n1 -Classic crossover(one point)\n2 -Two point crossover \n3 \
-Uniform crossover \n4 -Anular crossover \n");
	switch(option)
		case 1
			crossoverMethod = @classicCrossover; %Replace for @function
		case 2
			crossoverMethod = @twoPointCrossover;
		case 3
			crossoverMethod = @uniformCrossover;
		case 4
			crossoverMethod = @anularCrossover;
		otherwise
			disp('error, please try again')
	endswitch


	mutationOption = input("Which mutation method? \n1 -Classic mutation \n2 -Not uniform mutation\n");
	switch(mutationOption)
		case 1
			mutationMethod = @classicMutation;
		case 2
			mutationMethod = @nonUniformMutation;
		otherwise
			disp('error, please try again')
	endswitch


	option = input("Which selection criterion? \n1 -Elite\n2 -Roulette \n3 -Universal \n4 -Boltzmann \n5 -Tournament \
deterministic \n6 -Tournament probabilistic \n7 -Elite+Roulette \n8 -Elite+Universal\n");
	switch(option)
		case 1
			selectionMethod = @eliteSelection; %Replace for @function
		case 2
			selectionMethod = @rouletteSelection;
		case 3
			selectionMethod = @universalSelection;
		case 4
			selectionMethod = @boltzmannSelection;
		case 5
			selectionMethod = @tournamentDetermSelection;
		case 6
			selectionMethod = @tournamentProbSelection;
		case 7
			selectionMethod = @mixedRouletteSelection;
		case 8
			selectionMethod = @mixedUniversalSelection;
		otherwise
			disp('error, please try again')
	endswitch

	rmethodOption = input("Which replacement method? \n1 -Method 1\n2 -Method 2 \n3 -Method 3\n");
	switch(rmethodOption)
		case 1
			replacementMethod = @method1;%no progenitors number
		case 2
			replacementMethod = @method2;%no replacement method
		case 3
			replacementMethod = @method3;
		otherwise
			disp('error, please try again')
	endswitch
	if(rmethodOption !=1)
		progenitorsNumber = input("How many progenitor selected? (k, even number)\n");
		if(mod(progenitorsNumber,2) != 0)
			printf('ERROR: PROGENITORS NUMBER MUST BE AN EVEN NUMBER\n');
			exit();
		endif
	else
		progenitorsNumber = 2;%pairs of 2 until N individuals
	endif
	
	if(rmethodOption != 2)
		option = input("Which replacement criterion? \n1 -Elite\n2 -Roulette \n3 -Universal \n4 -Boltzmann \n5 -Tournament \
deterministic \n6 -Tournament probabilistic \n7 -Elite+Roulette \n8 -Elite+Universal\n");
		switch(option)
			case 1
				replacementCriterion = @eliteSelection; %Replace for @function
			case 2
				replacementCriterion = @rouletteSelection;
			case 3
				replacementCriterion = @universalSelection;
			case 4
				replacementCriterion = @boltzmannSelection;
			case 5
				replacementCriterion = @tournamentDetermSelection;
			case 6
				replacementCriterion = @tournamentProbSelection;
			case 7
				replacementCriterion = @mixedRouletteSelection;
			case 8
				replacementCriterion = @mixedUniversalSelection;
			otherwise
				disp('error, please try again')
		endswitch
	else
		replacementCriterion = 1;
	endif


	option = input("When should we end the algorithm? \n1 -Max number of generations \n2 -Structure \n3 \
-Content \n4 -Around the optimun\n");
	if(option == 1)
		maxGenerations = input("What should be the maximum number of generations?\n");
	else
		maxGenerations = inf
	endif
	switch(option)
		case 1
			finalizeCriterion = @maxGenerations; %Replace for @function
		case 2
			finalizeCriterion = @structureFinalize;
		case 3
			finalizeCriterion = @contentFinalize;
		case 4
			finalizeCriterion = @arroundOptimum;
		otherwise
			disp('error, please try again')
	endswitch

	populationSize = 50
	%populationSize = input("What should be the population size? (greater than progenitors number)\n");
	if(populationSize <= progenitorsNumber)
		printf('ERROR: POPULATION MUST BE GREATER THAN PROGENITORS NUMBER\n');
		exit();
	endif
	mutationProbability = input("What should be the mutation probability? (0.0 <= p <= 1.0)\n");
	if(mutationOption == 2)
		alleleMutationProbability = input("What should be the allele mutation probability? (0.0 <= p <= 1.0)\n");
	else
		alleleMutationProbability = 0;
	endif
	crossoverProbability = input("What should be the crossover probability? (0.0 <= p <= 1.0)\n");
	backpropagationProbability = input("What should be the backpropagation probability? (0.0 <= p <= 1.0)\n");

	functiondataFilename = '../samples8.txt';%TODO: add to wizard
	[data testData] = data_import(functiondataFilename , 0.6,1);
	Input = data(:,[1 2]);
	ExpectedOutput = data(:,3);
	TestInput = testData(:,[1 2]);
	TestExpectedOutput = testData(:,3);

	[weights populationInArrays weightsStructure fitnessAll] = getTrainedPopulation();
	[evolvedNetwork mean_fitness_generations best_fitness_generations elapsed_generations] = replacementMethod(weights, populationInArrays, weightsStructure,fitnessAll,crossoverMethod, crossoverProbability, mutationMethod, backpropagationProbability, selectionMethod, replacementCriterion, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability,alleleMutationProbability, Input, ExpectedOutput, TestInput, TestExpectedOutput);
	
	printf('meanFitness at last generation : %.4f best fitness at last generation : %.4f\n',mean_fitness_generations(elapsed_generations),best_fitness_generations(elapsed_generations));
	fflush(stdout);
	printf('Saving the most evolved network\n');
	fflush(stdout);
	save('mostEvolved.nnet','evolvedNetwork');

	printf('Testing the most evolved network\n');
	fflush(stdout);
	
	[test_error learning_rate mean_error]  = testPerceptron(TestInput, TestExpectedOutput, evolvedNetwork);
	
	printf('FINISHED: the most evolved network predicts %.4f%% with mean cuadratic error of %.4f\n',learning_rate*100 , mean_error);
	fflush(stdout);	

	if(yes_or_no('do you want plots?'))
		figure(1);
		resultsGraph(mean_fitness_generations, best_fitness_generations, elapsed_generations);
		figure(2);
		graphErrorHist(test_error);
	endif

endfunction