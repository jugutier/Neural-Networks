function [ out ] = genetic(operator, selectionMethod, replacementCriterion, replacementMethod, progenitorsNumber, finalizeCriterion, maxGenerations, individuals, mutationProbability)

# Arquitectura a utilizar: [4 3]
layers = [4 3];

# Initialize the population with random values
# Each individual is a matrix of weights (floats)
population = cell(individuals, 1);
for i = 1 : individuals
	population{i} = rand(5, 4); #Matriz de pesos para el individuo i
endfor


#Calculate the fitness for all the individuals in the population
fitnessAll = evaluateFitness(population);

#while (condicion de corte)
#	Seleccionar individuos para reproduccion
#	Recombinar individuos
#	Mutar individuos
#	evaluar fitness de los individuos obtenidos
#	generar nueva poblacion

while (!finalizeCriterion)
	individualsToReproduce = chooseIndividuals(population);
	newIndividuals = reproduceIndividuals(individualsToReproduce);
	newIndividuals = mutateIndividuals(newIndividuals);
	evaluateFitness(newIndividuals);
	population = generatePopulation(newIndividuals, evaluateFitness, population);
endwhile

endfunction


# Fitness function. Receives the population matrix and returns a new matrix with 
# the values of the fitness for each individual
function out = evaluateFitness(population) 
	individuals = (size(population))(1)
	for i = 1 : individuals
		out(i) =  1 / meanSquareError(population{i}); # How do we calculate the fitness for an individual
	endfor
endfunction

# Returns the mean square error for the weights matrix m
function e = meanSquareError(m)
	e = 2; #TODO: calculate error
endfunction