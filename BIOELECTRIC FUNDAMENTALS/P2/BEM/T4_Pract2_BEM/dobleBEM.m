
nb = 20; % n# elementos boundary
ni = 20; % n# elementos interior

disp('Rectangulo 2 medios')
[bound1,Xi,Pi,Cb,Pb] = generarDiscontinuo(nb,ni);
[bound1,u,uXYi,uXYb,Fc,Gc] = Resolver2Medios(bound1,Xi,Pi,Cb,Pb);

idx1 = isnan(bound1{1}.type);
idx2 = isnan(bound1{2}.type);
% Representacion
figure(1)
hold on;
plot3([Xi{1}(:,1);Xi{2}(:,1)],[Xi{1}(:,2);Xi{2}(:,2)],[uXYi{1};uXYi{2}],'.b',[Cb{1}(:,1);Cb{2}(:,1)],[Cb{1}(:,2);Cb{2}(:,2)],[uXYb{1};uXYb{2}],'.r','Markersize',15)
plot3([bound1{1}.C(~idx1,1);bound1{1}.C(idx1,1)],[bound1{1}.C(~idx1,2);bound1{1}.C(idx1,2)],u(1:length(idx1)),'g.',[bound1{2}.C(idx2,1);bound1{2}.C(~idx2,1)],[bound1{2}.C(idx2,2);bound1{2}.C(~idx2,2)],u(sum(~idx1)+1:end),'.g','Markersize',20);hold on, 
legend({'Solución Analítica','Interior','Interp Frontera','Frontera'})

figure(2)
subplot(121)
stem3([Xi{1}(:,1);Xi{2}(:,1)],[Xi{1}(:,2);Xi{2}(:,2)],abs([uXYi{1};uXYi{2}]-[Pi{1};Pi{2}]))
title('Error Interior')
subplot(122)
stem3([Cb{1}(:,1);Cb{2}(:,1)],[Cb{1}(:,2);Cb{2}(:,2)],abs([uXYb{1};uXYb{2}]-[Pb{1};Pb{2}]))
title('Error Frontera')

figure(3)
subplot(121)
surf(Fc)
title('Matriz F')
subplot(122)
surf(Gc)
title('Matriz G')