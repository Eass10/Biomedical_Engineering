
clear; clc; close all;
figure; hold on; grid on; 

[q0,r0]=drawCharge(10e-6,[1,3,0]); 
[q1,r1]=drawCharge(-10e-6,[3,1,0]); 
[qa,ra]=drawCharge(1 ,[1000, 1000, 0]); 
[qb,rb]=drawCharge(-1 ,[-1000, -1000, 0]);  

o=findobj('Marker','.');
o(1).Color=[0 0 0]; 
module_E= norm(electricField(ra,rb,qa));

xlim([0 4])
ylim([0 4])

time = linspace(0,1,100); 
frec = 5; 
cosen = cos (2*pi*frec*time); 
cero = zeros(length(cosen));
[x,y] = meshgrid(0:0.1:1,0:0.1:1);
u = cos(x);
v = cos(x);

for i = 1:100
    direction_E = [time(i) cosen(i) cero(i)]/norm([time(i) cosen(i) cero(i)]); 
    E = module_E *direction_E;
    p = quiver(x,y,direction_E(1),direction_E(2))
end