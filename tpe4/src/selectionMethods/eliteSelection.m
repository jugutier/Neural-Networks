function [individualsToReproduce populationInArrays] = eliteSelection(population, populationFitness, progenitorsNumber)
    [sorted indexes] = sort(populationFitness, 'descend');
    n = (size(population))(2);
    for i = 1 : progenitorsNumber
        individualsToReproduce(i) = population(indexes(i));
    end
    populationInArrays = population(indexes(progenitorsNumber:length(indexes)));
end