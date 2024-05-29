function [bound1,u,uXYi,uXYb,Fc,Gc] = Resolver2Medios(bound1,Xi,Pi,Cb,Pb)


plotflag = 0;

%% Obtain mid points, lengths and normals
bound1{1} = midNormals(bound1{1});
bound1{2} = midNormals(bound1{2});

%% Mix inner-outer circles


% Just checking that the normals and the points are OK
if plotflag
    figure(2),
    quiver(bound1{1}.Cmid(:,1),bound1{1}.Cmid(:,2),...
        bound1{1}.normal(:,1),bound1{1}.normal(:,2));
    hold on, plot(bound1{1}.C(:,1),bound1{1}.C(:,2),'.-r');
    axis equal
    
    quiver(bound1{2}.Cmid(:,1),bound1{2}.Cmid(:,2),...
        bound1{2}.normal(:,1),bound1{2}.normal(:,2));
    hold on, plot(bound1{2}.C(:,1),bound1{2}.C(:,2),'.-r');
    axis equal
end


%% Integrals to matrix, self equations 
[Fc1,Gc1] = getFC(bound1{1}.Cmid,bound1{1}.C,bound1{1}.normal,bound1{1}.len,'AtBoundary');
[Fc2,Gc2] = getFC(bound1{2}.Cmid,bound1{2}.C,bound1{2}.normal,bound1{2}.len,'AtBoundary');

idx1 = isnan(bound1{1}.type);
idx2 = isnan(bound1{2}.type);

Fc11 = Fc1(:,~idx1);
Fc12 = 1/bound1{1}.s*Fc1(:,idx1);
Gc11 = Gc1(:,~idx1);
Gc12 = Gc1(:,idx1);

Fc22 = Fc2(:,~idx2);
Fc21 = -1/bound1{2}.s*Fc2(:,idx2);
Gc22 = Gc2(:,~idx2);
Gc21 = Gc2(:,idx2);

Z = zeros(size(Fc11));

Fc = [Fc11,Fc12,Z;Z,Fc21,Fc22];
Gc = [Gc11,Gc12,Z;Z,Gc21,Gc22];

if plotflag
    figure(4), surf(Fc);
    figure(5), surf(Gc);
end

%% Sort matrices and solve system 

mixType = [bound1{1}.type(~idx1);bound1{1}.type(idx1);bound1{2}.type(~idx2)];
mixVal = [bound1{1}.val(~idx1);bound1{1}.val(idx1);bound1{2}.val(~idx2)];

[u,q] = sortMatricesAndSolve(Fc,Gc,mixType,mixVal);

%% Expansion to the domain 
idxOrden = [find(~idx1);find(idx1)];
[Fi1,Gi1] = getFC(Xi{1},bound1{1}.C,bound1{1}.normal,bound1{1}.len,'AtInterior'); % ¿C o Cmid?
uXYi1 = -Gi1(:,idxOrden)*u(1:length(idx1)) + Fi1(:,idxOrden)*q(1:length(idx1));%cambiado

idxOrden2 = [find(idx2);find(~idx2)];
q2 =q;
q2(sum(~idx1)+1:sum(~idx1)+sum(idx1))= 1/bound1{2}.s*-q2(sum(~idx1)+1:sum(~idx1)+sum(idx1));
[Fi2,Gi2] = getFC(Xi{2},bound1{2}.C,bound1{2}.normal,bound1{2}.len,'AtInterior'); % ¿C o Cmid?
uXYi2 = -Gi2(:,idxOrden2)*u(sum(~idx1)+1:end) + Fi2(:,idxOrden2)*q2(sum(~idx1)+1:end); %cambiado

[Fb1,Gb1] = getFC(Cb{1},bound1{1}.C,bound1{1}.normal,bound1{1}.len,'AtInterior'); % ¿C o Cmid?
uXYb1 = 2*(-Gb1(:,idxOrden)*u(1:length(idx1)) + Fb1(:,idxOrden)*q(1:length(idx1))); %cambiado


[Fb2,Gb2] = getFC(Cb{2},bound1{2}.C,bound1{2}.normal,bound1{2}.len,'AtInterior');
uXYb2 = 2*(-Gb2(:,idxOrden2)*u(sum(~idx1)+1:end) + Fb2(:,idxOrden2)*q2(sum(~idx1)+1:end));

uXYb{1} = uXYb1;
uXYb{2} = uXYb2;

uXYi{1} = uXYi1;
uXYi{2} = uXYi2;


% 
% figure(1), 
% plot3([bound1{1}.C(~idx1,1);bound1{1}.C(idx1,1)],[bound1{1}.C(~idx1,2);bound1{1}.C(idx1,2)],u(1:length(idx1)),'.g','Markersize',20);hold on, 
% plot3([bound1{2}.C(idx2,1);bound1{2}.C(~idx2,1)],[bound1{2}.C(idx2,2);bound1{2}.C(~idx2,2)],u(sum(~idx1)+1:end),'.g','Markersize',20);
% plot3(Xi{1}(:,1),Xi{1}(:,2),uXYi1,'.c','Markersize',15);
% plot3(Xi{2}(:,1),Xi{2}(:,2),uXYi2,'.b','Markersize',10); 
% plot3(Cb{1}(:,1),Cb{1}(:,2),uXYb1,'.r','Markersize',10); 
% plot3(Cb{2}(:,1),Cb{2}(:,2),uXYb2,'.r','Markersize',10); 
% hold off 

% figure(6), clf, 
% plot3(Xi{2}(:,1),Xi{2}(:,2),uXYi-Pi.PExt,'.b','Markersize',10);
% 
%  figure(7), clf, 
%  plot3(Cb(:,1),Cb(:,2),uXYb-Pb,'.b','Markersize',10);

