function run()
	##ACTIVATION FUNCTIONS
	##load hiperbolic_tangent.m
	##load hiperbolic_tangent_derivative.m
	##load expo.m
	##load expo_derivative.m

	##load part1_multilayer_simetry.m
	##load data_import.m
	##load resultsGraph.m
	##load graphErrorHist.m
	##load testPerceptron.m

	##g=0;
	##g_derivative=0;
	##hasLoaded = 0;
	##reTrain = 0;
	##hasTrained = 0;
	##network = '';

	disp("Welcome to the genetic algorithm wizard\n")
	option = input("Which genetic operator? \n1 -Classic crossover(one point)\n2 -Two point crossover \n3 \
		Uniform crossover \n4 -Anular crossover \n5 -Classic mutation \n6 -Not uniform mutation \n7 - Backpropagation\n");
	switch(option)
		case 1
			geneticOperator = 1; #Replace for @function
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
		Boltzman \n4 -Tournament deterministic \n5 -Tournament probabilistic \n6 -Elite+Roulette \n7 - Elite+Universal\n");
	switch(option)
		case 1
			selectionMethod = 1; #Replace for @function
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
		Boltzman \n4 -Tournament deterministic \n5 -Tournament probabilistic \n6 -Elite+Roulette \n7 - Elite+Universal\n");
	switch(option)
		case 1
			replacementCriterion = 1; #Replace for @function
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
		Method 3\n");
	if(option == 2 || option == 3)
		progenitorsNumber = input("How many progenitor selected?\n");
	else
		progenitorsNumber = nan
	endif
	switch(option)
		case 1
			replacementMethod = 1; #Replace for @function
		case 2
			replacementMethod = 2;
		case 3
			replacementMethod = 3;
		otherwise
			disp("error, please try again")
	endswitch



	option = input("When should we end the algorithm? \n1 -Max number of generations \n2 -Structure \n3 \
		Content \n4 - around the optimun\n");
	if(option == 1)
		maxGenerations = input("What should be the maximum number of generations?\n");
	else
		maxGenerations = inf
	endif
	switch(option)
		case 1
			finalizeCriterion = 1; #Replace for @function
		case 2
			finalizeCriterion = 2;
		case 3
			finalizeCriterion = 3;
		case 3
			finalizeCriterion = 4;
		otherwise
			disp("error, please try again")
	endswitch


	population = input("What should be the population size?\n");
	mutationProbability = input("What should be the mutation probability? (0.0 <= p <= 1.0)\n");


	##Call function with all this variables as parameters
	
	geneticOperator
	selectionMethod
	replacementCriterion
	replacementMethod
	progenitorsNumber
	finalizeCriterion
	maxGenerations
	population
	mutationProbability


	if(yes_or_no("do you want plots?"))
		##figure(1);
		##resultsGraph(MAX_EPOC, train_error, eta_adaptation, epocs, train_learning_rate);
		##figure(2);
		##graphErrorHist(error_dif);
	endif
endfunction