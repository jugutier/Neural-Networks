% todo: probar esta funcion
% selectionQty es la cantidad de individuos a seleccionar
% selectedPopulation contiene los array indexes de los individuos seleccionados

function selectedPopulation = universalSelection(populationFitness, selectionQty)
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
	randomNumber = unifrnd(0,1/selectionQty);
	prevIndex = 1;
	for i = 1 : selectionQty
		selectedIndividual = 0;
		
		for j = prevIndex : populationSize
			selectedIndividual = j;
			randomJ = randomNumber + j - 1;
			randomJ = randomJ / populationSize;
			if(randomJ < accumFitness(j))
				prevIndex = j;
				break;
			endif
		endfor
		selectedPopulation(i) = selectedIndividual;
	endfor
endfunction