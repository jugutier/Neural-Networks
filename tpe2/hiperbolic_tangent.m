function [ y ] = hiperbolic_tangent( x )

    beta = 0.5;

    y = tanh(beta * x);
    
end