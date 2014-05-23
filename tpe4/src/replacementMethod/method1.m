function [populationInArrays  populationInArraysFitness]= method1(newIndividuals,newIndividualsFitenss,individualsToReproduce,individualsToReproduceFitness, populationInArrays , populationInArraysFitness)
	populationInArrays = [newIndividuals' populationInArrays]';
	populationInArraysFitness = [newIndividualsFitenss populationInArraysFitness];
endfunction