function [bound1,Xi,Pi,Cb,Pb] = generarDiscontinuo(nb,ni)
Vo = 300;
L1 = 6;
L2 = 6;
sigma1 = 1;
sigma2 = 2;

b2 = -Vo*sigma1/(sigma1*L2+sigma2*L1);
d2 = -b2*(L1+L2);

b1 = -Vo*sigma2/(sigma1*L2+sigma2*L1); 
d1 = Vo;

n = nb;
[C,myval,mytype] = miCuadrado1(n,'train',L1,Vo);

bound1{1}.C = C;
bound1{1}.val = myval;%zeros(size(C,1),1);
bound1{1}.type = mytype;
bound1{1}.s = sigma1;

myeps = 1e-1;
x = linspace(0+myeps,L1-myeps,ni); 
y = linspace(0+myeps,L1-myeps,ni); 
[X,Y] = meshgrid(x,y);
Pot = b1*X+d1; 
Xi{1} = [X(:),Y(:)];
Pi{1} = Pot(:);

if 0
figure(1), clf
surf(X,Y,Pot); alpha(.5);
xlabel('x'),ylabel('y');
end

[C,myval,mytype] = miCuadrado2(n,'train',L1,L2);

bound1{2}.C = C;
bound1{2}.val = myval;
bound1{2}.type = mytype;
bound1{2}.s = sigma2;

myeps = 1e-1;
x = linspace(L1+myeps,(L2+L1)-myeps,ni); 
y = linspace(0+myeps,L1-myeps,ni); 
[X,Y] = meshgrid(x,y);
Pot = b2*X+d2; 
Xi{2} = [X(:),Y(:)];
Pi{2} = Pot(:);

[Cb1,Pb1] = miCuadrado1(2*n,'test',L1,Vo);

[Cb2,Pb2] = miCuadrado2(2*n,'test',L1,L2);

Cb{1} = Cb1;
Cb{2} = Cb2;

Pb{1} = b1*Cb1(:,1)+d1; 
Pb{2} = b2*Cb2(:,1)+d2; 

x = linspace(0,L1+L2,100); 
y = linspace(0,L1,100); 
[Xr,Yr] = meshgrid(x,y);
myphir = zeros(size(Xr));
myphir(Xr<L1) = b1*Xr(Xr<L1)+d1;
myphir(Xr>=L1) = b2*Xr(Xr>=L1)+d2;

figure(1); clf
surf(Xr,Yr,myphir);
shading interp, alpha(.5)
hold on

function [C,myval,mytype] = miCuadrado2(n,tipo,L1,L2)

% 

a = linspace(L1,L2+L1,n);
ce = zeros(1,n);
un = ones(1,n);

A = [a; L1*ce]; 
B = [(L1+L2)*un; a-L1];
C = [a(end:-1:1); L1*un]; 
D = [L1*un; a(end:-1:1)-L1];  

Aval = ce;
Atype = un;
Bval = ce;
Btype = ce;
Cval = ce;
Ctype = un;
Dval =nan(size(ce));
Dtype = nan(size(ce));

C = [A(:,2:end-1), B, C(:,2:end-1), D]';
myval = [Aval(2:end-1),Bval,Cval(2:end-1),Dval]';
mytype = [Atype(2:end-1),Btype,Ctype(2:end-1),Dtype]';


function [C,myval,mytype] = miCuadrado1(n,tipo,L1,Vo)

% 

a = linspace(0,L1,n);
ce = zeros(1,n);
un = ones(1,n);

A = [a; ce]; 
B = [L1*un; a];
C = [a(end:-1:1); L1*un]; 
D = [ce; a(end:-1:1)];  

Aval = ce;
Atype = un;
Bval =  nan(size(un));
Btype = nan(size(un));
Cval = ce;
Ctype = un;
Dval = Vo*un;
Dtype = ce; 

C = [A(:,2:end-1), B, C(:,2:end-1), D]';
myval = [Aval(2:end-1),Bval,Cval(2:end-1),Dval]';
mytype = [Atype(2:end-1),Btype,Ctype(2:end-1),Dtype]';
