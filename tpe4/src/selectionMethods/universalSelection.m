function [selectedIndexes remainingIndexes] = universalSelection(population, populationFitness, progenitorsNumber)
	populationSize = (size(population))(1);
	fitnessSum = sum(populationFitness);
	relativeFitness = populationFitness ./ fitnessSum;

	accumFitness = [];
	accumulator = 0;
	for i = 1 : populationSize
		accumulator = accumulator + relativeFitness(i);
		accumFitness = accumulator;
	endfor

	selectedIndexes = [];
	randomNumber = unifrnd(0,1/progenitorsNumber);
	prevIndex = 1;
	for i = 1 : progenitorsNumber
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