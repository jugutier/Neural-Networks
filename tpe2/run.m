function run()
	g=0;
	g_derivative=0;
	hasLoaded = 0;
	reTrain = 0;
	hasTrained = 0;
	network = '';

	functiondataFilename = input("\nWelcome to the neural network assistant\n\n\n\nFunction data?\n(with extension and simple quote marks, please)\n(Default is samples8.txt)\n\n");
	if(yes_or_no("\nDo you already have a trained neural network?\n"))
		filename = input("What is the filename? (with extension and simple quote marks, please)\n Default autosavename is trained.nnet)\n");
		load(filename,'trainedNetwork','hiddenUnitsPerLvl');
		network = trainedNetwork;
		reTrain  = yes_or_no("retrain?");
		hasLoaded = 1;
	endif

	if(!hasLoaded || reTrain)
		if(!reTrain)
		hiddenUnitsPerLvl = input("\nType a vector for hidden units per level.\n \
eg. [2 3] will build a neural network \nwith two units in the first level and 3 in the second one.\
 \n(Note that input nodes and outputnodes depend only on the data provided.)\n\n");
		max_epocs = input("Maximum number of epocs?\n");
		endif
		momentum = yes_or_no("momentum?");
		eta_adaptative = yes_or_no("eta adaptative?");
	endif

		trainPercentage = input("Type a number between 0.0 and 1.0 for a train percentage.\n\
(Note that the compliment will be used for testing.)\n");
		
		resp=input("Which activation function? \n1 -Tangent\n2 -Exponencial\n");
		
		switch(resp)
			case 1
				[data testData]= data_import(functiondataFilename , trainPercentage,resp);
				if(!hasLoaded || reTrain)
					[MAX_EPOC, train_error, eta_adaptation,train_learning_rate, epocs, trainedNetwork] = trainPerceptron( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@hiperbolic_tangent,@hiperbolic_tangent_derivative,momentum,eta_adaptative,network,max_epocs);

					hasTrained = 1;
				endif
				if(hasLoaded||hasTrained)
					[test_error, learning_rate,mean_error]  = testPerceptron( testData(:,[1 2]),testData(:,3),hiddenUnitsPerLvl,@hiperbolic_tangent,@hiperbolic_tangent_derivative,trainedNetwork);
				endif
			case 2
				[data testData] = data_import(functiondataFilename , trainPercentage,resp);
				if(!hasLoaded || reTrain)
					[MAX_EPOC, train_error, eta_adaptation,train_learning_rate, epocs, trainedNetwork] = trainPerceptron( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@expo,@expo_derivative,momentum,eta_adaptative,network,max_epocs);
					hasTrained = 1;
				endif
				if(hasLoaded||hasTrained)
					[test_error, learning_rate,mean_error]  = testPerceptron( testData(:,[1 2]),testData(:,3),hiddenUnitsPerLvl,@expo,@expo_derivative,trainedNetwork);
				endif
			otherwise
				disp("error, please try again")
		endswitch
		if(hasTrained)
			save('trained.nnet','trainedNetwork' ,'hiddenUnitsPerLvl' );
		endif
		if(hasLoaded||hasTrained)
			printf('\n\nAverage cuadratic error on testing:%.4f \n',mean_error);
			save('testError.dump','test_error');
			printf('FINISHED: the network predicts %.4f of the TRAIN data and %.4f%% of the TEST data, to the order of 10^-3 \n',train_learning_rate*100, learning_rate*100);
		endif
		if(!hasLoaded || reTrain)
			save('graphData.dump','MAX_EPOC', 'train_error', 'eta_adaptation', 'epocs', 'train_learning_rate');
		endif
		if(yes_or_no("DELETE extra dumps?"))
			unlink('testError.dump');
			unlink('graphData.dump');
		endif
		if(!hasLoaded || reTrain)
			if(yes_or_no("do you want plots?"))
				figure(1);
				resultsGraph(MAX_EPOC, train_error, eta_adaptation, epocs, train_learning_rate);
				figure(2);
				graphErrorHist(test_error);
			endif
		endif
endfunction