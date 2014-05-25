function [selectedIndexes remainingIndexes] = tournamentDetermSelection(population, populationFitness, progenitorsNumber)
	populationSize = (size(populationFitness))(2);
	selectedIndexes = [];
	competitorsPerFight = 3;
    for i = 1 : progenitorsNumber
    	competitors = [];
    	for j = 1 : competitorsPerFight
    		individual = ceil(rand() * populationSize);
    		competitors = [competitors populationFitness(individual)];
    	endfor
    	winner = max(competitors);
    	selectedIndexes = [selectedIndexes winner];
    endfor
    % selectedIndexes = unique(selectedIndexes); descomentar si no aceptamos padres repetidos

	populationSize = (size(populationFitness))(2);
    remainingIndexes = [0 : populationSize];
	for i = 1 : progenitorsNumber
		selectedIndividual = selectedIndexes(i);
		remainingIndexes(selectedIndividual) = 0;
	endfor
	% removes all zeros from the array
	remainingIndexes(remainingIndexes==0) = [];
endfunction