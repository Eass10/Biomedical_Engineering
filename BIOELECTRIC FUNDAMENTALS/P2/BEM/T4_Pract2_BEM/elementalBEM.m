%%

nb = 20; % n# elementos boundary
ni = 5; % n# elementos interior

[bound1,Xi,Pi,Cb,Potb] = generaCuadrado(nb,ni);
[bound1,u,uXYi,uXYb,Fc,Gc] = ResolverSolidoIsotropo(bound1,Xi,Pi,Cb,Potb);

figure(1)
hold on;
%plot3(Xi(:,1),Xi(:,2),Pi,'.k','Markersize',15);
plot3(Xi(:,1),Xi(:,2),uXYi,'.b',Cb(:,1),Cb(:,2),uXYb,'.r',bound1.Cmid(:,1),bound1.Cmid(:,2),u,'.g','Markersize',15)
legend({'Solución Analítica','Interior','Interp Frontera','Frontera'})

v = @(x,y) -50*x+300; 
Potn = v(bound1.Cmid(:,1),bound1.Cmid(:,2));

figure(2)
subplot(131)
stem3(Xi(:,1),Xi(:,2),abs(uXYi-Pi))
title('Error Interior')
subplot(132)
stem3(Cb(:,1),Cb(:,2),abs(uXYb-Potb))
title('Error Frontera')
subplot(133)
stem3(bound1.Cmid(:,1),bound1.Cmid(:,2), abs(u-Potn))
title('Error Nodos')

figure(3)
subplot(121)
surf(Fc)
title('Matriz F')
subplot(122)
surf(Gc)
title('Matriz G')