function [train_error, train_learning_rate,eta_adaptation, epocs ,trainedNetwork] = trainPerceptron(Network,Max_epocs,Input, ExpectedOutput ,HiddenUnitsPerLvl , g ,g_derivate,MomentumEnabled, EtaAdaptativeEnabled)
	while()
		tic%start epoc
		for i = 1:rows(testPatterns)
			currentPattern = testPatterns(i,:);
			currentExpectedOutput = ExpectedOutput(i,:);

			outputValues = feedforward(InputPattern,Network,g);
			backpropagation()
			correctWeights();

		endfor
		toc%end epoc
	endwhile

endfunction
