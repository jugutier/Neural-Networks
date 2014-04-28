#########
## @param:
## Filename the name of the CSV file (Remember its a string! MUST be between '')
##, column separator MUST be ; line endings MUST be windows kind.
## TrainPercentage: MUST be between 0 and 1, the percentage of rows to be used as TRAINING 
##########
function [trainingPattern testPattern] = data_import(Filename , TrainPercentage)

	name = strsplit(Filename,".");
	loadName = strcat(name{1},TrainPercentage,"shuffledTrain.m");

	if(!exist(loadName,'file'))
		CSV = dlmread(Filename, ',');
		rand = rand(size(CSV,1),1);
		training_rows = rand < TrainPercentage;
		test_rows =  rand >= TrainPercentage;
		trainingPattern = CSV(training_rows, :);
		testPattern =  CSV(test_rows, :); 
			saveName = strcat(name{1},TrainPercentage,'shuffledTrain.m')
			dlmwrite(saveName, trainingPattern); ##### this is ONLY valid when using the same TrainPercentage
			saveName = strcat(name{1},TrainPercentage,'shuffledTest.m');
			dlmwrite(saveName, testPattern); ##### this is ONLY valid when using the same TrainPercentage
	else
		trainingPattern = dlmread(loadName);
		loadName = strcat(name{1},TrainPercentage,'shuffledTest.m');
		if(exist(loadName,'file'))
			testPattern = dlmread(loadName);
		endif
	endif
	
endfunction