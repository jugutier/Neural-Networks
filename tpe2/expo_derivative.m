function [ y ] = expo_derivative( x )

    beta = 2;

    y = 2*beta*exp(x)*(1-exp(x));

end