function [individualsToReproduce individualsToReproduceFitness populationInArrays populationInArraysFitness] = eliteSelection(population, populationFitness, progenitorsNumber)
    [sortedFitness indexes] = sort(populationFitness, 'descend');
    n = (size(population))(2);
    selectedIndexes = indexes(1 : progenitorsNumber);
    remainingIndexes = indexes(progenitorsNumber+1:n);
    individualsToReproduce = population(selectedIndexes);
    individualsToReproduceFitness = sortedFitness(1:progenitorsNumber);
    populationInArrays = population(remainingIndexes);
    populationInArraysFitness = sortedFitness(progenitorsNumber+1:n);
end