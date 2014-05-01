function patterns =  normalizeOneOne(Patterns)
	for i=1:rows(Patterns)
		if Patterns(i,:) != 0
			patterns(i,:) =  Patterns(i,:) / norm(Patterns(i,:));
		endif
	endfor
endfunction