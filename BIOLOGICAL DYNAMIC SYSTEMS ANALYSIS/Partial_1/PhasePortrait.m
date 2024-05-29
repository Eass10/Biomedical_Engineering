function PhasePortrait(fx, Fpts, r_trial, r, x)
    % sets up the environment and prepares to create a phase portrait for a given dynamical system.

    % fx: This parameter represents the symbolic function that describes the dynamical system. 
    % It's a function of time t and state variable x, and it defines how the system evolves over time. The function is given in symbolic form.
    
    % Fpts: This parameter represents the symbolic expressions of the fixed points of the dynamical system.
    
    % These fixed points are where the derivative of the system is zero, and they play a crucial role in understanding the system's behavior.
    % r_trial: This parameter specifies a particular value of the parameter r for the dynamical system. 
    % The function will analyze the system's behavior for this specific value of r.
    
    % r: This parameter represents the parameter r in the dynamical system. 
    % It's a variable that can take different values, and r_trial specifies a particular value for this run.
    
    % x: This parameter represents the state variable of the system. 
    % It's a symbolic variable that represents the current state of the system. 


    % The output of the function is the generation of visual representations of the system's behavior, including:
        % A phase portrait that shows the behavior of the system over a specified range of x values. 
        % It includes the trajectory of the system, the direction of flow, and the locations of fixed points. This is displayed as a plot in a figure.

        % Plots of fixed points, with stable fixed points displayed as filled circles and unstable fixed points displayed as non-filled circles.

        % Possible trajectories of the system's state variable x(t) over a specified time range.
        
    syms t

    xi = -15; xf = 15;
    xsmp = 0:1 * exp(2):5;
    % Define the value of r for this zone

    % Define the function with the specific value of r for this zone
    fx_zone = subs(fx, {r, x}, {r_trial, x});
    
    % Compute the fixed points
    Fpts_zone = PossibleFixedPoints(Fpts, r_trial, r);

    dfx_zone = diff(fx_zone, x); % Get Derivative of fx respect to x
    dfx_Fpts_zone = subs(dfx_zone,x,Fpts_zone); % Calculate derivative at Fixed Points
    stb = Fpts_zone(dfx_Fpts_zone<0);   % Those Fixed Points with neg der
    nstb = Fpts_zone(dfx_Fpts_zone>=0); % Those Fixed Points with pos der

    t0 = 0; tf = 0.1; % initial and final time 0 1
    fN_lmb = matlabFunction(fx_zone,"Vars",[t,x]); % lambda function: Convert symbolic fx to ODE45 usable function
    y0 = -10:2:10; tspan = [t0,tf]; % initial points of PVI from xi to 2
    [ts,ys] = ode45(fN_lmb,tspan,y0); % for computing trajectories

    % Code to represent the phase portrait in this zone
    figure; hold on; grid on;
    plot(xsmp, zeros(size(xsmp)), 'k');
    fplot(fx_zone, [xi, xf], 'b');

    % Plot filled circles fot stable fixed points
    plot(stb,zeros(size(stb)),'o','MarkerFaceColor','r')

    % Plot non-circles for stable fixed points
    plot(nstb,zeros(size(nstb)),'ro');
    
    % Create a list of fixed points by combining stable and unstable points
    % Draw arrows for stable points
    % Define reference points as the fixed points
    reference_points = sort(Fpts_zone);
    
    % Initialize a structure to store information about the regions
    regions = struct('start', {}, 'end', {}, 'direction', {});
    
    % Initialize the current region with the first reference point
    if length(reference_points) > 1
        current_region = struct('start', reference_points(1)-10, 'end', reference_points(1), 'direction', []);
    elseif length(reference_points) == 1
        current_region = struct('start', reference_points-10, 'end', reference_points, 'direction', []);
    else
        current_region = struct('start', subs(fx_zone, x, -10), 'end', subs(fx_zone, x, 10), 'direction', sign(subs(fx_zone, x, 0)));
    end
    
    % Evaluate the flow direction in each region
    for i = 1:length(reference_points)
        current_region.direction = sign(subs(fx_zone, x, current_region.start+0.1));
        regions = [regions, current_region];
        
        % Update the current region for the next iteration
        if i < length(reference_points)
            current_region = struct('start', reference_points(i), 'end', reference_points(i+1), 'direction', []);
        else
            % Last region, consider the direction based on the last fixed point
            current_region = struct('start', reference_points(i), 'end', reference_points(i) + 10, 'direction', []);
            current_region.direction = sign(subs(fx_zone, x, current_region.start+0.1));
            regions = [regions, current_region];
        end
    end
    
    % Now, 'regions' contains information about the regions and their directions
    % You can use this information to represent the flow direction arrows in the phase portrait.

    % Code to represent the phase portrait in this zone
    for k = 1:length(regions)
        if regions(k).direction > 0
            % Flow direction to the right (>)
            plot((regions(k).start+regions(k).end)/2, 0, 'g>', 'MarkerSize', 8);
        else
            % Flow direction to the left (<)
            plot((regions(k).start+regions(k).end)/2, 0, 'm<', 'MarkerSize', 8);
        end
        if k > 1
            % FLAG: Case where a Mixed Fixed Point appears
            if regions(k).direction == regions(k-1).direction
                fprintf('There is a Mixed Fixed Point at x = %d', r_trial);
                fprintf('I know it seems to be an unstable as it is drawn as one, but i did not know how to fill half of it to make it Mixed. If you have any improve please tell me.')
            end
        end
    end

    xlabel('x'); ylabel('dx'); grid on;
    title('Phase Portrait for r = ' + string(r_trial));
    hold off

    % Code to represent the possible trajectories of x(t) in this zone
    figure;hold on;
    plot(ts,ys); plot(0,y0,'o','MarkerFaceColor','g');
    axis([t0,tf,xi,xf])
    xlabel('t');ylabel('y(t)');grid on; title('plot')
end
