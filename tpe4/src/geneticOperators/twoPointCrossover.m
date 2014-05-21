% TWO POINT where locus1 < locus2
function out = twoPointCrossover(individual1, individual2)
	individualsSize = size(individual1)(2);
	locus1 = randi([1 individualsSize-1],1);
	locus2 = randi([locus1+1 individualsSize],1);
	desc1 = [];
	desc2 = [];
	for i = 1 : locus1 - 1
		desc1 = [desc1 individual1(i)];
		desc2 = [desc2 individual2(i)];
	endfor
	for i = locus1 : (locus1 + locus2)
		desc1 = [desc1 individual2(i)];
		desc2 = [desc2 individual1(i)];
	endfor
	for i = (locus1 + locus2 + 1) : individualsSize
		desc1 = [desc1 individual1(i)];
		desc2 = [desc2 individual2(i)];
	endfor		
	out{1} = desc1;
	out{2} = desc2;
end