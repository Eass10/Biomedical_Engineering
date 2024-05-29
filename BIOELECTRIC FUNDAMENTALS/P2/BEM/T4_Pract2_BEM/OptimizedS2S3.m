% This script shows how sensible the method is to changes in the conductivities. 
% Additionally, it graphically represents so.
%% Reference model
function OptimizedS2S3

    [model] = bemGenerateSphere([2 1],[0.5 1 2],0.2); % Sigmas from outside to inside
    model = bemCheckModel(model);

    % Plot to visualize the position of the Spheres
    figure('Name', 'Arrangement of the Spheres')
    TR = triangulation(fliplr(model.surface{1}.fac'),model.surface{1}.pts');
    trisurf(TR,'FaceColor',[0.8 0.8 1.0], 'FaceAlpha', .3);
    axis equal
    hold on
    TR1 = triangulation(fliplr(model.surface{2}.fac'),model.surface{2}.pts');
    Xfb1 = model.surface{2}.pts;
    trisurf(TR1.ConnectivityList,Xfb1(1,:),Xfb1(2,:),Xfb1(3,:));
    
    % Sigmas from inside to outside
    % Ub = potentials in the outer sphere
    Ub_ref = anaSolveSphere('U',model.surface{1}.pts,[0 0 0],[1 0 1],[1 2],[2 1 .5]);
    max_volt_ref = max(Ub_ref);
    % Uh = potentials in the inner sphere
    Uh_ref = anaSolveSphere('U',model.surface{2}.pts,[0 0 0],[1 0 1],[1 2],[2 1 .5]);
    % Number of points to evaluate
    npoints = 30; % 28
    
    %% Sigma 1 equals 0.5, Sigma 2 varies from 0.5 to 3.5, and Sigma 3 equals 2
    
    % I want to evaluate the model when sigma3=2, so I force this variable to 
    % contain '2'. Although these are the values for sigma2, sigma2 and sigma3
    % are flipped in BemSol.
    AllSigmas2 = linspace(.5,3.5,npoints);
    if ~ any(AllSigmas2==2)  
        AllSigmas2(end+1)=2;
        AllSigmas2=sort(AllSigmas2);
    end
    
    TotalAbsErrS2 = zeros(1, length(AllSigmas2));
    
    var = 0;
    
    for s2 = AllSigmas2
        var = var+1;
        model.surface{1}.sigma(2) = s2;
        model.surface{2}.sigma(1) = s2;
        [Uforward] = BemSol(model,Uh_ref); %In this function sigmas are flipped
        AbsErr1 = abs(Ub_ref-Uforward)./max_volt_ref;
        AbsErr = mean(AbsErr1);
        TotalAbsErrS2(var)=AbsErr;
    end
    
    MinAbsErrS2 = min(TotalAbsErrS2);
    MinPositionS2 = find(TotalAbsErrS2==MinAbsErrS2);
    AssociatedSigma2 = AllSigmas2(MinPositionS2);
    fprintf('When varying only Sigma2, the minimum error %f is associated with conductivity Sigma2 %f\n', MinAbsErrS2, AssociatedSigma2)
    
    AllSigmas2 = AllSigmas2.';
    TotalAbsErrS2 = TotalAbsErrS2.';
    
    %% Sigma 1 equals 0.5, Sigma 2 equals 1, and Sigma 3 varies from 0.5 to 3.5
    
    model.surface{1}.sigma(2) = 1;
    model.surface{2}.sigma(1) = 1;
    
    % I want to evaluate the model when sigma2=1, so I force this variable to 
    % contain '1'. Although these are the values for sigma3, sigma2 and sigma3
    % are flipped in BemSol.
    AllSigmas3 = linspace(.5,3.5,npoints);
    if ~ any(AllSigmas3==1)
        AllSigmas3(end+1)=1;
        AllSigmas3=sort(AllSigmas3);
    end
    
    TotalAbsErrS3 = zeros(1, length(AllSigmas3));
    
    var = 0;
    
    for s3 = AllSigmas3
        var = var+1;
        model.surface{2}.sigma(2) = s3;
        [Uforward] = BemSol(model,Uh_ref);
        AbsErr1 = abs(Ub_ref-Uforward)./max_volt_ref;
        AbsErr = mean(AbsErr1);
        TotalAbsErrS3(var)=AbsErr;
    end
    
    MinAbsErrS3 = min(TotalAbsErrS3);
    MinPositionS3 = find(TotalAbsErrS3==MinAbsErrS3);
    AssociatedSigma3 = AllSigmas3(MinPositionS3);
    fprintf('When varying only Sigma3, the minimum error %f is associated with conductivity Sigma3 %f\n', MinAbsErrS3, AssociatedSigma3)
    
    AllSigmas3 = AllSigmas3.';
    TotalAbsErrS3 = TotalAbsErrS3.';
    
    %plot(AllSigmas3,TotalAbsErrS3)
    
   
    %% Figures
    
    figure()
    
    subplot(2,1,1)
    %plot(AllSigmas2,TotalAbsErrS2)
    plot(AllSigmas3, TotalAbsErrS3)
    title('Absolute Error based on Sigma2')
    xlabel('Sigma2')
    ylabel('Absolute Error')
    
    subplot(2,1,2)
    %plot(AllSigmas3, TotalAbsErrS3)
    plot(AllSigmas2,TotalAbsErrS2)
    title('Absolute Error based on Sigma3')
    xlabel('Sigma3')
    ylabel('Absolute Error')
    

return