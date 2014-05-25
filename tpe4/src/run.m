function run()
	addpath('crossOver');
	addpath('finalizeCriterions');
	addpath('replacementMethod');
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


	option = input("Which selection criterion? \n1 -Elite\n2 -Roulette \n3 -Universal \n4 -Boltzman \n5 -Tournament \
deterministic \n6 -Tournament probabilistic \n7 -Elite+Roulette \n8 -Elite+Universal\n");
	switch(option)
		case 1
			selectionMethod = @eliteSelection; %Replace for @function
		case 2
			selectionMethod = @rouletteSelection;
		case 3
			selectionMethod = @universalSelection;
		case 4
			selectionMethod = 4;
		case 5
			selectionMethod = 5;
		case 6
			selectionMethod = 6;
		case 7
			selectionMethod = 7;
		case 8
			selectionMethod = 8;
		otherwise
			disp('error, please try again')
	endswitch

	option = input("Which replacement method? \n1 -Method 1\n2 -Method 2 \n3 -Method 3\n");
	switch(option)
		case 1
			replacementMethod = @method1; %Replace for @function
		case 2
			replacementMethod = 2;
		case 3
			replacementMethod = 3;
		otherwise
			disp('error, please try again')
	endswitch

	progenitorsNumber = input("How many progenitor selected? (k, even number)\n");
	if(mod(progenitorsNumber,2) != 0)
		printf('ERROR: PROGENITORS NUMBER MUST BE AN EVEN NUMBER\n');
		exit();
	endif
	if(option != 1)
		option = input("Which replacement criterion? \n1 -Elite\n2 -Roulette \n3 -Universal \n4 -Boltzman \n5 -Tournament \
deterministic \n6 -Tournament probabilistic \n7 -Elite+Roulette \n8 -Elite+Universal\n");
		switch(option)
			case 1
				replacementCriterion = @eliteSelection; %Replace for @function
			case 2
				replacementCriterion = @rouletteSelection;
			case 3
				replacementCriterion = @universalSelection;
			case 4
				replacementCriterion = 4;
			case 5
				replacementCriterion = 5;
			case 6
				replacementCriterion = 6;
			case 7
				replacementCriterion = 7;
			case 7
				replacementCriterion = 8;
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
			finalizeCriterion = 2;
		case 3
			finalizeCriterion = @contentFinalize;
		case 3
			finalizeCriterion = 4;
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
	%%Call function with all this variables as parameters
	
	%crossoverMethod
	%mutationMethod
	%selectionMethod
	%replacementCriterion
	%replacementMethod
	%progenitorsNumber
	%finalizeCriterion
	%maxGenerations
	%populationSize
	%mutationProbability
	%crossoverProbability
	%backpropagationProbability

	[weights populationInArrays weightsStructure fitnessAll] = getTrainedPopulation();
	[evolvedNetwork mean_fitness_generations best_fitness_generations elapsed_generations] = genetic(weights, populationInArrays, weightsStructure,fitnessAll,crossoverMethod, crossoverProbability, mutationMethod, backpropagationProbability, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability,alleleMutationProbability, Input, ExpectedOutput, TestInput, TestExpectedOutput);
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