% SINGLE BIT MUTATION CHOSEN AT RANDOM
function newIndividualWeights = classicMutation(individualWeights , alleleMutationProbability)
	newIndividualWeights = individualWeights;
	randomNumber = rand();
	bitToMutateNumber = floor( randomNumber*size(individualWeights)(2)  + 1);
	bitToMutateOldValue = individualWeights(bitToMutateNumber);
	min_ = bitToMutateOldValue * 0.95;
	bitToMutateNewValue = rem(randomNumber,0.1)+min_;
	newIndividualWeights(bitToMutateNumber) = bitToMutateNewValue;
endfunction