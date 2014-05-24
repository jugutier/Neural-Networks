% todo: probar esta funcion
% selectionQty es la cantidad de individuos a seleccionar
% selectedPopulation contiene los array indexes de los individuos seleccionados

function selectedPopulation = rouletteSelection(populationFitness, selectionQty)
	populationSize = size(populationFitness);
	fitnessSum = sum(populationFitness);
	relativeFitness = populationFitness ./ fitnessSum;

	accumFitness = [];
	accumulator = 0;
	for i = 1 : populationSize
		accumulator = accumulator + relativeFitness(i);
		accumFitness = accumulator;
	endfor

	selectedPopulation = [];
	for i = 1 : selectionQty
		selectedIndividual = 0;
		randomNumber = rand() * max(accumFitness);
		for j = 1 : populationSize
			if(randomNumber < accumFitness(j))
				accumFitness(j) = -1;
				selectedIndividual = j;
				break;
			endif
		endfor
		selectedPopulation[i] = selectedIndividual;
	endfor
endfunction