#########
## @param:
## Filename the name of the CSV file (Remember its a string! MUST be between '')
##, column separator MUST be ; line endings MUST be windows kind.
## TrainPercentage: MUST be between 0 and 1, the percentage of rows to be used as TRAINING 
##########
function [trainingPattern testPattern] = data_import(Filename , TrainPercentage)

	name = strsplit(Filename,".");
	percentage = strsplit(num2str(TrainPercentage),".");
	loadName = strcat(name{1},"ShuffledTrain","TP",percentage{2},percentage{3}, ".csv");

	if(!exist(loadName,'file'))
		CSV = dlmread(Filename, ',');
		rand = rand(size(CSV,1),1);
		training_rows = rand < TrainPercentage;
		test_rows =  rand >= TrainPercentage;
		trainingPattern = CSV(training_rows, :);
		testPattern =  CSV(test_rows, :); 
			saveName = strcat(name{1},"ShuffledTrain","TP",percentage{2},percentage{3}, ".csv");
			dlmwrite(saveName, trainingPattern);
			saveName = strcat(name{1},"ShuffledTest","TP",percentage{2},percentage{3}, ".csv");
			dlmwrite(saveName, testPattern);
	else
		trainingPattern = dlmread(loadName);
		loadName = strcat(name{1},"ShuffledTest","TP",percentage{2},percentage{3}, ".csv");
		if(exist(loadName,'file'))
			testPattern = dlmread(loadName);
		endif
	endif
	
endfunction