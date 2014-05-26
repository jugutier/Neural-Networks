function [selectedIndexes remainingIndexes] = rouletteSelection(population, populationFitness, progenitorsNumber)
	populationSize = (size(populationFitness))(2);
	fitnessSum = sum(populationFitness);
	relativeFitness = populationFitness ./ fitnessSum;

	accumFitness = [];
	accumulator = 0;
	for i = 1 : populationSize
		accumulator = accumulator + relativeFitness(i);
		accumFitness(i) = accumulator;
	endfor

	selectedIndexes = [];
	for i = 1 : progenitorsNumber
		selectedIndividual = 0;
		randomNumber = rand() * accumulator;
		for j = 1 : populationSize
			if(randomNumber < accumFitness(j))
				accumFitness(j) = -1;
				selectedIndividual = j;
				break;
			endif
		endfor
		selectedIndexes(i) = selectedIndividual;
	endfor

	remainingIndexes = [0 : populationSize];
	for i = 1 : progenitorsNumber
		selectedIndividual = selectedIndexes(i);
		remainingIndexes(selectedIndividual) = 0;
	endfor
	% removes all zeros from the array
	remainingIndexes(remainingIndexes==0) = [];
endfunction