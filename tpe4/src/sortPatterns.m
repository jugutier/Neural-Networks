function [trainingPattern testPattern] = sortPatterns(Patterns, TrainPercentage)
	rand = rand(size(Patterns,1),1);
	training_rows = rand < TrainPercentage;
	test_rows =  rand >= TrainPercentage;
	trainingPattern = Patterns(training_rows, :);
	testPattern =  Patterns(test_rows, :); 
endfunction