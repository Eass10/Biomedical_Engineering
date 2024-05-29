function [bound1,Ci,Poti,Cb,Potb] = generaCuadrado(n1,nb)

%

n = n1;
[C,myval,mytype] = miCuadrado(n,'train');

bound1.C = C;
bound1.val = myval;
bound1.type = mytype;

myeps = 1e-1;
x = linspace(0+myeps,6-myeps,nb); 
y = linspace(0+myeps,6-myeps,nb); 
[X,Y] = meshgrid(x,y);
Pot = -50*X+300; 
Ci = [X(:),Y(:)];
Poti = Pot(:);
[Cb,Potb] = miCuadrado(5*n,'test');
if 1
    figure(1), clf
    surf(X,Y,Pot); alpha(.5);
    shading interp
%     xlabel('x'),ylabel('y');
%     hold on, plot3(Cb(:,1),Cb(:,2),Potb,'.r'); hold off
end



% ##############################################

function [C,myval,mytype] = miCuadrado(n,tipo)

% 

a = linspace(0,6,n);
ce = zeros(1,n);
un = ones(1,n);

A = [a; ce]; 
B = [6*un; a];
C = [a(end:-1:1); 6*un]; 
D = [ce; a(end:-1:1)];  

Aval = ce;
Atype = un;
Bval = ce;
Btype = ce;
Cval = ce;
Ctype = un;
Dval = 300*un;
Dtype = ce;

C = [A(:,2:end-1), B, C(:,2:end-1), D]';
myval = [Aval(2:end-1),Bval,Cval(2:end-1),Dval]';
mytype = [Atype(2:end-1),Btype,Ctype(2:end-1),Dtype]';

if strcmp(tipo,'test')
    myval = -50*C(:,1) + 300;
end
    