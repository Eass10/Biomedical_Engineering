clear; clc; close all

%% Three loads and one test are created and displayed
figure; hold on; grid on;
[qs(1),rs(1,:)]=drawCharge;
[qs(2),rs(2,:)]=drawCharge;
[qs(3),rs(3,:)]=drawCharge;

%% -------- S5 --------
[X,Y] = meshgrid(linspace(-1,1,100),linspace(-1,1,100)); % XY plane
d = 0.001; % Distance from the charges to the XY plane
Z = d*ones(size(X));
R = [X(:) Y(:) Z(:)];  
Et = zeros(size(R));
for i=1:length(qs)
    Et = Et + electricField(rs(i,:),R,qs(i));
end
Ex = reshape(Et(:,1),size(X));
Ey = reshape(Et(:,2), size(X));
streamslice(X,Y,Ex,Ey); axis tight



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

function E=electricField(ri,R,qi)
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;  % Coulomb constant (Nm^2/C^2)
% r = norm(R-ri);  % Distance in the direction ri to rt
r =sqrt(sum((R-ri).^2,2));  % Distance in the direction ri to rt
u = (R-ri)./r; % Unitary vector of distance in Cartesian coordinates
E = ke*qi./r.^2 .* u; % Electric field (E)
end

