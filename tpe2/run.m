function run()
	##ACTIVATION FUNCTIONS
	load hiperbolic_tangent.m
	load hiperbolic_tangent_derivative.m
	load expo.m
	load expo_derivative.m

	load part1_multilayer_simetry.m
	load data_import.m
	load resultsGraph.m
	load graphErrorHist.m
	load testPerceptron.m

	g=0;
	g_derivative=0;
	hasLoaded = 0;
	reTrain = 0;
	hasTrained = 0;
	network = '';
	if(yes_or_no("\nWelcome to the neural network assistant\n\n\n\nDo you already have a trained neural network?\n"))
		filename = input("What is the filename? (with extension and simple quote marks, please)\n Default autosavename is trainedNetwork.dump)\n");
		load(filename,'trainedNetwork','hiddenUnitsPerLvl');
		network = trainedNetwork;
		reTrain  = yes_or_no("reTrain?");
		hasLoaded = 1;
	endif

	if(!hasLoaded || reTrain)
		if(!reTrain)
		hiddenUnitsPerLvl = input("Type a vector for hidden units per level.\n \
eg. [2 3] will build a neural network \nwith two units in the first level and 3 in the second one.\
 \n(Note that input nodes and outputnodes depend only on the data provided.)\n");
		endif
		momentum = yes_or_no("momentum?");
		eta_adaptative = yes_or_no("eta adaptative?");
	endif

		trainPercentage = input("Type a number between 0.0 and 1.0 for a train percentage.\n\
(Note that the compliment will be used for testing.)\n");
		resp=input("Which activation function? \n1 -Tangent\n2 -Exponencial\n");
		
		switch(resp)
			case 1
				[data testData]= data_import('samples8normOneOne.csv' , trainPercentage);
				if(!hasLoaded || reTrain)
					[MAX_EPOC, train_error, eta_adaptation, train_learning_rate, epocs,trainedNetwork, hits_at_end_epoc] = part1_multilayer_simetry( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@hiperbolic_tangent,@hiperbolic_tangent_derivative,momentum,eta_adaptative,network);
					hasTrained = 1;
				endif
				if(hasLoaded||hasTrained)
					[test_error, learning_rate, error_dif]  = testPerceptron( testData(:,[1 2]),testData(:,3),hiddenUnitsPerLvl,@hiperbolic_tangent,@hiperbolic_tangent_derivative,trainedNetwork);
					learning_rate
				endif
			case 2
				[data testData] = data_import('samples8normZeroOne.csv' , trainPercentage);
				if(!hasLoaded || reTrain)
					[MAX_EPOC, train_error, eta_adaptation,train_learning_rate, learning_rate, epocs,trainedNetwork, hits_at_end_epoc] = part1_multilayer_simetry( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@expo,@expo_derivative,momentum,eta_adaptative,network);
					hasTrained = 1;
				endif
				if(hasLoaded||hasTrained)
					[test_error, learning_rate, error_dif]  = testPerceptron( testData(:,[1 2]),testData(:,3),hiddenUnitsPerLvl,@expo,@expo_derivative,trainedNetwork);
				endif
			otherwise
				disp("error, please try again")
		endswitch
		if(hasTrained)
			save('trainedNetwork.dump','trainedNetwork' ,'hiddenUnitsPerLvl' );
		endif
		if(hasLoaded||hasTrained)
			printf("\n\nAverage cuadratic error on testing:%.10f%% \n",(sum(test_error)/columns(test_error))*100);
			save('testError.dump','test_error');
			printf("FINISHED: the network predicts %.10f%% of the test data, to the order of 10^-3 \n", learning_rate*100);
		endif
		save('graphData.dump','MAX_EPOC', 'train_error', 'eta_adaptation', 'epocs', 'train_learning_rate');
		if(!hasLoaded || reTrain)
			if(yes_or_no("do you want plots?"))
				figure(1);
				resultsGraph(MAX_EPOC, train_error, eta_adaptation, epocs, train_learning_rate);
				figure(2);
				graphErrorHist(error_dif);
			endif
		endif
endfunction