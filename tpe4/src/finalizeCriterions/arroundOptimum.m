function out = arroundOptimum(generation, b, best_fitness_generations)
	fitness_limit = 1000;
	generations_limit = 200;
	len = length(best_fitness_generations);
	if( len > 0)
		if( best_fitness_generations(len) >= fitness_limit || generation >= generations_limit )
			out = 0;
		else
			out = 1;
		endif
	else
		out = 1;
	endif
endfunction