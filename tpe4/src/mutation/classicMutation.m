% SINGLE BIT MUTATION CHOSEN AT RANDOM
function newIndividualWeights = classicMutation(individualWeights)	
	randomNumber = rand();
	individualWeightsSize = size(individualWeights)(2);
	bitToMutate = rem(randomNumber,individualWeightsSize);
	newIndividualWeights = individualWeights;

	max_ = individualWeights(bitToMutate) * 1.05;
	min_ = individualWeights(bitToMutate) * 0.95;
	newWeight = rem(randomNumber,(max_-min_)+min_);
	newIndividualWeights(bitToMutate) = newWeight;
endfunction