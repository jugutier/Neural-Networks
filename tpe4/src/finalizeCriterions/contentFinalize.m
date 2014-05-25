function out = contentFinalize(generation, maxGenerations, populationInArrays, populationInArraysFitness, prevPopulation, prevPopulationFitness, best_fitness_generations )
	epsilon = 0.001;
	if(length(best_fitness_generations) <= 2)
		out = 1;
	else
		l = length(best_fitness_generations);
		previous_best_fitness = best_fitness_generations(l-1)
		actual_best_fitness = best_fitness_generations(l)
		if(abs(best_fitness_generations(l) - best_fitness_generations(l-1)) < epsilon)
			out = 0;
		else
			out = 1;
		endif
	endif
endfunction