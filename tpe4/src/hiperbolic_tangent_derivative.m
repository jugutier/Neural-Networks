function [ y ] = hiperbolic_tangent_derivative( x )

    beta = 0.5;

    y = beta*(1-(hiperbolic_tangent(x)).^2);

end