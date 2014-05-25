function graphErrorHist(error_dif)
	hist(error_dif,10);
	xlabel('Diferencia entre valor esperado y obtenido');
	ylabel('Frecuencia');
endfunction