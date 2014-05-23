function newIndividualWeights = classicMutation(individualWeights, alleleMutationProbability)	
	individualWeightsSize = size(individualWeights)(2);
	for i = 1 : individualWeightsSize
		randomNumber = rand();
		if (randomNumber < alleleMutationProbability)
			max_ = individualWeights(i) * 1.05;
			min_ = individualWeights(i) * 0.95;
			newWeight = rem(randomNumber,(max_-min_)+min_);
			newIndividualWeights(i) = newWeight;
		else
			newIndividualWeights(i) = individualWeights(i);
		endif
	endfor
endfunction