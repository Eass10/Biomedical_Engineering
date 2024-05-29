function [unstable_x_values] = bifurcation_diagram(fx, dfx)
    % Define range for r and initial guesses for fixed points
    r_values = linspace(-10, 10, 500);
    x_init_values = [];
    stable_x_values = [];
    unstable_x_values = [];
    r_stable = [];
    r_unstable = [];
    % Loop over all r values
    for rValue = r_values
        fx_current = @(x) fx(rValue, x);
        Fpts1 = [];
        for initVal = x_init_values
            try
                Fpts1 = [Fpts1, fzero(fx_current, initVal)];
            catch
                continue;
            end
        end
        fxd_Fpts = dfx(rValue, Fpts1);
        stb_pts = Fpts1(fxd_Fpts < 0);
        nstb_pts = Fpts1(fxd_Fpts > 0);
        stable_x_values = [stable_x_values, stb_pts];
        unstable_x_values = [unstable_x_values, nstb_pts];
        r_stable = [r_stable, rValue*ones(1, length(stb_pts))];
        r_unstable = [r_unstable, rValue*ones(1, length(nstb_pts))];
    end
    % Plot bifurcation diagram
    figure('Name', 'Bifurcation Diagram', 'NumberTitle', 'off');
    plot(r_stable, stable_x_values, 'b.', 'DisplayName', 'Stable');
    hold on;
    plot(r_unstable, unstable_x_values, 'r.', 'DisplayName', 'Unstable');
    title('Bifurcation Diagram');
    xlabel('r');
    ylabel('x');
    legend;
    hold off;
end