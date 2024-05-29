clear; clc; close all
% Adding the path in order to use the requried function
addpath("C:\Users\enriq\OneDrive\Documentos\MATLAB\Microwave\Microwave\Funciones")
figure; hold on; grid on;
% Limit for our graph
xlim([-5 5]); ylim([-5 5]);
%% Dipole charges
% We call the DrawCharge function in order to create our dipole
[qs(1),rs(1,:)]=DrawCharge(1e-6, [1, 0, 0]); % Dipole positive charge
[qs(2),rs(2,:)]=DrawCharge(-1e-6, [-1, 0, 0]); % Dipole negative charge

%% Eclectric Field
% Loop used to iterate over 0 and 2pi (period of the cosine function)
for t=0:0.1:2*pi
    f=5; %frequency of the cosine
    % Charges (placed at the 'infinty') that produce the electric field
    qe(1)=-1; re(1,:)=[1000, 1000*cos(t*f), 0];
    qe(2)=1; re(2,:)=[-1000, -1000*cos(t*f), 0];

    % ELECTRIC FIELD
    % XY plane
    [X,Y] = meshgrid(linspace(-1,1,100),linspace(-1,1,100));
    % Z variable
    Z = zeros(size(X));
    % Matrix composed by X, Y, and Z
    R = [X(:) Y(:) Z(:)];
    % Null matrix of the size of R
    Et = zeros(size(R));
    % For loop to use the Superposition Principle in order to compute the field produced by the charges that are placed at the 'infinity'
    for i=1:length(qe)
        Et = Et + ElectricField(re(i,:),R,qe(i));
    end
    Ex = reshape(Et(:,1),size(X)); %coordinate x of the electric field vector
    Ey = reshape(Et(:,2), size(X)); %coordinate y of the electric field vector
    % Plot of the electric field vector
    field=streamslice(X,Y,Ex,Ey); axis tight
    % Norm of the electric field
    Et_norm = norm(Et);

    % Call the findobj function to find our dipole charges with respect their 'Marker'
    o=findobj(gca, 'Marker','.'); % Object that contains our two charges of the dipole
    TF=isempty(o); % For debug purposes (to see if our object is empty, which will mean that it did not find any charge)

    % Torque determines the magnitude of the movement. It basically
    % embodies the force that acts on both dipoles (which are opposite to
    % each dipole) and the dipole vector, in order to represent the
    % movement they would follow
    r=rs(1,:)-rs(2,:); r=r*qs(1); % Dipole vector (from the negative to the positive charge)
    T=cross(r, Et(1,:)); % Torque definition

    for j=1:100
        % New field is computed, which moves as a sinusoid
        r=[o(1).XData o(1).YData 0] - [o(2).XData o(2).YData 0]; r=r*qs(1);
        % As the torque (which determines the magnitued of the movement),
        % is decreasing as the charges align with the electric field vector
        T=cross(r, Et(1,:));
        direccion_avance=[r(2),-r(1), 0]; direccion_avance=direccion_avance/norm(direccion_avance); % Field direction
        % Charges update position: charges will move following the movement
        % of the field (which represents a cosine), always being the
        % positive the one that it separates from the electric field (esto
        % quiere decir que las flechas en el gráfico siempre apunten a la
        % carga positiva). We also see how the dipole charges align 
        o(1).XData=o(1).XData+T(3)*direccion_avance(1); o(1).YData=o(1).YData+T(3)*direccion_avance(2); o(1).ZData=0;
        o(2).XData=o(2).XData-T(3)*direccion_avance(1); o(2).YData=o(2).YData-T(3)*direccion_avance(2); o(2).ZData=0;
    end
    pause(0.00001)
    delete(field)
end