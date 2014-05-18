function [ y ] = expo( x )

    beta = 2;

    y = 1/(1+exp(-2*beta*x));

end