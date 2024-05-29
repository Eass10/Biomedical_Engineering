function [Uforward] = BemSol(model,Uh)

% Function that solves the forward problem with the BEM for models of concentric spheres.
    
    model.surface{1}.sigma = fliplr(model.surface{1}.sigma);
    model.surface{2}.sigma = fliplr(model.surface{2}.sigma);

    Transfer = bemMatrixPP(model);
    
    Uforward = Transfer*Uh;

    return