function newEta =  adaptEta(OldEta , Max_Eta_Value, i)
 	if(ETA < Max_Eta_Value)
		deltaError = errorMedioPromedio - errorMedioPromedioAnterior;
		if(deltaError >0)
			ETA = ETA - etaDecrement * ETA;
		else
			if(currK < K)
				currK++;
			else
				ETA+=etaIncrement;
				currK=0;
			endif
			
		endif
	endif
endfunction
