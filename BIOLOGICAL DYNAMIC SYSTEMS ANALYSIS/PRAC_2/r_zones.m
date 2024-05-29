function z_r_trial = r_zones(r_values, rValues, n_fpts)
    zones = [];
    % Iterar sobre r_values para imprimir zonas
    for k = 1:(length(r_values))
        r_start = round(r_values(k));
        if k < length(r_values)
            r_end = round(r_values(k + 1));
        else
            r_end = round(rValues(end));
        end
        zones = [zones; [r_start, r_end]];
        fprintf('Zona %d: %.2f <= r <= %.2f, el número de puntos fijos es %d\n', k, r_start, r_end, n_fpts(k));
    end

    % Calcular un valor de r para cada zona
    z_r_values = zeros(size(zones, 1), 1);
    
    % Calcular los puntos de bifurcación
    bifurcation_points = [];
    
    for i = 1:size(zones, 1)
        lower_bound = zones(i, 1);
        upper_bound = zones(i, 2);
        z_r_values(i) = (lower_bound + upper_bound) / 2;
        
        % Agregar los puntos de bifurcación, excepto en la última zona
        if i < size(zones, 1) && ~any(bifurcation_points == upper_bound)
            bifurcation_points = [bifurcation_points, upper_bound];
        end
    end
    
    % Mostrar los valores de r
    fprintf('Valores de r representativos para cada zona:\n');
    disp(z_r_values);
    
    % Mostrar los puntos de bifurcación
    fprintf('Puntos de bifurcación:\n');
    disp(bifurcation_points);
    
    % Unir las dos listas y eliminar duplicados
    combined_values = unique([z_r_values(:); bifurcation_points(:)]);
    
    % Ordenar los valores en orden ascendente
    z_r_trial = sort(combined_values);