%function graphErrorHist(errorData, min, max, qty)
%	dif = abs(max-min);
%	step = dif/qty;
%	hist(errorData, min:step:max);
%	xlabel('Orden de error');
%	ylabel('Frecuencia');
%	# title('Grafico de erorres...');
%endfunction

function graphErrorHist(error_dif)
	hist(error_dif,10);
	xlabel('Diferencia entre valor esperado y obtenido');
	ylabel('Frecuencia');
endfunction