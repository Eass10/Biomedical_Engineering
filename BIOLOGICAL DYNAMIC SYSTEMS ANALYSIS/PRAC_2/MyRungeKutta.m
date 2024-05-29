function [t, xsol] = MyRungeKutta(x0, t0, tf, nPts, f)
    % MyRungeKutta: Solve a differential equation using the Runge-Kutta method.
    % Input:
    %   - x0: Initial Condition at t(0)
    %   - t0: Initial time
    %   - tf: End time
    %   - nPts: Number of points
    %   - f: Symbolic function representing the derivative
    % Output:
    %   - t: Array of time values
    %   - xsol: Array of solution values at corresponding time points

    % Create a time vector with evenly spaced points
    t = linspace(t0, tf, nPts);

    % Initialize the solution array with zeros
    xsol = zeros(size(t));

    % Set the initial condition
    xsol(1) = x0;

    % Calculate the time step
    delta = (tf - t0) / (nPts - 1);

    % Run the Runge-Kutta method to approximate the solution
    for n = 1:nPts - 1
        k1 = f(xsol(n)) * delta;
        k2 = f(xsol(n) + 0.5 * k1) * delta;
        k3 = f(xsol(n) + 0.5 * k2) * delta;
        k4 = f(xsol(n) + k3) * delta;

        % Update the solution using the weighted sum of the k values
        xsol(n + 1) = xsol(n) + (1/6) * (k1 + 2*k2 + 2*k3 + k4);
    end
end