disp('Bye!');

% keyboard



% ################################################################
% ####################  Auxiliary functions   ####################
% ################################################################

function mybound = midNormals(mybound)

% 
coords = [mybound.C; mybound.C(1,:)];       % Cerramos el bound
difer =  coords(2:end,:)-coords(1:end-1,:);

mybound.Cmid = 0.5*(coords(2:end,:)+coords(1:end-1,:));
mybound.len = sqrt(difer(:,1).^2 + difer(:,2).^2);
mybound.normal = [difer(:,2), -difer(:,1)]./mybound.len;

% ################################################################

function [u,q] = sortMatricesAndSolve(Fc,Gc,type,val)

n1 = length(val);
u = nan*ones(n1,1);
q = nan*ones(n1,1);

indum = type~=0; 
indqm = type~=1;

induM = ~indum; % Desconocidos, m
indqM = ~indqm; 

u(induM) = val(induM);
q(indqM) = val(indqM);

uM = u(induM);
qM = q(indqM);
um = u(indum);
qm = q(indqm);

Rc = Gc;% - 0.5*eye(size(Gc));
RM = Rc(:,induM);
Rm = Rc(:,indum);
FM = Fc(:,indqM);
Fm = Fc(:,indqm);


A = [Rm, -Fm];
b = [-RM*uM + FM*qM];

z = mySolver(A,b);

um = z(1:sum(indum));
qm = z(sum(indum)+1:end);
q(indqm) = qm;
u(indum) = um;

% ################################################################

function [Fc,Gc] = getFC(Cmid,C,normal,len,typeBound)

% 'AtBoundary', 'AtInterior'
n1 = size(Cmid,1);
n2 = size(C,1);
Fc = zeros(n1,n2);  % In the centers
Gc = zeros(n1,n2);
if 0
for i=1:n1
    for j=1:n2
        xc  = Cmid(i,1);
        yc  = Cmid(i,2);
        xk  = C(j,1);
        yk  = C(j,2);
        nkx = normal(j,1);
        nky = normal(j,2);
        lk  = len(j);
        if ((i==j) & (strcmp(typeBound,'AtBoundary'))) 
            Gc(i,j) = 0;
            Fc(i,j) = lk/(2.0*pi)*(log(lk/2.0) - 1.0);
        else
            [Fc(i,j),Gc(i,j)] = findfg (xc,yc, xk, yk, nkx, nky, lk);
        end
    end
end
else
     xSig = [C(2:end,:);C(1,:)];
     xPre = C;
     % Generamos las normales para el calculo de las integrales
     aX = (xSig(:,1)-xPre(:,1))/2;
     bX = (xSig(:,1)+xPre(:,1))/2;
     aY = (xSig(:,2)-xPre(:,2))/2;
     bY = (xSig(:,2)+xPre(:,2))/2;
     sL = sqrt(aX.^2+aY.^2);
     eta1 =  aY./sL; % Normales
     eta2 = -aX./sL; % Normales

     % Coeficientes cuadratura de Gauss
     nG = 16; % nº coeficientes Gauss
     [xGauss,w]=lgwt(nG,-1,1); % Coeficientes la intgral entre -1 y 1
     Haux = zeros(size(C,1),1);
     Gaux = zeros(size(C,1),1);
     G = zeros(size(Cmid,1),size(C,1));
     F = zeros(size(Cmid,1),size(C,1));
     for i = 1:length(Cmid)
         for k = 1:nG
             xCo = aX*xGauss(k)+bX;
             yCo = aY*xGauss(k)+bY;
             rA = sqrt((-xCo+Cmid(i,1)).^2+(-yCo+Cmid(i,2)).^2);
             rD1 = (xCo-Cmid(i,1))./rA;
             rD2 = (yCo-Cmid(i,2))./rA;
             rDn = rD1.*eta1 + rD2.*eta2;
             Gaux = Gaux - log(rA).*w(k).* sL;
             Haux = Haux - rDn.*w(k).*sL./rA;
         end
         G(i,:) = Haux;
         F(i,:) = Gaux;
         Haux = 0;
         Gaux = 0;
     end
     if (strcmp(typeBound,'AtBoundary'))
         G(eye(size(G))==1) = pi;
         F(eye(size(F))==1) = 2*sL.*(1-log(sL));
     end
     Gc = G*1/(2*pi);
     Fc = F*1/(2*pi);
 end

% ################################################################

function z = mySolver(A,b)

%

z =A\b;

% ################################################################

function [F,G] = findfg (xi, eta, xk, yk, nkx, nky, lk)

%F = (lk/(4.0*pi))*quadl(@(t) intf (t, xi, eta, xk, yk, nkx, nky,lk),0, 1, 1e-8);
%G = (lk/(2.0*pi))*quadl(@(t)intg (t, xi, eta, xk, yk, nkx, nky, lk),0, 1, 1e-8);
F = (lk/(4.0*pi))*integral(@(t) intf (t, xi, eta, xk, yk, nkx, nky,lk),0, 1);
G = (lk/(2.0*pi))*integral(@(t)intg (t, xi, eta, xk, yk, nkx, nky, lk),0, 1);


function y = intf (t, xi, eta, xk, yk, nkx, nky, lk)

y = log ((xk - t*lk*nky - xi).^2 + (yk + t*lk*nkx - eta).^2);

function y = intg(t, xi, eta, xk, yk, nkx, nky, lk)

y = (nkx*(xk - t*lk*nky - xi) + nky*(yk + t*lk*nkx - eta))./...
    ((xk - t*lk*nky - xi).^2 + (yk + t*lk*nkx - eta).^2);