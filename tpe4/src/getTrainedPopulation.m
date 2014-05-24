function [weights populationInArrays weightsStructure] = getTrainedPopulation()
	load('trained.pop','weights' ,'populationInArrays','weightsStructure');
endfunction