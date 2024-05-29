function [bound1,u,uXYi,uXYb,Fc,Gc,Xu,Yu] = Resolver2MediosCirc2(bound1,Xi,Pi,Cb,Pb)


plotflag = 0;

%% Obtain mid points, lengths and normals
for i = 1:length(bound1)
    bound1{i} = midNormals(bound1{i});
end
%% Mix inner-outer circles
outerBound = bound1{end};
innerBound = bound1(1:end-1);
oBC = [];
oBCmid = [];
oBlen =  [];
oBnormal =[]; 
oBtype  = [];
oBval  = [];
pType = [];
% Introduce hole in outerBound
for i = 1:length(innerBound)
    oBC = [oBC;flipud(innerBound{i}.C)];
    oBCmid = [oBCmid;flipud(innerBound{i}.Cmid)];
    oBlen =  [oBlen;innerBound{i}.len];
    oBnormal = [oBnormal;-flipud(innerBound{i}.normal)];
    oBtype  = [oBtype;((100+i)*ones(size(innerBound{i}.type)))];
    oBval  = [oBval;(innerBound{i}.val)];
    pType = [pType;i*ones(size(innerBound{i}.val))];
end

oBC = [oBC;outerBound.C];
oBCmid = [oBCmid;outerBound.Cmid];
oBlen =  [oBlen;outerBound.len];
oBnormal =[oBnormal;outerBound.normal];
oBtype  = [oBtype;outerBound.type];
oBval  = [oBval;outerBound.val];
pType = [pType;length(bound1)*ones(size(outerBound.val))];

% Just checking that the normals and the points are OK
if plotflag
    figure(2),
    for i = 1:length(innerBound)
        quiver(innerBound{i}.Cmid(:,1),innerBound{i}.Cmid(:,2),...
            innerBound{i}.normal(:,1),innerBound{i}.normal(:,2));
        hold on, plot(innerBound{i}.C(:,1),innerBound{i}.C(:,2),'.-r');
        axis equal
    end
    
    quiver(oBCmid(:,1),oBCmid(:,2),...
        oBnormal(:,1),oBnormal(:,2));
    hold on, plot(oBC(:,1),oBC(:,2),'.-r');
    axis equal
end


%% Integrals to matrix, self equations 
[FcO,GcO] = getFC(oBCmid,oBC,oBnormal,oBlen,pType,'AtBoundary',"boun");
idxOO = ones(size(oBtype));
for i = 1:length(innerBound)
    [FcI{i},GcI{i}] = getFC(innerBound{i}.Cmid,innerBound{i}.C,innerBound{i}.normal,innerBound{i}.len, pType,'AtBoundary',"-");
    idxSharedIO{i} = isnan(innerBound{i}.type); % Points in i-th inner bounds that share coordinates with points in outer bound
    innerBound{i}.type = nan(size(innerBound{i}.type));
    innerBound{i}.val = zeros(size(innerBound{i}.type));
    idxSharedOI{i} = (oBtype == 100+i); % Points in outer bound that share coordinates with points in i-th inner bound
    oBtype(oBtype==100+i) = nan(size(oBtype(oBtype==100+i)));
    oBval(oBtype==100+i) = zeros(size(oBtype(oBtype==100+i)));
    idxOO = xor(idxOO,idxSharedOI{i});
end

% Build matrices according to Brebbia

Fc = [];
Gc = [];
for i = 1:length(innerBound)
   
    FcIO = -1/innerBound{i}.s*rot90(FcI{i}(:,idxSharedIO{i}),2);
    GcIO = rot90(GcI{i}(:,idxSharedIO{i}),2);
    for j = 1:length(innerBound)
         ZIJ{j} = zeros(size(FcI{i},1),size(FcI{j},1));
    end
    ZIO =  zeros(size(FcI{i},1),sum(idxOO));
    
    Preaux = [];
    Preaux2 = [];
    for j = 1:i-1
            Preaux = [Preaux,ZIJ{j}];
            Preaux2 = [Preaux2,ZIJ{j}];
    end
    
    aux = [];
    aux2 = [];
    for j = i+1:length(innerBound)
            aux = [aux,ZIJ{j}];
            aux2 = [aux2,ZIJ{j}];
    end

    Fc = [Fc;Preaux,FcIO,aux,ZIO];
    Gc = [Gc;Preaux2,GcIO,aux2,ZIO];
end
  

FcOI = [];
GcOI = [];
for i = 1:length(innerBound)
    ZOI = zeros(size(FcO,1),size(innerBound{i}.C,1));
    FcOI = [FcOI,1/outerBound.s*FcO(:,idxSharedOI{i})];
    GcOI = [GcOI,GcO(:,idxSharedOI{i})];
