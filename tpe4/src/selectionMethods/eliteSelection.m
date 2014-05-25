function [selectedIndexes remainingIndexes] = eliteSelection(population, populationFitness, progenitorsNumber)
    [sortedFitness indexes] = sort(populationFitness, 'descend');
    n = (size(populationFitness))(2); 
    selectedIndexes = indexes(1 : progenitorsNumber);
    population
    remainingIndexes = indexes((progenitorsNumber+1) : n);
 endfunction