clear; clc; close all;

%% 1. Vectors, matrices
clear; clc; close all;
a=[1, 2, 3];
a(2);
b=a';
c=linspace(4, 10, 10);

A=[1 2 3; 4 5 6; 7 8 9; 10 11 12];
A(2, 2:3);
A([1 3], [1 end]);
B=A(:); %Matrix to vector
C=reshape(B,4,3); %Vector to matrix

a=[1 2 3 4]
i=logical([1 0 0 1])
a(i)
a==4
b=[2 3 2 4]
b==2
b(a==4) %The same as b(2) or b(find(a==4))
%% 2. Opertions and operators
clear; clc; close all;

a=[1 2 3]
b=[4 5 6]

% Scalar Product
sp=a*b'

% Hadamart Product (elementwise product)
hp=a.*b

% Cross Prodct
cp=cross(a,b)

%% 3. Loops, conditions
clear; clc; close all;

a=[];
b=1:2:10;
for i=b
    if i~=5
        i;
        a(i)=i^2;
    end
end
a

c=b.^2;

%% 4. Visualization
clear; clc

a=[1 4 2 3];
b=[2 4 6 8];
plot(b, a, 'r')
t=[4 6 8 10];
stem(t,a,'^', 'MarkerSize', 16)

a=[1 4 2];
b=[2 4 6];
figure; 
plot3(a(1), a(2), a(3), 'ob', 'MarkerSize', 20)
hold on
plot3(b(1), b(2), b(3), 'ob', 'MarkerSize', 20)
grid on

figure
x=[a(1), b(1)];
y=[a(2), b(2)];
z=[a(3), b(3)];
plot3(x, y, z, 'o-', 'MarkerSize', 20)

figure
C=[a' b'];
plot3(C(1,:), C(2,:), C(3,:), ['o-' ...
    ''], 'MarkerSize', 20)

%% 5. Display and printing
clear; clc
disp('Hi! :)')
x=3;
disp(['The value of x is ', num2str(x)])
y=8;
fprintf('The value of y is %d\n', y)
z=0.238556;
fprintf('The value of z is %0.2f\n', z)

%% 6. Useful functions
clc; clear
% For numbers
a = 5.99999
round(a) %redondea
ceil(a) %redondea hacia arriba
floor(a) %trunca

x=linspace(0,1,7);
y=[1 2 3 -2 -1 7 -1];
[value,pos]=max(y);
argmax=x(pos)
figure; plot(x,y); hold on; plot(x(pos), y(pos), 'or', 'MarkerSize', 16)

% For matrices
ones(2,3) % matriz de unos
zeros(2,3) % matriz de ceros
eye(5) % matriz identidad

a=[1 2 3; 4 5 6; 7 8 9];
b=[1 2 3];
diag(a) % transforma la diagonal de a en un vector
diag(b) % trnasforma el vector en la diagonal de una matriz
repmat(b,5,2)
m1=mean(a)
m2=mean(a,2)
[nrows,ncols]=size(a)
nrow=size(a,1)
ncol=size(a,2)

%% 7. 3D Plots
[X,Y]=meshgrid(-1:0.01:1)
Z=X.^2+Y.^2
figure; plot3(X,Y,Z)
grid on
xlabel('x axis')
ylabel('y axis')
zlabel('Z=X.^2+Y.^2')

%% 8. Functions
clear; clc
%Having the function in other script
a=[1 2 3]
b=[4 5 6]
[c,d]=trainingFunctions(a,b)

%Having the function in the same script
[c2,d2]=trainingFunction2(a,b)
function [o1,o2]=trainingFunction2(i1, i2)
disp("Hi! I'm in trainingFunction2...")
nargin % Devuelve el número de input argumentos
nargout % Devuelve el número de output argumentos
o1=cross(i1,i2);
o2=i2*i1';
end





