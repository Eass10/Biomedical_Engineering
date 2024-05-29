function Fpts_sub = PossibleFixedPoints(Fpts, r_trial, r)
    % Establish a vector to save all possible Fixd Points    
    Fpts_sub = [];
    % Loop to verify the possible Fixed Points
    for k = 1:length(Fpts)
        % Attempt to compute Fixed Points for the r_trial
        try
            result = double(subs(Fpts(k), r, r_trial));  % Use double for evaluating in r_trial
            % If there is no error we add to the vector
            % We do not want complex numbers as fixed points thus we eliminate them
            if isreal(result) && ~any(abs(Fpts_sub - result) < eps)
                Fpts_sub = [Fpts_sub; result];
            end
        catch
            % If there is an error we continue with the following value
            continue;
        end
    end