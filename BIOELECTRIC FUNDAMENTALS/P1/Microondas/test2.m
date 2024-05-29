
clear; clc; close all;
figure; hold on; grid on; 

[q0,r0]=drawCharge(10e-6,[-1,1,0]); 
[q1,r1]=drawCharge(-10e-6,[1,-1,0]); 
[qa,ra]=drawCharge(1 ,[1000, 1000, 0]); 
[qb,rb]=drawCharge(-1 ,[-1000, -1000, 0]);  

o=findobj('Marker','.'); 
o(1).Color=[0 0 0]; 
module_E= norm(electricField(ra,rb,qa));

xlim([-5 5])
ylim([-5 5])

time = linspace(0,1,100); 
frec = 10; 
cosen = cos (2*pi*frec*time); 
cero = zeros(length(cosen));


for i = 1:100
    direction_E = [time(i) cosen(i) cero(i)]/norm([time(i) cosen(i) cero(i)]); 
    E = module_E *direction_E;
    [x,y] = meshgrid(0:0.01:3,0:0.01:3);
    u = cos(x+pi/6);
    v = cos(x+pi/6);
    p = quiver(u*direction_E(1), v*direction_E(2)); 
    for i = 1:100
        r0=[o(4).XData o(4).YData 0];
        r1=[o(3).XData o(3).YData 0];
        Moment = q0*(r0-r1); 
        torque = cross(Moment,E);
        tangent = [-Moment(2) Moment(1) 0]/norm([-Moment(2) Moment(1) 0]);
        
        
        o(4).XData= r0(1) + torque(3)*tangent(1);
        o(4).YData= r0(2) + torque(3)*tangent(2);
        o(3).XData= r1(1) - torque(3)*tangent(1);
        o(3).YData= r1(2) - torque(3)*tangent(2);
        pause(10e-6)
      
        if norm(torque(3))< 0.0005 
            delete(p);
            break
        end
    end

end


%Funtion to create a dipole.
function [charge,r]=drawCharge(value,position)
charge=value; r=position;
if nargin<1 || isempty(value) 
    value=sign(rand-0.3)*(5*rand+1)*1e-6;
end    

if nargin<2 || isempty(position) 
    position=[2*(rand-0.5) 2*(rand-0.3) 0];
end

colores={[255,87,51]/255,[93,173,226]/255}; 

if charge>0; 
    c=1; 
else; 
    c=2; 
end
plot3(r(1),r(2),r(3),'.','MarkerSize',30,'Color',colores{c}); 
text(r(1)+0.03,r(2)+0.03,r(3)+0.03,[num2str(charge*1e6,'%.2f'),' \muC']);

end

%Function to create the electric field.
function E=electricField(ri,R,qi)
r =sqrt(sum((R-ri).^2,2));  % Distance in the direction ri to rt
u = (R-ri)./r; % Unitary vector of distance in Cartesian coordinates
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;   % Coulomb constant (Nm^2/C^2)
E = ke*qi./r.^2 .* u;  % Electric field (E)
end