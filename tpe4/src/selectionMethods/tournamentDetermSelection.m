function [selectedIndexes remainingIndexes] = tournamentDetermSelection(population, populationFitness, progenitorsNumber)
	populationSize = (size(populationFitness))(2);
	selectedIndexes = [];
	competitorsPerFight = 3;
    for i = 1 : progenitorsNumber
    	winnerFitness = 0;
    	winnerIndex = 0;
    	competitorsIndexes = randperm(populationSize,competitorsPerFight);
    	for j = 1 : competitorsPerFight
    		individualIndex = competitorsIndexes(j);
    		if(populationFitness(individualIndex) > winnerFitness)
    			winnerFitness = populationFitness(individualIndex);
    			winnerIndex = individualIndex;
    		endif
    	endfor
    	selectedIndexes = [selectedIndexes winnerIndex];
    endfor
    % selectedIndexes = unique(selectedIndexes); descomentar si no aceptamos padres repetidos

    remainingIndexes = [0 : populationSize];
	for i = 1 : progenitorsNumber
		selectedIndividual = selectedIndexes(i);
		remainingIndexes(selectedIndividual) = 0;
	endfor
	% removes all zeros from the array
	remainingIndexes(remainingIndexes==0) = [];
endfunction