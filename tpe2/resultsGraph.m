 function resultsGraph(epocs, train_error, eta_adaptation, last_index, train_learning_rate)
   	clf;  hold on;
	plot(1:last_index, train_error(:,1:last_index), '-1; Error fase de entrenamiento;');
  	plot(1:last_index,eta_adaptation(:,1:last_index), '-2; Adaptacion de ETA;');
  	plot(1:last_index,train_learning_rate(:,1:last_index), '-3; Tasa de aciertos ;');
  	plot(epocs, 0);
  	# title("Evolucion del perceptron", 'FontSize', 25);
  	xlabel("Epoca numero", 'FontSize', 20);
  	ylabel("Error", 'FontSize', 20);
endfunction