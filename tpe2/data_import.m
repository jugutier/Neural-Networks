#########
## @param:
## Filename the name of the CSV file (Remember its a string! MUST be between '')
##, column separator MUST be ; line endings MUST be windows kind.
## TrainPercentage: MUST be between 0 and 1, the percentage of rows to be used as TRAINING 
##########
function [trainingPattern testPattern] = data_import(Filename , TrainPercentage)
	CSV = dlmread(Filename, ',');
	rand = rand(size(CSV,1),1);
	training_rows = rand < TrainPercentage;
	test_rows =  rand >= TrainPercentage;
	trainingPattern = CSV(training_rows, :);
	testPattern =  CSV(test_rows, :); 
endfunction