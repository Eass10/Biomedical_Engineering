clear; clc; close all

% Three loads and one test are created and displayed
figure; hold on; grid on;
[q1,r1]=drawCharge;
[q2,r2]=drawCharge;
[q3,r3]=drawCharge;
[qt,rt]=drawCharge(5e-6);% Test charge
o=findobj('Marker','.'); o(1).Color=[0 0 0]; % Test charge in black color

%% Function to visualize the vectors of the Coulomb force
drawForceArrow=@(posOrigin,forceVector,varargin) quiver3(posOrigin(1),posOrigin(2),posOrigin(3),forceVector(1),forceVector(2),forceVector(3),varargin{:});

%% ------ S2 -------
angulos=linspace(0,2*pi,100); % Angles of the circular path
radio=.2; % Circular path radius
for i=1:length(angulos)
    posicion = radio*exp(1i*angulos(i));
    rt = [real(posicion) imag(posicion) 0];
    o(1).XData=rt(1); o(1).YData=rt(2); plot(rt(1),rt(2),'.k','MarkerSize',30')
    F1=CoulombForce(r1,rt,q1,qt); % The Coulomb force that exerts q1 on qt is calculated
    F2=CoulombForce(r2,rt,q2,qt); % The Coulomb force that exerts q2 on qt is calculated
    F3=CoulombForce(r3,rt,q3,qt); % The Coulomb force that exerts q3 on qt is calculated
    drawForceArrow(rt,(F1+F2+F3),'linewidth',1,'color',[230,126,34]/255); % The arrow of the total Force drawn by all the charges on qt is drawn
    axis equal; xlabel('x (m)'), ylabel('y (m)');
    drawnow, pause(.1), hold on, view(0,90)
end


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

function F=CoulombForce(ri,rt,qi,qt)
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;  % Coulomb constant (Nm^2/C^2)
r = norm(rt-ri);  % Distance in the direction ri to rt
u = (rt-ri)/r; % Unitary vector of distance in Cartesian coordinates
F = ke*qi*qt/r^2 * u; % Coulomb force
end
