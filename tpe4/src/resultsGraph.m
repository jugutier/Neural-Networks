 function resultsGraph(mean_fitness_generations, best_fitness_generations, last_index)
   	clf;  hold on;
	h = plot(1:last_index, mean_fitness_generations(:,1:last_index), '1');
  	i = plot(1:last_index,best_fitness_generations(:,1:last_index), '3');
  	set (h(1), "linewidth", 4);
  	set (i(1), "linewidth", 4);
  	plot(last_index, 0);
  	xlabel("Numero de Generacion");
  	ylabel("Fitness");
  	legend("Fitness promedio","Mejor fitness");
endfunction