function run()
	%%hasLoaded = 0;
	%%network = '';
	addpath('selectionMethods')
	addpath('geneticOperators')
	addpath('finalizeCriterions')
	load eliteSelection.m;
	load classicCrossover.m;
	load maxGenerations.m;

	disp("Welcome to the genetic algorithm wizard\n")
	option = input("Which genetic operator? \n1 -Classic crossover(one point)\n2 -Two point crossover \n3 \
-Uniform crossover \n4 -Anular crossover \n5 -Classic mutation \n6 -Not uniform mutation \n7 -Backpropagation\n");
	switch(option)
		case 1
			geneticOperator = @classicCrossover; %Replace for @function
		case 2
			geneticOperator = 2;
		case 3
			geneticOperator = 3;
		case 4
			geneticOperator = 4;
		case 5
			geneticOperator = 5;
		case 6
			geneticOperator = 6;
		case 7
			geneticOperator = 7;
		otherwise
			disp("error, please try again")
	endswitch



	option = input("Which selection criterion? \n1 -Elite\n2 -Roulette \n3 \
-Boltzman \n4 -Tournament deterministic \n5 -Tournament probabilistic \n6 -Elite+Roulette \n7 -Elite+Universal\n");
	switch(option)
		case 1
			selectionMethod = @eliteSelection; %Replace for @function
		case 2
			selectionMethod = 2;
		case 3
			selectionMethod = 3;
		case 4
			selectionMethod = 4;
		case 5
			selectionMethod = 5;
		case 6
			selectionMethod = 6;
		case 7
			selectionMethod = 7;
		otherwise
			disp("error, please try again")
	endswitch


	option = input("Which replacement criterion? \n1 -Elite\n2 -Roulette \n3 \
-Boltzman \n4 -Tournament deterministic \n5 -Tournament probabilistic \n6 -Elite+Roulette \n7 -Elite+Universal\n");
	switch(option)
		case 1
			replacementCriterion = @eliteSelection; %Replace for @function
		case 2
			replacementCriterion = 2;
		case 3
			replacementCriterion = 3;
		case 4
			replacementCriterion = 4;
		case 5
			replacementCriterion = 5;
		case 6
			replacementCriterion = 6;
		case 7
			replacementCriterion = 7;
		otherwise
			disp("error, please try again")
	endswitch


	option = input("Which replacement method? \n1 -Method 1\n2 -Method 2 \n3 \
-Method 3\n");
	if(option == 2 || option == 3)
		progenitorsNumber = input("How many progenitor selected? (even number)\n");
		if(mod(progenitorsNumber,2) != 0)
			printf('ERROR: PROGENITORS NUMBER MUST BE AN EVEN NUMBER\n');
			exit();
		endif
	else
		progenitorsNumber = nan
	endif
	switch(option)
		case 1
			replacementMethod = 1; %Replace for @function
		case 2
			replacementMethod = 2;
		case 3
			replacementMethod = 3;
		otherwise
			disp("error, please try again")
	endswitch



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
			finalizeCriterion = 3;
		case 3
			finalizeCriterion = 4;
		otherwise
			disp("error, please try again")
	endswitch


	populationSize = input("What should be the population size?\n");
	mutationProbability = input("What should be the mutation probability? (0.0 <= p <= 1.0)\n");
	crossoverProbability = input("What should be the crossover probability? (0.0 <= p <= 1.0)\n");
	backpropagationProbability = input("What should be the backpropagation probability? (0.0 <= p <= 1.0)\n");

	hiddenUnitsPerLvl = [4 3];
	functiondataFilename = '../samples8.txt';%TODO: add to wizard
	[data testData] = data_import(functiondataFilename , 0.6,1);
	Input = data(:,[1 2]);
	ExpectedOutput = data(:,3);
	TestInput = testData(:,[1 2]);
	TestExpectedOutput = testData(:,3);
	%%Call function with all this variables as parameters
	
	geneticOperator
	selectionMethod
	replacementCriterion
	replacementMethod
	progenitorsNumber
	finalizeCriterion
	maxGenerations
	populationSize
	mutationProbability
	crossoverProbability
	backpropagationProbability

	evolvedNetwork = genetic(geneticOperator, crossoverProbability, backpropagationProbability, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, populationSize, mutationProbability, hiddenUnitsPerLvl, Input, ExpectedOutput, @hiperbolic_tangent, @hiperbolic_tangent_derivative, TestInput, TestExpectedOutput)
	[test_error, learning_rate, error_dif]  = testPerceptron(testData(:,[1 2]), testData(:,3), hiddenUnitsPerLvl, @hiperbolic_tangent, @hiperbolic_tangent_derivative, evolvedNetwork);
					
	if(yes_or_no("do you want plots?"))
		%%figure(1);
		%%resultsGraph(MAX_EPOC, train_error, eta_adaptation, epocs, train_learning_rate);
		%%figure(2);
		%%graphErrorHist(error_dif);
	endif
endfunction