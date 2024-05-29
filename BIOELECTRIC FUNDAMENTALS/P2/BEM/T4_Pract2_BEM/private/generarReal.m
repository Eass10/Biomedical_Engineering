function [bound1,Xi,Pi,Cb,Potb] = generarReal(ni,nb)
%%
n = 1;
nb = nb;
load('./Data/casoReal.mat')


% Pulmon 2
sigmaL2 = 1.5;
xi = linspace(min(nodosL2(:))+eps,max(nodosL2(:))-eps,ni);
[Xc,Yc] = meshgrid(xi);
auxNods = [Xc(:),Yc(:)];
bound1{n}.C = (interpolaNodos(nodosL2,nb));
bound1{n}.val = zeros(size(bound1{n}.C,1),1);
bound1{n}.type = nan(size(bound1{n}.C,1),1);
bound1{n}.s = sigmaL2;
[in] = inpolygon(Xc(:),Yc(:),bound1{n}.C(:,1),bound1{n}.C(:,2));
Xi{n} = auxNods(in,:); 
Pi{n} = zeros(size(Xi{n}));
Cb{n} = interpolaNodos(nodosL2,nb+1);
Potb{n} = zeros(size(Cb{n}));
n = n+1;

% Pulmon 1
sigmaL1 = 1.5;
xi = linspace(min(nodosL1(:))+eps,max(nodosL1(:))-eps,ni);
[Xc,Yc] = meshgrid(xi);
bound1{n}.C = (interpolaNodos(nodosL1,nb));
bound1{n}.val = zeros(size(bound1{n}.C,1),1);
bound1{n}.type = nan(size(bound1{n}.C,1),1);
bound1{n}.s = sigmaL1;
auxNods = [Xc(:),Yc(:)];
[in] = inpolygon(Xc(:),Yc(:),bound1{n}.C(:,1),bound1{n}.C(:,2));
Xi{n} = auxNods(in,:); 
Pi{n} = zeros(size(Xi{n}));
Cb{n} = interpolaNodos(nodosL1,nb+1);
Potb{n} = zeros(size(Cb{n}));

n = n+1;

% Corazon 
sigmaCor = 5;
xi = linspace(min(nodosC(:))+eps,max(nodosC(:))-eps,ni);
bound1{n}.C = (interpolaNodos(nodosC,nb));
bound1{n}.val = zeros(size(bound1{n}.C,1),1);
bound1{n}.type = nan(size(bound1{n}.C,1),1);
bound1{n}.s = sigmaCor;
[Xc,Yc] = meshgrid(xi);
auxNods = [Xc(:),Yc(:)];
[in] = inpolygon(Xc(:),Yc(:),bound1{n}.C(:,1),bound1{n}.C(:,2));
Xi{n} = auxNods(in,:); 
Pi{n} = zeros(size(Xi{n}));
Cb{n} = interpolaNodos(nodosC,nb+1);
Potb{n} = zeros(size(Cb{n}));
n = n+1;

% Torso
sigmaT = 10;
xi = linspace(min(nodosT(:))+eps,max(nodosT(:))-eps,ni);
bound1{n}.C =  interpolaNodos(nodosT,nb);
bound1{n}.val = cos(0.5*atan2(bound1{n}.C(:,2),bound1{n}.C(:,1))).^2;
bound1{n}.type = zeros(size(bound1{n}.C,1),1);
bound1{n}.s = sigmaT;
[Xc,Yc] = meshgrid(xi);
auxNods = [Xc(:),Yc(:)];
[in] = inpolygon(Xc(:),Yc(:),bound1{n}.C(:,1),bound1{n}.C(:,2));
[inC, onC] = inpolygon(Xc(:),Yc(:),nodosC(:,1),nodosC(:,2));
[inL1, onL1]= inpolygon(Xc(:),Yc(:),nodosL1(:,1),nodosL1(:,2));
[inL2,onL2] = inpolygon(Xc(:),Yc(:),nodosL2(:,1),nodosL2(:,2));
in = in & ~( inC | inL1 | inL2 | onC | onL1 | onL2);
Xi{n} = auxNods(in,:); 
Pi{n} = zeros(size(Xi{n}));
Cb{n} = interpolaNodos(nodosT,nb+1);
Potb{n} = zeros(size(Cb{n}));