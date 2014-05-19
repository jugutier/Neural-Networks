function out = eliteSelection(population, populationFitness)
    [sorted indexes] = sort(populationFitness, 2, 'descend');
    n = (size(populationFitness))(1);
    for i = 1 : n
        out(i) = population(indexes(i));
    end
end