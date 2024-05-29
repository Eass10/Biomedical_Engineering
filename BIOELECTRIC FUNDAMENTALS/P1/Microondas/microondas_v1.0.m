
clear; clc; close all;
figure; hold on; grid on; 

[r1,q1]=drawCharge([3, 3,0], 10e-6); [q2,r2]=drawCharge([1, 1,0],-10e-6);
[r_pos,q_pos]=drawCharge([1000, 1000, 0], 1); 
[r_neg,q_neg]=drawCharge([-1000, -1000, 0], -1);  

obj=findobj('Marker','.'); obj(1).Color=[0 0 0]; 
module_E= norm(electricField(r_pos,r_neg,q_pos));

xlim([0 4])
ylim([0 4])

t = linspace(0,1,50); 
f = 2.5; 
c = cos (2*pi*f*t); 
o = zeros(length(c));


for i = 1:100
    direction_E = [t(i) c(i) o(i)]/norm([t(i) c(i) o(i)]); 
    E = module_E *direction_E;
    for k = -5:0.5:5
        quiver(0, k, 4*direction_E(1), 4*direction_E(2),'Color',[0 0 0]/255)
    end
    for j = 1:100
        r1=[obj(4).XData obj(4).YData 0];
        r2=[obj(3).XData obj(3).YData 0];
        m = q1*(r1-r2); 
        torq = cross(m,E);
        tan = [-m(2) m(1) 0]/norm([-m(2) m(1) 0]);
        
        
        obj(4).XData= r1(1) + torq(3)*tan(1);
        obj(4).YData= r1(2) + torq(3)*tan(2);
        obj(3).XData= r2(1) - torq(3)*tan(1);
        obj(3).YData= r2(2) - torq(3)*tan(2);
        pause(10e-15)
      
        
    end
end




%Funtion to create a dipole.
function [pos,val]=drawCharge(position,value)
val=value; pos=position;
if nargin<1 || isempty(val) 
    val=sign(rand-0.3)*(5*rand+1)*1e-6;
end    

if nargin<2 || isempty(pos) 
    pos=[2*(rand-0.5) 2*(rand-0.3) 0];
end

colores={[255,87,51]/255,[93,173,226]/255}; 

if val>0 
    plot3(pos(1),pos(2),pos(3),'.','MarkerSize',30,'Color', [255 87 51]/255); 
else 
    plot3(pos(1),pos(2),pos(3),'.','MarkerSize',30,'Color', [93 173 226]/255); 
end
end

%Function to create the electric field.
function E=electricField(ri,R,qi)
r =sqrt(sum((R-ri).^2,2));  % Distance in the direction ri to rt
u = (R-ri)./r; % Unitary vector of distance in Cartesian coordinates
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;   % Coulomb constant (Nm^2/C^2)
E = ke*qi./r.^2 .* u;  % Electric field (E)
end