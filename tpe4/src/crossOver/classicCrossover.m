% CLASSIC == SINGLE POINT
function out = classicCrossover(individual1, individual2)
	individualsSize = size(individual1)(2);
	locus = floor(rand() * individualsSize + 1);
	desc1 = [];
	desc2 = [];
	for i = 1 : locus-1
		desc1 = [desc1 individual1(i)];
		desc2 = [desc2 individual2(i)];
	endfor
	for i = locus : individualsSize
		desc1 = [desc1 individual2(i)];
		desc2 = [desc2 individual1(i)];
	endfor
	out{1} = desc1;
	out{2} = desc2;
end