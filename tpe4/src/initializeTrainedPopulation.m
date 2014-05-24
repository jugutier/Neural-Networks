function initializeTrainedPopulation(populationSize)
	populationInArrays = cell(populationSize, 1);
	[data testData] = data_import('../samples8.txt' , 0.6,1);
	Input = data(:,[1 2]);
	ExpectedOutput = data(:,3);
	max_epocs = 1;
	EtaAdaptativeEnabled = 0;
	MomentumEnabled = 1;
	HiddenUnitsPerLvl = [4 3];
	g=@hiperbolic_tangent;
	g_derivate = @hiperbolic_tangent_derivative;
	for i = 1 : populationSize 
		Network = weightsGenerator(HiddenUnitsPerLvl, i);
		[MAX_EPOC, train_error, eta_adaptation, train_learning_rate, epocs, trainedNetwork] = trainPerceptron(Input, ExpectedOutput, HiddenUnitsPerLvl, g, g_derivate, MomentumEnabled, EtaAdaptativeEnabled, Network, max_epocs);
		weights{i} = trainedNetwork;
		%Transform the matrix to an array
		populationInArrays{i} =  weightsArray(weights{i}); 
	endfor
	weightsStructure = weights{1};
	save('trained.pop','weights' ,'populationInArrays','weightsStructure' );
endfunction

function a = weightsArray(weights)
	a = [];
	for i = 1 : size(weights)(1)
		a = [a weights{i}(:)'];
	endfor
endfunction