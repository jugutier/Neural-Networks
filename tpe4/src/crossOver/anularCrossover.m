function progenitors = anularCrossover(individual1, individual2)
		r = rand() * length(individual1) + 0;
		l = rand() * length(individual1) / 2 + 1;
		i = 0;
		while(i < length(individual2) && i < r)
			son1(i) = individual1(i);
			son2(i) = individual2(i);
			i++;
		endwhile
		i=0;
		while(i < individual2.length && i < (r + l))
			son2(i) = individual2(i);
			son1(i) = individual1(i);
			i++;
		endwhile
		%% Start at beginning
		if (length(individual1) - (r+l) < 0 ) 
			i=0;
			while(i < ((r+l) - length(individual1)))
				son2(i) = individual2(i);
				son1(i) = individual1(i);
				i++;
			endwhile
		endif
		progenitors{1} = son1;
		progenitors{2} = son2;
endfunction