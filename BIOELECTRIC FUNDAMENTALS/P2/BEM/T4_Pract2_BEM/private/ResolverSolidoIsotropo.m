function [bound1,u,uXYi,uXYb,Fc,Gc] = ResolverSolidoIsotropo(bound1,Xi,Pi,Cb,Pb)

plotflag = 0;

%% Obtain mid points, lengths and normals
bound1 = midNormals(bound1);

% Just checking that the normals and the points are OK
if plotflag
    figure(2),
    quiver(bound1.Cmid(:,1),bound1.Cmid(:,2),...
        bound1.normal(:,1),bound1.normal(:,2));
    hold on, plot(bound1.C(:,1),bound1.C(:,2),'.-r');
    hold off
end


%% Integrals to matrix, self equations 
[Fc,Gc] = getFC(bound1.Cmid,bound1.C,bound1.normal,bound1.len,'AtBoundary');

if plotflag
    figure(4), surf(Fc);
    figure(5), surf(Gc);
end

%% Sort matrices and solve system 

[u,q] = sortMatricesAndSolve(Fc,Gc,bound1.type,bound1.val);

%% Expansion to the domain 

[Fi,Gi] = getFC(Xi,bound1.C,bound1.normal,bound1.len,'AtInterior'); % ¿C o Cmid?
uXYi = Fi*q-Gi*u;

[Fb,Gb] = getFC(Cb,bound1.C,bound1.normal,bound1.len,'AtInterior'); % ¿C o Cmid?
uXYb = 2*(Fb*q-Gb*u);

if plotflag
    figure(1), hold on, 
    plot3(Xi(:,1),Xi(:,2),uXYi,'.b','Markersize',10); 
    plot3(Cb(:,1),Cb(:,2),uXYb,'.r','Markersize',10); 
    hold off 

    figure(6), clf, 
    plot3(Xi(:,1),Xi(:,2),uXYi-Pi,'.b','Markersize',10);

    figure(7), clf, 
    plot3(Cb(:,1),Cb(:,2),uXYb-Pb,'.b','Markersize',10);
end
disp('Bye!');





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

function [u,q] = sortMatricesAndSolve(Fc,Gc,mytype,val)

n1 = length(val);
u = nan*ones(n1,1);
q = nan*ones(n1,1);

induM = find(mytype==0);
u(induM) = val(induM);
indqM = find(mytype==1);
q(indqM) = val(indqM);

indum = indqM; % Desconocidos, m
indqm = induM; 

uM = u(induM);
qM = q(indqM);
um = u(indum);
qm = q(indqm);

Rc = Gc + 0.5*eye(size(Gc));
RM = Rc(:,induM);
Rm = Rc(:,indum);
FM = Fc(:,indqM);
Fm = Fc(:,indqm);


A = [Rm, -Fm];
b = [-RM*uM + FM*qM];

z = mySolver(A,b);

um = z(1:length(indum));
qm = z(length(indum)+1:end);
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
            if (i==j) & (strcmp(typeBound,'AtBoundary'))
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
    nG = 4; % nº coeficientes Gauss
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
        G(eye(size(G))==1) = 0;
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
% A = lk.^2;
% B = 2.*lk.*(-nky.*(xk-xi)+nkx.*(yk-eta));
% E = (xk-xi).^2+(yk-eta).^2;
% D = sqrt(abs(4*A.*E-B^2));
% BA = B./A;
% EA = E./A;
% if D<1e-2
%     F = 0.5*lk*(log(lk)+(1+0.5*BA)*log(abs(1+0.5*BA))-0.5*BA*log(abs(0.5*BA))-1)/pi;
%     G = 0;
% else
%     F = 0.25*lk*(2*(log(lk)-1)-0.5*BA*log(abs(EA))+(1+0.5*BA)*log(abs(1+BA+EA))+(D/A)*(atan((2*A+B)/D)-atan(B/D)))/pi;
%     G = lk*(nkx*(xk-xi)+nky*(yk-eta))/D*(atan((2*A+B)/D)-atan(B/D))/pi;
% end



function y = intf (t, xi, eta, xk, yk, nkx, nky, lk)

y = log ((xk - t*lk*nky - xi).^2 + (yk + t*lk*nkx - eta).^2);

function y = intg(t, xi, eta, xk, yk, nkx, nky, lk)

y = (nkx*(xk - t*lk*nky - xi) + nky*(yk + t*lk*nkx - eta))./...
    ((xk - t*lk*nky - xi).^2 + (yk + t*lk*nkx - eta).^2);