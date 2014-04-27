function normalizeZeroOne(Filename)
	CSV = dlmread(Filename, ',');

	maxZ = max(CSV(:,3));
	minZ = min(CSV(:,3));
	difZ = maxZ - minZ;

	for i=1:rows(CSV)
		if (difZ != 0)
			a = CSV(i,:) .- minZ;
		 	CSV(i,:) = a/difZ;
		endif
	endfor
	name = strsplit(Filename,".");
	finalName = strcat(name{1},"normZeroOne.csv");
	dlmwrite(finalName,CSV);
endfunction