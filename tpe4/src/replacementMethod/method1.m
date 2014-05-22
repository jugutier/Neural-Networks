function [populationInArrays  populationInArraysFitness indexes]= method1(newIndividuals,newIndividualsFitenss,individualsToReproduce,individualsToReproduceFitness, populationInArrays , populationInArraysFitness);
	indexes = 1:length(newIndividuals);
	populationInArrays = [newIndividuals populationInArrays'];
	populationInArraysFitness = [newIndividualsFitenss populationInArraysFitness];
endfunction