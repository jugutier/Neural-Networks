% SINGLE BIT MUTATION CHOSEN AT RANDOM
function newIndividualWeights = classicMutation(individualWeights)
	bitToMutate = floor(rand() * size(individualWeights)(2) + 1);
	newIndividualWeights = individualWeights;

	max_ = individualWeights(bitToMutate) * 1.05;
	min_ = individualWeights(bitToMutate) * 0.95;
	newWeight = rem(randomNumber,(max_-min_)+min_);
	newIndividualWeights(bitToMutate) = newWeight;
endfunction