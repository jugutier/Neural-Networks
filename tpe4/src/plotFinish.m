function plotFinish()
	functiondataFilename = '../samples8.txt';
	[data testData] = data_import(functiondataFilename , 0.6,1);
	Input = data(:,[1 2]);
	ExpectedOutput = data(:,3);
	TestInput = testData(:,[1 2]);
	TestExpectedOutput = testData(:,3);
	patterns = load(functiondataFilename);	
	totalOriginalInput = patterns(:,[1 2]);
	totalNormalizedInput  = [Input; TestInput];
	totalNormalizedOutput = [ExpectedOutput; TestExpectedOutput];
	load('../previousResults/trained.nnet','trainedNetwork');
	Network = trainedNetwork;
	%load('../outputs/output1/mostEvolved.nnet','evolvedNetwork');
	%Network = evolvedNetwork;
	[test_error, learning_rate,mean_error,our_value]  = testPerceptron(totalNormalizedInput ,totalNormalizedOutput,Network);
	for i=1:length(our_value)
		our_value(i) = our_value(i) * norm(patterns(i,:));
	endfor
	graph(patterns,[totalOriginalInput our_value]);
endfunction