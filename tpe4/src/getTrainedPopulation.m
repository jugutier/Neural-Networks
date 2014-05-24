function [weights populationInArrays weightsStructure fitnessAll] = getTrainedPopulation()
	load('trained.pop','weights' ,'populationInArrays','weightsStructure','fitnessAll');
endfunction