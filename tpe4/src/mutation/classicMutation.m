function newIndividualWeights = classicMutation(individualWeights, alleleMutationProbability)
	
	individualWeightsSize = size(individualWeights)(2);

	for i = 1 : individualWeightsSize
		randomNumber = rand();
		if (randomNumber < alleleMutationProbability)
			max = individualWeights(i) * 1.1;
			min = individualWeights(i) * 0.9;
			newWeight = rem(randomNumber,(max-min)+min);
			newIndividualWeights(i) = newWeight;
		endif
	endfor

endfunction