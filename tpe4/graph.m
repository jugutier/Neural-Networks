function graph(train,test)
	xtrain = train(:,1);
	ytrain = train(:,2);
	ztrain = train(:,3);

	xtest = test(:,1);
	ytest = test(:,2);
	ztest = test(:,3);

	plot3(xtrain,ytrain,ztrain,".b");
	hold on;
	plot3(xtest,ytest,ztest,"*r");
	set (gca, "box", "off");
endfunction