%%
nb = 1; % n# elementos boundary
ni = 20; % n# elementos interior

[bound1,Xi,Pi,Cb,Potb] = generarReal(ni,nb);
[bound1,u,uXYi,uXYb,Fc,Gc,Xu,Yu] = Resolver2MediosCirc2(bound1,Xi,Pi,Cb,Potb);
        
idx1 = isnan(bound1{1}.type);
idx2 = isnan(bound1{2}.type);
% Representacion
figure(1)
hold on;
interior = [];
bordeI = [];
solInterior = [];
solBordeI = [];
for i = 1:length(Xi)
    interior = [interior;Xi{i}];
    solInterior = [solInterior;uXYi{i}];
    bordeI = [bordeI;Cb{i}];
    solBordeI = [solBordeI;uXYb{i}];
end
plot3(interior(:,1),interior(:,2),solInterior,'.b',bordeI(:,1),bordeI(:,2),solBordeI,'.r','Markersize',15)
plot3(Xu,Yu,u,'.g','Markersize',20);hold on, 
legend({'Interior','Interp Frontera','Frontera'})


figure(3)
subplot(121)
surf(Fc)
title('Matriz F')
subplot(122)
surf(Gc)
title('Matriz G')