function [selectedIndexes remainingIndexes] = tournamentProbSelection(population, populationFitness, progenitorsNumber)
	selectedIndexes = [];
    for i = 1 : progenitorsNumber
    	randomNumber = rand();
        individualOne = ceil(rand() * progenitorsNumber);
        individualTwo = ceil(rand() * progenitorsNumber);
        if(randomNumber < 0.75) 
            if (populationFitness(individualOne) > populationFitness(individualTwo))
                selectedIndexes(i) = individualOne;
            else
                selectedIndexes(i) = individualTwo;
            endif
        else
            if (populationFitness(individualOne) > populationFitness(individualTwo))
                selectedIndexes(i) = individualTwo;
            else
                selectedIndexes(i) = individualOne;
            endif     
        endif
    endfor

	populationSize = (size(populationFitness))(2);
    remainingIndexes = [0 : populationSize];
	for i = 1 : progenitorsNumber
		selectedIndividual = selectedIndexes(i);
		remainingIndexes(selectedIndividual) = 0;
	endfor
	% removes all zeros from the array
	remainingIndexes(remainingIndexes==0) = [];
endfunction