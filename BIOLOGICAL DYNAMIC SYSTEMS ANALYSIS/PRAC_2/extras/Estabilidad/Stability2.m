function [stable_Fpts, unstable_Fpts] = Stability2(fx, x)
    % Substitute the symbolic parameter by the trial in fx and in Fpts
    fx_sub = subs(fx,r,r_trial);
    
    % Establish a vector to save all possible Fixd Points
    Fpts_sub = sym([]);
    % Loop to verify the possible Fixed Points
    for i = 1:length(Fpts)
        % Attempt to compute Fixed Points for the r_trial
        try
            result = double(subs(Fpts(i), r, r_trial));  % Use double for evaluating in r_trial
            % If there is no error we add to the vector
            % We do not want complex numbers as fixed points thus we eliminate them
            if isreal(result) && ~any(abs(Fpts_sub - result) < eps)
                Fpts_sub = [Fpts_sub; subs(Fpts(i), r, r_trial)];
            end
        catch
            % If there is an error we continue with the following value
            continue;
        end
    end

    % Calculate the derivative of fx with respect to x
    fxd = diff(fx_sub, x);
    
    % Calculate the derivative at Fixed Points
    fxd_Fpts = subs(fxd, x, Fpts_sub);
    
    % Find stable and unstable Fixed Points
    stable_Fpts = Fpts(fxd_Fpts <= 0);
    unstable_Fpts = Fpts(fxd_Fpts >= 0);

    if isempty(stable_Fpts) && isempty(unstable_Fpts)
        disp('No Fixed Points');
    elseif ~isempty(stable_Fpts) && isempty(unstable_Fpts)
        disp('Only Stable Fixed Points:');
        disp(stable_Fpts);
    elseif isempty(stable_Fpts) && ~isempty(unstable_Fpts)
        disp('Only Unstable Fixed Points:');
        disp(unstable_Fpts);
    else
        disp('Stable Fixed Points:');
        disp(stable_Fpts);
        disp('Unstable Fixed Points:');
        disp(unstable_Fpts);
    end