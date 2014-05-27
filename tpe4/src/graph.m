function graph(train,test)
	clf;hold on;
	xtrain = train(:,1);
	ytrain = train(:,2);
	ztrain = train(:,3);

	xtest = test(:,1);
	ytest = test(:,2);
	ztest = test(:,3);
	%figure(1);
	%plot3(xtrain,ytrain,ztrain,'ob');
	%figure(2);
	plot3(xtest,ytest,ztest,'*r');
	set (gca, "box", "off");
endfunction