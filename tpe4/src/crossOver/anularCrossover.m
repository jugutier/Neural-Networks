function progenitors = anularCrossover(individual1, individual2)
	r = floor(rand() * length(individual1));
	l = floor(rand() * length(individual1) / 2 + 1);
	
	i = 1;
	while(i < length(individual2) && i < r)
		son1(i) = individual1(i);
		son2(i) = individual2(i);
		i++;
	endwhile

	while(i < length(individual2) && i < (r + l))
		son1(i) = individual2(i);
		son2(i) = individual1(i);
		i++;
	endwhile
	
	%if (length(individual1) - (l+r) < 0 ) 
		%while(i < ((l+r) - length(individual1)))
		while(i <= length(individual1))
			son2(i) = individual2(i);
			son1(i) = individual1(i);
			i++;
		endwhile
	%endif

	progenitors{1} = son1;
	progenitors{2} = son2;
endfunction