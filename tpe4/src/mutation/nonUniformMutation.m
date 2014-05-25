% MULTIBIT MUTATION
function newIndividualWeights = nonUniformMutation(individualWeights, alleleMutationProbability)	
	individualWeightsSize = size(individualWeights)(2);
	for i = 1 : individualWeightsSize
		randomNumber = rand();
		if (randomNumber < alleleMutationProbability)
			min_ = individualWeights(i) * 0.95;
			newWeight = rem(randomNumber,0.1)+min_;
			newIndividualWeights(i) = newWeight;
		else
			newIndividualWeights(i) = individualWeights(i);
		endif
	endfor
endfunction