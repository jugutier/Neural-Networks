function patterns = normalizeZeroOne(Patterns)
	maxZ = max(Patterns(:,3));
	minZ = min(Patterns(:,3));
	difZ = maxZ - minZ;

	for i=1:rows(CSV)
		if (difZ != 0)
			a = Patterns(i,:) .- minZ;
		 	patterns(i,:) = a/difZ;
		endif
	endfor
endfunction