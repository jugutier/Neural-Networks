function [selectedIndexes remainingIndexes] = eliteSelection(population, populationFitness, progenitorsNumber)
    [sortedFitness indexes] = sort(populationFitness, 'descend');
    n = (size(population))(1); 
    selectedIndexes = indexes(1 : progenitorsNumber);
    remainingIndexes = indexes((progenitorsNumber+1) : n);
end