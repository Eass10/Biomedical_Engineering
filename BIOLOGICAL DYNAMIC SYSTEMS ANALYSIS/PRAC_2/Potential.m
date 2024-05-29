function Potential(fx, r_trial, r, x)
    syms V(x)

    % Define the differential equation
    pot = -diff(V, x) == fx;
    
    % Solve the differential equation
    V_sol = dsolve(pot, V(0)==0);
    
    % Create a range of x values for plotting
    x_values = linspace(-5, 5, 1000);
        
    % Substitute the trial value of 'r'
    V_trial = subs(V_sol, r, r_trial);
    
    % Convert the symbolic solution to a function for numerical evaluation
    V_function = matlabFunction(V_trial, 'Vars', x);
    
    % Calculate V(x) for the given 'r'
    V_values = V_function(x_values);
    
    % Create a new figure for each iteration
    figure;
    plot(x_values, V_values);
    title('V(x) for r = ' + string(r_trial));
    xlabel('x');
    ylabel('V(x)');
    grid on;