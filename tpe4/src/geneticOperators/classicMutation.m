function out = classicMutation(individualWeights, mutationProbability)
	
	individualWeightsSize = size(individualWeights)(2);

	for i = 1 : individualWeightsSize
		randomNumber = rand();
		if (randomNumber < crossoverProbability)
			max = individualWeights(i) * 1.1;
			min = individualWeights(i) * 0.9;
			newWeight = rem(randomNumber,(max-min)+min);
			individualWeights(i) = newWeight;
		endif
	endfor

endfunction