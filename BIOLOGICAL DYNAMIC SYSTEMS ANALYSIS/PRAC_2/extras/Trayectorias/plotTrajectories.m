    function plotTrajectories(fx)
    % r_values es un vector que contiene los valores de r a analizar

    % Crear un vector de valores de x
    x = linspace(-1, 1, 100);

    for r_trial = linspace(-10, 10, 20)
        % Calcular y para el valor actual de r
        y = subs(r, r_trial, fx);

        % Encontrar los puntos fijos estables e inestables
        Fpts1 = solve(fx);

        fxd = diff(fx, t);
        fxd_Fpts = subs(fxd, t, Fpts1);
        stb = double(Fpts1(fxd_Fpts < 0));
        nstb = double(Fpts1(fxd_Fpts > 0));

        % Dibujar el diagrama de bifurcación
        xi = -3; xf = 3;
        xsmp = xi:1e-2:xf;
        plot(xsmp, zeros(size(xsmp)), 'k');
        hold on;
        fplot(fx, [xi, xf], 'b');
        plot(stb, zeros(size(stb)), 'o', 'MarkerFaceColor', 'r');
        plot(nstb, zeros(size(nstb)), 'ro');
        xsmp_r = xsmp(subs(fx, t, xsmp) > 0);
        xsmp_l = xsmp(subs(fx, t, xsmp) < 0);
        plot(xsmp_r, zeros(size(xsmp_r)), 'g');
        plot(xsmp_l, zeros(size(xsmp_l)), 'm');
        hold off;

        title(['Bifurcation Diagram for r = ', num2str(r)]);
        xlabel('X');
        ylabel('Y');
        grid on;
        pause(1);  % Pausa para ver cada bifurcación
    end
end
