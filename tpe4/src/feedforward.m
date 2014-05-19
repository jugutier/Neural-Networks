%
%InputPattern : just one pattern (array)
%Network: the network (list of matrixes)
%g: activation function
%
%@return outputValues one, or more values (array) that output the network. Mostly a scalar.
%
function outputValues = feedforward(InputPattern,Network,g)
	for j=1:levels-1

		currentLvlWValues = wValues{j+1} 		;

		currentLvlVValues = vValues{j} 		;
	
		hj = (currentLvlWValues * (currentLvlVValues') )' 		;

		hValues{j+1} = hj;
		if(j!=levels-1)
			vValues{j+1} = cat(2,-1,arrayfun(g, hj)) 	;	
		else 
			vValues{j+1} = arrayfun(g, hj)	;
		endif
		
	endfor
	outputValues = vValues{levels};
end
