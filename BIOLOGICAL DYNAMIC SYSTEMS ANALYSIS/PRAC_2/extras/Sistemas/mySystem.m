function dxdt = mySystem(t, x, r)
    % Define tu sistema dinámico aquí
    dxdt = r * x - x^3;
end
