function [populationInArrays  populationInArraysFitness]= replacementMethod(newIndividuals,newIndividualsFitenss,individualsToReproduce,individualsToReproduceFitness, populationInArrays , populationInArraysFitness);
	populationInArrays = [newIndividuals populationInArrays];
	populationInArraysFitness = [newIndividualsFitenss populationInArraysFitness];
endfunction