 function resultsGraph(epocs, train_error, test_error, eta_adaptation, last_index)
   	clf;  hold on;
	plot(1:last_index, train_error(:,1:last_index), '-1; Error fase de entrenamiento;');
  	plot(1:last_index, test_error(:,1:last_index), '-2; Error fase de testeo;');
  	plot(1:last_index,eta_adaptation(:,1:last_index), '-3; Adaptacion de ETA;');
  	plot(epocs, 0);
  	# title("Evolucion del perceptron", 'FontSize', 25);
  	xlabel("Epoca numero", 'FontSize', 20);
  	ylabel("Error", 'FontSize', 20);
endfunction