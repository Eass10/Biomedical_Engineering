function [t, xsol] = MyEuler(x0, t0, tf, nPts, f)
    % MyEuler: Solve a differential equation using Euler's method.
    % Input:
    %   - x0: Initial Condition at t(0)
    %   - t0: Initial time
    %   - tf: End time
    %   - nPts: Number of points
    %   - f: Symbolic function representing the derivative of x with respect to t
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

    % Implement Euler's method to approximate the solution
    for k = 1:nPts - 1
        xsol(k + 1) = xsol(k) + f(xsol(k)) * delta;
    end
end