end

FcOI = [FcOI,FcO(:,idxOO)];
GcOI = [GcOI,GcO(:,idxOO)];

Fc = [Fc;FcOI];
Gc = [Gc;GcOI];

if plotflag
    figure(4), surf(Fc);
    figure(5), surf(Gc);
end

%% Sort matrices and solve system 


mixType = [];
mixVal = [];
% for j = i:length(innerBound)
%     for k = j:length(innerBound)
%         mixType = [mixType;innerBound{k}.type];
%         mixVal = [mixVal;innerBound{k}.val];
%     end
% end


for i = 1:length(innerBound)
    mixType = [mixType;oBtype(idxSharedOI{i})];
    mixVal = [mixVal;oBval(idxSharedOI{i})];
end
mixType = [mixType;oBtype(idxOO)];
mixVal = [mixVal;oBval(idxOO)];


[u,q] = sortMatricesAndSolve(Fc,Gc,mixType,mixVal);

%% Expansion to the domain 
for i = 1:length(innerBound)
    ini = 0;
    idx1 = idxSharedIO{i};
    [Fi,Gi] = getFC(Xi{i},(innerBound{i}.C),innerBound{i}.normal,innerBound{i}.len,pType,'AtInterior',"-");
    [FiB,GiB] = getFC(Cb{i},(innerBound{i}.C),innerBound{i}.normal,innerBound{i}.len,pType,'AtInterior',"-");
    for j = 2:i
        ini = ini+sum(idxSharedIO{j-1});
    end
    ini = ini+1;
    uXYi{i} = (-fliplr(Gi)*(u(idxSharedOI{i}))-1/innerBound{i}.s*fliplr(Fi)*(q(idxSharedOI{i})));
    uXYb{i} = 2*(-fliplr(GiB)*(u(idxSharedOI{i}))-1/innerBound{i}.s*fliplr(FiB)*(q(idxSharedOI{i})));
    inicio(i) = ini;
    fin(i) = ini+sum(idx1)-1;
end

C = [];
normal = [];
len = [];
for i = 1:length(innerBound)
    C = [C;oBC(idxSharedOI{i},:)];
    normal = [normal;oBnormal(idxSharedOI{i},:)];
    len =  [len;oBlen(idxSharedOI{i},:)];
end
C = [C;oBC(idxOO,:)];
normal = [normal;oBnormal(idxOO,:)];
len = [len;oBlen(idxOO,:)];

[FiO,GiO] = getFC(Xi{end},C,normal,len,pType,'AtInterior',"boun");
[FiOB,GiOB] = getFC(Cb{end},C,normal,len,pType,'AtInterior',"boun");
idx = [];
q2 = q;
q2(1:fin(end)) = 1/outerBound.s*q2(1:fin(end));

uXYi{i+1} = (-GiO*u+FiO*q2);
uXYb{i+1} = 2*(-GiOB*u+FiOB*q2);
Xu = C(:,1);
Yu = C(:,2);


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

function [Fc,Gc] = getFC(Cmid,C,normal,len,pType,typeBound,type)

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
        if ((i==j) && (strcmp(typeBound,'AtBoundary'))) || (xc == xk && yc ==yk)
            Gc(i,j) = 0;
            Fc(i,j) = lk/(2.0*pi)*(log(lk/2.0) - 1.0);
        else
            [Fc(i,j),Gc(i,j)] = findfg (xc,yc, xk, yk, nkx, nky, lk);
        end
    end
end

else
     if type == "boun"
         aX = [];
         bX = [];
         aY = [];
         bY = [];
         clase = unique(pType);
         for i = 1:length(clase)
             x1 = C(pType==clase(i),:);
             xSig = [x1(2:end,:);x1(1,:)];
             xPre = x1;
             % Generamos las normales para el calculo de las integrales
             aX1 = (xSig(:,1)-xPre(:,1))/2;
             bX1 = (xSig(:,1)+xPre(:,1))/2;
             aY1 = (xSig(:,2)-xPre(:,2))/2;
             bY1 = (xSig(:,2)+xPre(:,2))/2;
             aX = [aX;aX1];
             bX = [bX;bX1];
             aY = [aY;aY1];
             bY = [bY;bY1];
        end
        
     else
        xSig = [C(2:end,:);C(1,:)];
        xPre = C;
        % Generamos las normales para el calculo de las integrales
        aX = (xSig(:,1)-xPre(:,1))/2;
        bX = (xSig(:,1)+xPre(:,1))/2;
        aY = (xSig(:,2)-xPre(:,2))/2;
        bY = (xSig(:,2)+xPre(:,2))/2;
        
     end
     
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
