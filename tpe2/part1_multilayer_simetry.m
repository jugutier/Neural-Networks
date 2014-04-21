##Input = [-1 -1 ;-1 1 ; 1 -1 ; 1 1 ];
##ExpectedOutput = [-1; 1; 1 ; -1];
function retVal = part1_multilayer_simetry(Input, ExpectedOutput , HiddenUnits, InternalLayers, g ,g_derivate)
	#########
	##Adding a column of -1 at the beginning with the input value of the threshold,
	##concat that with all the columns exept the last one, which is the expected answer
	#########
	testPatterns =cat(2,-1*ones(rows(Input),1),Input);
	#########
	##taking the last column which will be the expected output
	#########
	inputNodes = columns(Input);
	outputNodes = columns(ExpectedOutput);
	initialWValues = rand(HiddenUnits,inputNodes+1);
	initialWValuesLvl2 = rand(outputNodes,HiddenUnits+1); ##remember we are going up.

	###this matrix will have in each row the connections between the previous layer and current one 
	currentWValues = initialWValues
	currentWValuesLvl2 = initialWValuesLvl2
	ETA = 0.5;

	for i = 1:rows(testPatterns)
		currentPattern = testPatterns(i,:)

		currentExpectedOutput = ExpectedOutput(i,:);

		h1 = (currentWValues * (currentPattern'))'

		inputNodesLvl2 = cat(2,-1,arrayfun(@g, h1))		

		h2 = (currentWValuesLvl2 * (inputNodesLvl2'))'

		outputValues = arrayfun(@g,h2)

		delta2 = g_derivate(h2) *(currentExpectedOutput - outputValues )

		temp = linspace(1,HiddenUnits,HiddenUnits).+1#hay que sacar el peso del -1, el peso del umbral, la primer columna, para volver

		lavariable = currentWValuesLvl2(:,temp)'# ahora empiezo a volver entonces es desde la raiz hacia abajo, hacer el dibujo del arbol dado vuelta

		delta1 = g_derivate(h1) * sum(lavariable * delta2 )

		currentWValuesLvl2 = currentWValuesLvl2 + ETA * delta2 * inputNodesLvl2

		currentWValues = currentWValues + ETA * delta1' * currentPattern

	endfor

endfunction