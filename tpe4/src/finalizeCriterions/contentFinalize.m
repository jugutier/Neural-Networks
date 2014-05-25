function out = contentFinalize(generation, maxGenerations, populationInArrays, populationInArraysFitness, prevPopulation, prevPopulationFitness, best_fitness_generations )
	if(length(best_fitness_generations) <= 2)
		out = 1;
	else
		l = length(best_fitness_generations);
		if(best_fitness_generations(l) == best_fitness_generations(l-1))
			best_fitness_generations
			out = 0;
		else
			out = 1;
		endif
	endif
endfunction