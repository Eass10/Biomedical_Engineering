clear; clc; close all
addpath("C:\Users\enriq\OneDrive\Documentos\MATLAB\Microwave\Microwave\Funciones")
figure; hold on; grid on;

%% Dipole charges
[qs(1),rs(1,:)]=DrawCharge(1e-6, [1, 0, 0]); % Carga positiva del dipolo
[qs(2),rs(2,:)]=DrawCharge(-1e-6, [-1, 0, 0]); % Cargar negativa del dipolo7

%% Eclectric Field
%Charges producing the electric field
qe(1)=-100; re(1,:)=[1000, 1000, 0];
qe(2)=100; re(2,:)=[-1000, -1000, 0];
% XY plane
[X,Y] = meshgrid(linspace(-1,1,100),linspace(-1,1,100));
% Z variable
Z = zeros(size(X));
% Matrix composed by X, Y, and Z
R = [X(:) Y(:) Z(:)];
% Null matrix of the size of R
Et = zeros(size(R));
% Superposition Principle in order to compute the field produced by the charges that are placed at 'the infinity'
for i=1:length(qe)
    Et = Et + ElectricField(re(i,:),R,qe(i));
end
%Ex = reshape(Et(:,1),size(X));
%Ey = reshape(Et(:,2), size(X));
%streamslice(X,Y,Ex,Ey); axis tight
Et_norm = norm(Et);

%% Microwave
o=findobj(gca, 'Marker','.'); % Object that contains our two charges of the dipole
TF=isempty(o);
t=linspace(-1,1,100);
f=5;
cosine=cos(2*pi*f*t);
%plot(t, cosine)
derivada = diff(cosine);
%plot(t, derivada)
n=zeros(length(cosine));
xlim([-1 1])
ylim([-1 1])

for i=1:length(derivada)
    % New field is computed, which moves as a sinusoid
    %Et_vector=[1 1 0]; Et_vector=Et_vector/norm(Et_vector);
    %Et_new=derivada(i)*Et; Et_new=Et_new(1:100,:);
    Et_new=Et*derivada(i);
    Et_new_x=reshape(Et_new(:,1), size(X));
    Et_new_y=reshape(Et_new(:,2), size(X));
    flechas=streamslice(X,Y,Et_new_x,Et_new_y); axis tight; hold on
    %flechas=quiver(0,0,Et_new(1),Et_new(2));
    if TF == 0
        for j=1:length(derivada)
            r=rs(1,:)-rs(2,:); % Dipole vector, from the negative to the positive charge
            direccion_avance=*[r(2),-r(1), 0]; direccion_avance=direccion_avance/norm(direccion_avance); % Field direction
            T=cross(r*qs(2), Et_new(1,:)); % Torque
            o(1).XData=rs(1,1)+T(3)*direccion_avance(1); o(1).YData=rs(1,2)+T(3)*direccion_avance(2); o(1).ZData=0;
            o(2).XData=rs(2,1)-T(3)*direccion_avance(1); o(2).YData=rs(2,2)-T(3)*direccion_avance(2); o(2).ZData=0;
        end
    end
    
    pause(0.1)
end

