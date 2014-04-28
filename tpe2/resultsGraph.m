 function resultsGraph(epocs, train_error, test_error, learning_rate, last_index)
  clf;  hold on;
	plot(1:last_index, errors'(1, 1:last_index), '-1; Error fase de entrenamiento;');
  plot(1:last_index, test_errors'(1, 1:last_index), '-2; Error fase de testeo;');
  plot(1:last_index,lrn_rates'(1, 1:last_index), '-3; Tasa de aprendizaje;');
  plot(epocs, 0);
  % title("Evolucion del perceptron", 'FontSize', 25);
  xlabel("Epoca numero", 'FontSize', 20);
  ylabel("Error", 'FontSize', 20);
endfunction