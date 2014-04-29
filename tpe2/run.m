function run()
	##ACTIVATION FUNCTIONS
	load hiperbolic_tangent.m
	load hiperbolic_tangent_derivative.m
	load expo.m
	load expo_derivative.m

	load part1_multilayer_simetry.m
	load data_import.m
	load resultsGraph.m

	g=0;
	g_derivative=0;
	hasLoaded = 0;

	if(yes_or_no("\nWelcome to the neural network assistant\n\n\n\nDo you already have a trained neural network?\n"))
		filename = input("What is the filename? (with extension and simple quote marks, please)\n Default autosavename is trainedNetwork.dump)\n");
		load(filename,'trainedNetwork','hiddenUnitsPerLvl');
		hasLoaded = 1;
	else
		trainedNetwork = '';
		hiddenUnitsPerLvl = input("Type a vector for hidden units per level.\n \
eg. [2 3] will build a neural network \nwith two units in the first level and 3 in the second one.\
 \n(Note that input nodes and outputnodes depend only on the data provided.)\n");
	endif

		trainPercentage = input("Type a number between 0.0 and 1.0 for a train percentage.\n\
(Note that the compliment will be used for testing.)\n");
		resp=input("Which activation function? \n1 -Tangent\n2 -Exponencial\n");
		momentum = yes_or_no("momentum?");
		eta_adaptative = yes_or_no("eta adaptative?");
		switch(resp)
			case 1
				[data testData]= data_import('samples8normOneOne.csv' , trainPercentage);
				[MAX_EPOC, train_error, test_error,eta_adaptation, train_learning_rate, learning_rate, epocs,trainedNetwork, hiddenUnitsPerLvl] = part1_multilayer_simetry( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@hiperbolic_tangent,@hiperbolic_tangent_derivative,momentum,eta_adaptative,testData(:,[1 2]),testData(:,3),trainedNetwork);
			case 2
				[data testData] = data_import('samples8normZeroOne.csv' , trainPercentage);
				[MAX_EPOC, train_error, test_error, eta_adaptation,train_learning_rate, learning_rate, epocs,trainedNetwork, hiddenUnitsPerLvl] = part1_multilayer_simetry( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@expo,@expo_derivative,momentum,eta_adaptative,testData(:,[1 2]),testData(:,3),trainedNetwork);
			otherwise
				disp("error, please try again")
		endswitch
		save('trainedNetwork.dump','trainedNetwork' ,'hiddenUnitsPerLvl' );
		printf("Average error:%f Error per test batch:\n",(sum(test_error)/columns(test_error)));
		save('testError.dump','test_error');
		save('graphData.dump','MAX_EPOC', 'train_error', 'eta_adaptation', 'epocs', 'train_learning_rate');
		if(!hasLoaded)
			if(yes_or_no("do you want plots?"))
				resultsGraph(MAX_EPOC, train_error, eta_adaptation, epocs, train_learning_rate);
			endif
		endif
printf("FINISHED: the network predicts %.20f%% of the test data, to the order of 10^-3 \n", learning_rate);

	

endfunction