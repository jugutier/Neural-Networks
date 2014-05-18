function [ y ] = expo_derivative( x )

    beta = 2;

    y = 2*beta*expo(x)*(1-expo(x));

end