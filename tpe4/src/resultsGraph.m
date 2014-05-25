 function resultsGraph(mean_fitness_generations, best_fitness_generations, last_index)
   	clf;  hold on;
	plot(1:last_index, mean_fitness_generations(:,1:last_index), '1');
  	plot(1:last_index,best_fitness_generations(:,1:last_index), '3');
  	plot(last_index, 0);
  	xlabel("Numero de Generacion");
  	ylabel("Fitness");
endfunction