function newNetwork = correctWeights(Network)
	for i=2:levels
		currentLvlWValues = wValues{i}   		;
		currentLvlVValues = vValues{i-1}  	;
		currentLvlDeltaValues = deltaValues{i}		;

		calculationWithDelta = ETA * currentLvlDeltaValues' * currentLvlVValues ;
		wValues{i} =  currentLvlWValues + calculationWithDelta ; 
		if(MomentumEnabled ==1)
			wValues{i} = wValues{i} + oldCDeltaValues{i} * ALPHA ;
		endif

		oldCDeltaValues{i} = calculationWithDelta ;
	endfor
endfunction
