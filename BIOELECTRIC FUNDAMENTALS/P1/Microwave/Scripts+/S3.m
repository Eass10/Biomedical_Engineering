clear; clc; close all

% Three loads and one test are created and displayed
figure; hold on; grid on;
[q1,r1]=drawCharge;
[q2,r2]=drawCharge;
[q3,r3]=drawCharge;

%% ------ S3 -------
syms x y z; assume(x,'real'); assume(y,'real'); assume(z,'real')
rt = [x y z];
E1 = electricField(r1,rt,q1);
E2 = electricField(r2,rt,q2);
E3 = electricField(r3,rt,q3);
Et = E1 + E2 + E3;
disp('E1:'); pretty(vpa(simplify(E1),2));
disp('E2:'); pretty(vpa(simplify(E2),2));
disp('E3:'); pretty(vpa(simplify(E3),2));
disp('E total:'); pretty(vpa(simplify(Et),2));
zz = 0.01; % We can change here the distance to the plane (z axis)
E1z0 = subs(E1,z,zz);
E2z0 = subs(E2,z,zz);
E3z0 = subs(E3,z,zz);
Etz0 = subs(Et,z,zz);
figure(1); rotate3d on;
h=ezsurf(sqrt(sum(E1z0.^2)),[-2 2 -2 2]); disp('Please, press a button'); pause; delete(h)
h=ezsurf(sqrt(sum(E2z0.^2)),[-2 2 -2 2]); disp('Please, press a button again'); pause; delete(h)
h=ezsurf(sqrt(sum(E3z0.^2)),[-2 2 -2 2]); disp('Please, press a button once again'); pause; delete(h)
ezsurf(sqrt(sum(Etz0.^2)),[-2 2 -2 2]);
xlabel('x (m)'), ylabel('y (m)');



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUXILIARY FUNCTIONS (they are functions that are going to be used often) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [charge,r]=drawCharge(value,position)
if nargin<1 || isempty(value); value=sign(rand-.5)*(4*rand+1)*1e-6; end
if nargin<2 || isempty(position); position=[1.95*(rand-.5) 1.95*(rand-.5) 0]; end
charge=value; r=position;
colors={[255,87,51]/255,[93,173,226]/255};
if charge>0; c=1; else; c=2; end
plot3(r(1),r(2),r(3),'.','MarkerSize',30,'Color',colors{c});
text(r(1)+0.03,r(2)+0.03,r(3)+0.03,[num2str(charge*1e6,'%.2f'),' \muC']);
end

function E=electricField(ri,rt,qi)
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;  % Coulomb constant (Nm^2/C^2)
r = norm(rt-ri);  % Distance in the direction ri to rt
u = (rt-ri)/r; % Unitary vector of distance in Cartesian coordinates
E = ke*qi/r^2 * u; % Electric field (E)
end
