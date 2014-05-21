% UNIFORM with P=0.5 probability of crossover
function out = uniformCrossover(individual1, individual2)
	individualsSize = size(individual1)(2);
	crossoverProbability = 0.5;
	desc1 = [];
	desc2 = [];
	
	for i = 1 : individualsSize
		w1 = individual1(i);
		w2 = individual2(i);
		randomNumber = rand();
		if (randomNumber < crossoverProbability)
			aux = w1;
            w1 = w2;
            w2 = aux;
		endif
		desc1 = [desc1 w1];
		desc2 = [desc2 w2];
	endfor
	
	out{1} = desc1;
	out{2} = desc2;
end