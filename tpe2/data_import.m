#########
## @param:
## Filename the name of the CSV file (Remember its a string! MUST be between '')
##, column separator MUST be ; line endings MUST be windows kind.
## TrainPercentage: MUST be between 0 and 1, the percentage of rows to be used as TRAINING 
##########
function [trainingPattern testPattern] = data_import(Filename , TrainPercentage , ActivationFunction)
	load normalizeOneOne.m
	load normalizeZeroOne.m
	load sortpatterns.m

	extension = '';

	switch(ActivationFunction)
		case 1:
			extension = '.tan';
		case 2:
			extension = '.exp';

	endswitch
	
	name = strsplit(Filename,'.');
	percentage = strsplit(num2str(TrainPercentage),'.');
	loadTrainName = strcat(name{1},percentage{2},'0percent_train', extension);
	loadTestName = strcat(name{1},percentage{2},'0percent_test', extension);
	if(exist(loadTrainName,'file') && exist(loadTestName,'file'))
		trainingPattern = dlmread(loadTrainName);
		testPattern = dlmread(loadTestName);
	else
		patterns = load(Filename);
		switch(ActivationFunction)
			case 1:
				patterns = normalizeOneOne(patterns);
			case 2:
				patterns = normalizeZeroOne(patterns);
		endswitch
		[trainingPattern testPattern] = sortPatterns(patterns, TrainPercentage)		
		saveTrainName = strcat(name{1},percentage{2}, '0percent_train',extension);		
		saveTestName = strcat(name{1},percentage{2}, '0percent_test',extension);
		save(saveName, trainingPattern);
		save(saveName, testPattern);
	endif	
endfunction