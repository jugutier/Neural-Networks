function [selectedIndexes remainingIndexes] = boltzmannSelection(population, populationFitness, progenitorsNumber)
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

function a = expval (population, populationFitness , generation)
	%Boltzmann temperature
	minT = 1;
	maxT = 1000;
	T = maxT;
	decrementT = 3;

	T = T - generation * Tdecrement;
	if ( T < 0 )
		T = minT;
	endif

	boltzmannMean = 0;
	for i = 1 : length(populationFitness)
		boltzmannMean = boltzmannMean + exp(aptitud(population{i})/T);
	endfor
	boltzmannMean = boltzmannMean / length(populationFitness);

	super.select(population, generation);

	values = exp(populationFitness(i) / T) / boltzmannMean;


endfunction