function [selectedIndexes remainingIndexes] = mixedUniversalSelection(population, populationFitness, progenitorsNumber)
	populationSize = (size(populationFitness))(2);
	selectedIndexesElite = [];
	selectedIndexesRoulette = [];
	remainingIndexesElite = [];
	remainingIndexesRoulette = [];
	n = floor(progenitorsNumber/2);

	originalPopulationFitness = populationFitness;
	[selectedIndexesElite remainingIndexesElite] = eliteSelection(population,originalPopulationFitness,n);
	selectedIndexes = selectedIndexesElite;

	% remove selected individuals
	for i = 1 : n
		populationFitness(selectedIndexesElite(i)) = 0;
	endfor
	% removes all zeros from the arrays
	remainingPopulationFitness = populationFitness;
	remainingPopulationFitness(remainingPopulationFitness==0) = [];

	[selectedIndexesRoulette remainingIndexesRoulette] = universalSelection(population,remainingPopulationFitness,progenitorsNumber-n);

	%match indexes obtained from roulette
	for i = 1 : length(selectedIndexesRoulette)
		k = 0;
		for j = 1 : length(populationFitness)
			if(populationFitness(j) != 0)			
				k++;
				if(k == selectedIndexesRoulette(i))
					selectedIndexes = [selectedIndexes j];
				endif
			endif
		endfor
	endfor

	%calculate remainingIndexes
    remainingIndexes = [0 : populationSize];
	for i = 1 : progenitorsNumber
		selectedIndividual = selectedIndexes(i);
		remainingIndexes(selectedIndividual) = 0;
	endfor
	% removes all zeros from the array
	remainingIndexes(remainingIndexes==0) = [];
endfunction