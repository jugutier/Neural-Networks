function [ y ] = g_derivative( x )

    beta = 0.5;

    y = beta*(1-(g(x)).^2);

end