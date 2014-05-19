function deltaValues = backpropagation()

	deltaValues{levels} =g_derivate(hj) *(currentExpectedOutput - outputValues );

	%% BACKPROPAGATION START
	for k = levels :-1: 2		

		displacementIndexes = linspace(1,HiddenUnitsPerLvl(k-1),HiddenUnitsPerLvl(k-1)).+1     ;	%hay que sacar el peso del -1, el peso del umbral, la primer columna, para volver
	
		currentLvlWValues = wValues{k};  
	
		currentLvlWValues = currentLvlWValues(:,displacementIndexes)     	;	% ahora empiezo a volver entonces es desde la raiz hacia abajo, hacer el dibujo del arbol dado vuelta

		h = hValues{k-1} 		;
	
		delta = deltaValues{k} 	;


		tempCurrentLvlDeltaValues=0;
		for i=1 :columns(currentLvlWValues)
			deltai = g_derivate(h(i))* (delta * currentLvlWValues(:,i))		;

			tempCurrentLvlDeltaValues(i) = deltai;
		endfor

		deltaValues{k-1} =   tempCurrentLvlDeltaValues ;

	endfor 
	%%BACKPROPAGATION END
end
