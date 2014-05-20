function out = eliteSelection(population, populationFitness)
    [sorted indexes] = sort(populationFitness, 'descend');
    n = (size(population))(2);
    for i = 1 : n
        out(i) = population(indexes(i));
    end
end