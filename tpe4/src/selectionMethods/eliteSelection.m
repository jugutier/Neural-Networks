function out = eliteSelection(population, populationFitness, progenitorsNumber)
    [sorted indexes] = sort(populationFitness, 'descend');
    n = (size(population))(2);
    for i = 1 : progenitorsNumber
        out(i) = population(indexes(i));
    end
end