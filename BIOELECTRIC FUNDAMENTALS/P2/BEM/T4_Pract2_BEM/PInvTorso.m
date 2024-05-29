% This script is a demonstration on how to use my boundary element code

% Load the geometries
% All of these datas where extracted from UTAH 15 may 2002 first control file 

%load(fullfile('examples','geometry'));
auxCage = load('./Data/Cage.mat');
auxTank = load('./Data/tank_771_closed.mat');
auxTankGeom = load('./Data/tank_192.mat');

% The method works with closed surface, but the data are stored for open
% surface. We need to perform a association from closed surface points to
% open surface points.

[~,channels] = min(pdist2(auxTank.torso.node',auxTankGeom.tank.pts'));

% Parse geometrical data in structures
tankexactgridgeom.pts = (auxTank.torso.node);        
tankexactgridgeom.fac = (auxTank.torso.face);                   
tankexactgridgeom.sigma = [0,5]; %No value provided for inside-outside conductivities 

cagegeom.pts = (auxCage.cage.node);        
cagegeom.fac = (auxCage.cage.face);                   
cagegeom.sigma = [5,0]; %No value provided for inside-outside conductivities 

tankgeom.pts = (auxTankGeom.tank.pts);        
tankgeom.fac = (auxTankGeom.tank.fac);                   
tankgeom.sigma = [1,2]; 

% Create a new model
model.surface{1} = tankexactgridgeom;
model.surface{2} = cagegeom;

% compute the complete transfer matrix
Transfer = bemMatrixPP(model);


% Now load some data to play around with

% dataset = 3;   % change the number to view a different data set
% 
% filename = fullfile('examples',sprintf('datafile-15may2002-%04d',dataset));

torsoSig = load('./Data/rsm15may02-ts-0003.mat');
cageSig = load('./Data/rsm15may02-cage-0003.mat');

% Parse signals in structures
Ucager = cageSig.ts.potvals; %Real potentials on cage;  Ucager = cageSig.ts.potvals; %Potential on cage
Utankr = torsoSig.ts.potvals; %Real potential on torso;  Ucager = cageSig.ts.potvals; %Potential on cage

% Compute the forward solution for each time frame

Uforward = Transfer*Ucager;   %Ucager(cagegeom.channels,:);

Uforwardmeasonly = Uforward(channels,:); %tankexactgridgeom.

% Now plot the two solutions next to each other

timeframe = 130;

figure(1)
bemPlotSurface(tankgeom,Uforwardmeasonly(:,timeframe),'colorbar');

figure
bemPlotSurface(tankgeom,Utankr(:,timeframe),'colorbar');

% Determine some statistics

RDM = errRDM(Utankr(:,timeframe),Uforwardmeasonly(:,timeframe))
MAG = errMAG(Utankr(:,timeframe),Uforwardmeasonly(:,timeframe))

% Plot signals in M-Mode
fs = 500;
nRepresent = 20;
figure()
t = 1:length(Uforwardmeasonly);
t = t/fs-1/fs;
x = ones(size(t));
for i = 1:nRepresent
    subplot(131)
        plot3(x*i,t,Utankr(i,:))
        hold on
        xlabel('ID')
        ylabel('Time (s)')
        zlabel('Amplitude (mV)')
        title('Real Value')
    subplot(132)
        plot3(x*i,t,Uforwardmeasonly(i,:))
        hold on
        xlabel('ID')
        ylabel('Time (s)')
        zlabel('Amplitude (mV)')
        title('Estimated Value')
    subplot(133)
        plot3(x*i,t,abs(Utankr(i,:)-Uforwardmeasonly(i,:)))
        hold on
        xlabel('ID')
        ylabel('Time (s)')
        zlabel('Amplitude (mV)')
        title('|Error|')
end