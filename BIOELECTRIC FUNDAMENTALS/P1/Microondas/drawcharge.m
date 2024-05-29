clear; clc; close all;
figure; hold on; grid on; 

[q0,r0]=drawCharge(10e-6,[-1,1,0]); 
[q1,r1]=drawCharge(-10e-6,[1,-1,0]); 

function [charge,r]=drawCharge(value,position)
charge=value; r=position;


colores={[255,87,51]/255,[93,173,226]/255}; 

if charge>0; 
    c=1; 
else; 
    c=2; 
end
plot3(r(1),r(2),r(3),'.','MarkerSize',30,'Color',colores{c}); 
text(r(1)+0.03,r(2)+0.03,r(3)+0.03,[num2str(charge*1e6,'%.2f'),' \muC']);

end