function normalize(Filename)
	CSV = dlmread(Filename, ',');
	for i=1:rows(CSV)
		if CSV(i,:) != 0
			CSV(i,:) =  CSV(i,:) / norm(CSV(i,:))
		endif
	endfor
	name = strsplit(Filename,".");
	finalName = strcat(name{1},"norm.csv");
	dlmwrite(finalName,CSV);
endfunction