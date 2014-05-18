function CurrentWValues = part1-multilayer(Method, InternalLayers, NeuronsPerLayer)
  %%%%---------- CONSTANTS AND INPUT DEFINITION ----------%%%%
  %% TestPatterns: The first column is the value of the threshold
  TestPatterns = [-1 1 1; -1 1 -1; -1 -1 1; -1 -1 -1];
  ExpectedAns = [1; 1; 1; -1];
  %% 1st step of the algorithm
  %% CurrentWValues: First column is the weight for the threshold connection
  CurrentWValues = rand(3,6);
  InternalLayers = 1;
  NeuronsPerLayer = 2;
  %%ETA: Random value around the input values
  ETA = 0.5; 
  %%%%---------- END CONSTANTS AND INPUT DEFINITION ----------%%%%

  %% 2nd step of the algorithm
  %% Apply the pattern
  for i = 1: rows(TestPattern)
    V0_k = TestPattern(i,:);
    Vi_m = propagate(V0_k);
  endfor

  hasLearnt = 0; 
  disp("Initial Ws: "), CurrentWValues
  while ( hasLearnt != 1 )
    hasLearnt = 1;
    for i = 1 : rows(TestPattern)
        CurrentPattern = TestPattern(i,:);
        gValu e = g(CurrentPattern,  CurrentWValues, Method);
        gValue
        disp("Expected: "),ExpectedAns(i)
        if ( gValue != ExpectedAns(i) )
            CurrentWValues = correct(CurrentPattern, CurrentWValues,  ExpectedAns(i));
            hasLearnt = 0;
            break;
        endif
    endfor
  endwhile 

endfunction

function out = propagate(Vi_m)
  out = g()
endfunction

%%%% Funcion de transferencia ()
function value = g(CurrentPattern, currentWValues, Method)
        accum = 0;
        disp("Calculate g")
        CurrentPattern
        currentWValues
        for i = 1 : columns(CurrentPattern)
            accum = accum + CurrentPattern(i) * currentWValues(i);
        endfor
        % Apply th
        if (Method == 0) % Escalon
          if (accum >= 0)
            value = 1;
          else
            value = -1;
          endif
        elseif (Method == 1) % Sigmoidea
          value = 1 / (1 + exp(-accum/1)); % El 1 denominador de accum es la "amplitud" en x de la funcion.
        elseif(Method == 2) % Lineal
            value = accum;
        endif
endfunction
 
function W = correct(CurrentPattern, CurrentWValues, CurrentExpectedAns)
        disp("Correcting")
        Wold = CurrentWValues
        S = CurrentExpectedAns
        xi = CurrentPattern
        ETA = 0.5;

        W = Wold + 2 * ETA * S * xi'
 
endfunction