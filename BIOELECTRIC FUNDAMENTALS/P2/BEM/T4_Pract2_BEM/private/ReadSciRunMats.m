%% Sci2MAT 
% Convierte una estructura + una matriz de señales de SciRun en una estructura valida de acuerdo al esquema siguiente:
% myMesh = Indices de triangulacion (Mx3) M-> # Conexiones.
% myPoints = Coordenadas de nodos (Nx3) N-> # Nodos.
% vsampled = Voltaje (NxT) T-> # Instantes temporales.

%% 1a- Cargamos los datos de estructura de SciRun, provienen de haber guardado un field, linea amarilla, con ExportFieldToMatlab o WriteField.

pth = './Data/';
filename = 'Torso_sup.mat';
comprobar = 1;

load([pth,filename])

% Nos aseguramos que sean double para poder trabajar en matlab
myPoints = cast(scirunfield.node','double');
myMesh = cast(scirunfield.face','double');

% Pintamos para comprobar
if comprobar
    figure(1)
    subplot(1,2,1)
    patch('Faces',myMesh,'Vertices',myPoints,'FaceVertexCData',ones(size(myPoints,1),1))
    shading faceted
    axis equal
    view([0,10])
end

%% 2- Cargamos los datos de senyal de SciRun, provienen de haber guardado una matrix, linea azul, con ExportMatrixToMatlab o WriteMatrix.

pth = './Data/';
filename = 'MatricesMedidas.mat';

load([pth,filename])

% Nos aseguramos que sean double para poder trabajar en matlab
v_stim_torso = BSPM_stim;

% Pintamos para comprobar
if comprobar
   figure(1)
   yrep = 1:length(v_stim_torso(1,:));
   xrep = ones(size(yrep));
   zval = unique(myPoints(:,3));
   idx = find(myPoints(:,3) == zval(end-10));
   for i = 1:length(idx)
       subplot(1,2,2)
       plot3(i*xrep,yrep,v_stim_torso(idx(i),:))
       hold on
       subplot(1,2,1)
       hold on
       scatter3(myPoints(idx(i),1),myPoints(idx(i),2),myPoints(idx(i),3),20,'r','filled')
   end

%% 1b- Cargamos los datos de estructura de SciRun, provienen de haber guardado un field, linea amarilla, con ExportFieldToMatlab o WriteField.

pth = './Data/';
filename = 'Tank_sup.mat';
comprobar = 1;

load([pth,filename])

% Nos aseguramos que sean double para poder trabajar en matlab
myPoints = cast(scirunfield.node','double');
myMesh = cast(scirunfield.face','double');

% Pintamos para comprobar
if comprobar
    figure(2)
    subplot(1,2,1)
    patch('Faces',myMesh,'Vertices',myPoints,'FaceVertexCData',ones(size(myPoints,1),1))
    shading faceted
    axis equal
    view([0,10])
end
v_meas_tank = Tank_meas;



figure(2)
   yrep = 1:length(v_meas_tank(1,:));
   xrep = ones(size(yrep));
   zval = unique(myPoints(:,3));
   idx = find(myPoints(:,3) >= zval(135) & myPoints(:,3) <= zval(160) );
   for i = 1:length(idx)
       subplot(1,2,2)
       plot3(i*xrep,yrep,v_meas_tank(idx(i),:))
       hold on
       subplot(1,2,1)
       hold on
       scatter3(myPoints(idx(i),1),myPoints(idx(i),2),myPoints(idx(i),3),20,'r','filled')
   end
   



%% 1- Cargamos los datos de estructura de SciRun, provienen de haber guardado un field, linea amarilla, con ExportFieldToMatlab o WriteField.

pth = './Data/';
filename = 'Torso_meas_sup.mat';
comprobar = 1;

load([pth,filename])

% Nos aseguramos que sean double para poder trabajar en matlab
myPoints = cast(scirunfield.node','double');
myMesh = cast(scirunfield.face','double');

% Pintamos para comprobar
if comprobar
    figure(3)
    subplot(1,2,1)
    patch('Faces',myMesh,'Vertices',myPoints,'FaceVertexCData',ones(size(myPoints,1),1))
    shading faceted
    axis equal
    view([0,10])
end

v_meas_torso = BSPM_meas;
figure(3)
yrep = 1:length(v_meas_torso(1,:));
xrep = ones(size(yrep));
zval = unique(myPoints(:,3));
idx = find(myPoints(:,3) == zval(end-10));
for i = 1:length(idx)
   subplot(1,2,2)
   plot3(i*xrep,yrep,v_meas_torso(idx(i),:))
   hold on
   subplot(1,2,1)
   hold on
   scatter3(myPoints(idx(i),1),myPoints(idx(i),2),myPoints(idx(i),3),20,'r','filled')
end
end

% %% 3 - Guardamos
% filename = 'TestSciRun2Mat.mat';
% path = '.\';
% 
% save([path,filename],'myMesh','myPoints','vsampled');


