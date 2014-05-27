function [weights populationInArrays weightsStructure fitnessAll] = getTrainedPopulation()
	load('trained2.pop','weights' ,'populationInArrays','weightsStructure','fitnessAll');
endfunction