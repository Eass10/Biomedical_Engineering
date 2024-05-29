%% Microondas a partir de un campo eléctrico
clear; clc; close all;
figure; hold on; grid on; 


p_charge = 10e-6;
q = 1;
% Amplitud de onda
t = linspace(0, 1 ,100);
f = 2;


prot = drawdipole([1 1 0]);
elec = drawdipole([-1 -1 0]);
d = sqrt(prot(1)^2+elec(1)^2);
check = true;
E_F = EF(d,q);
c = cos(2*pi*f*t);
E_m = norm(E_F);
o = zeros(length(c));
while check == true
    for i = 1:100
        E_d = [t(i) c(i) o(i)]/norm([t(i) c(i) o(i)]); 
        E = E_m*E_d;
        p = quiver(0,0,E_d(1), E_d(2)); 
        for j = 1:100
            p_v = p_charge*(prot-elec); 
            torq = cross(p_v,E);
            tangent = [-p_v(2) p_v(1) 0]/norm([-p_v(2) p_v(1) 0]);


            prot(1)= prot(1) + torq(3)*tangent(1);
            prot(2)= prot(2) + torq(3)*tangent(2);
            elec(1)= elec(1) - torq(3)*tangent(1);
            elec(2)= elec(2) - torq(3)*tangent(2);
            pause(10e-6)

            if norm(torq(3))< 0.0005 
                delete(p);
                break
            end
        end

    end
end
