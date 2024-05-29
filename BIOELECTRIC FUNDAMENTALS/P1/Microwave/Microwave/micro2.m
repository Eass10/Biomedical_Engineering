clear; clc; close all
addpath("C:\Users\enriq\OneDrive\Documentos\MATLAB\Microwave\Microwave\Funciones")
% Two loads and one test are created and displayed
figure; hold on; grid on;
%[qs(1),rs(1,:)]=DrawCharge(1e-6, [1, 0, 0]); % Carga positiva del dipolo
%[qs(2),rs(2,:)]=DrawCharge(-1e-6, [-1, 0, 0]); % Cargar negativa del dipolo
qe(1)=-10; re(1,:)=[1000, 1000, 0];
qe(2)=10; re(2,:)=[-1000, -1000, 0];

[X,Y] = meshgrid(linspace(-1,1,100),linspace(-1,1,100)); % XY plane
d = 0; % Distance from the charges to the XY plane
Z = d*ones(size(X));
R = [X(:) Y(:) Z(:)];  
Et = zeros(size(R));
for i=1:length(qe)
    Et = Et + ElectricField(re(i,:),R,qe(i));
end
Ex = reshape(Et(:,1),size(X));
Ey = reshape(Et(:,2), size(X));
%streamslice(X,Y,Ex,Ey); axis tight

rs=[1 0 0; -1 0 0];
numero_vueltas=0;
exit=true;
i=1;
while exit
    i=i+5;
    numero_vueltas=numero_vueltas+1;
    Ex=reshape(Et(:,1), size(X))*cos(i/(10*pi));
    Ey=reshape(Et(:,2), size(X))*sin(i/(10*pi));
    Ez=reshape(Et(:,3), size(X));
    Et_new=[Ex(:,1), Ey(:,1), Ez(:,1)];
    streamslice(X,Y,Ex,Ey); axis tight; pause(0); hold on
    [qs(1),rs(1,:)]=DrawCharge(1e-6, rs(1,:));
    [qs(2),rs(2,:)]=DrawCharge(-1e-6, rs(2,:));
    r=rs(1,:)-rs(2,:); % va de la carga negativa a la positiva
    P=r*qs(1);
    T=cross(P,Et_new(1,:));
    o=findobj(gca, 'Marker','.');
    TF = isempty(o);
    if TF == 0
        while norm(T)>1e-6
            r=rs(1,:)-rs(2,:);
            direccion_avance=[r(2),-r(1), 0]; direccion_avance=direccion_avance/norm(direccion_avance);
            T=cross(r*qs(2), Et_new(1,:));
            o(1).XData=rs(1,1)+T(3)*direccion_avance(1); o(1).YData=rs(1,2)+T(3)*direccion_avance(2); o(1).ZData=0;
            o(2).XData=rs(2,1)-T(3)*direccion_avance(1); o(2).YData=rs(2,2)-T(3)*direccion_avance(2); o(2).ZData=0;
            rs(1,1)=o(1).XData
            rs(1,2)=o(1).YData
            rs(2,1)=o(2).XData
            rs(2,2)=o(2).YData
            axis equal; xlabel('x (m)'), ylabel('y (m)');
            drawnow, pause(0), view(0,90)
        end
        %[qs(1),rs(1,:)]=DrawCharge(1e-6, rs(1,:)); 
        %[qs(2),rs(2,:)]=DrawCharge(-1e-6, rs(2,:));
    end
    
    if numero_vueltas == 100
        break
    end
    hold off
    plot(0,0)
end