function run()
	##ACTIVATION FUNCTIONS
	load hiperbolic_tangent.m
	load hiperbolic_tangent_derivative.m
	##we will use built in exp for the exponencial
	load expo_derivative.m

	load part1_multilayer_simetry.m
	load data_import.m


	filename=0;
	g=0;
	g_derivative=0;

	printf("Welcome to the neural network assistant\n");
	if(yes_or_no("Do you already have a trained neural network?\n"))
		filename = input("What is the filename? (with extension, please)\n");
	else
			hiddenUnitsPerLvl = input("Type a a vector for hidden units per level.\n \
eg. [2 3] will build a neural network \nwith two units in the first level and 3 in the second one.\
	 \n(Note that input nodes and outputnodes depend only on the data provided.)\n");
	endif

	trainPercentage = input("Type a number between 0.0 and 1.0 for a train percentage.\n\
(Note that the compliment will be used for testing.)");
	data = data_import('samples8norm.csv' , trainPercentage);
	resp=input("Which activation function? \n1 -Tangent\n2 -Exponencial\n");
	switch(resp)
		case 1
			part1_multilayer_simetry( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@hiperbolic_tangent,@hiperbolic_tangent_derivative,filename);
		case 2
			part1_multilayer_simetry( data(:,[1 2]),data(:,3),hiddenUnitsPerLvl,@exp,@expo_derivative,filename);
		otherwise
			disp("error, please try again")
	endswitch


	
	

endfunction