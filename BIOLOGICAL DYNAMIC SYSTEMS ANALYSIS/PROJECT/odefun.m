function dydt = odefun(t, y)
    % Unpack state variables
    Ros = y(1);
    Syn = y(2);
    ERS = y(3);
    mTOR = y(4);
    Beca = y(5);
    Casp = y(6);

    % Parameters
    % Stresses
    S1 = 2;      % Internal or external oxidative stress -> Promote ROS
    S2 = 1;      % Age-related anti-oxidative mechanisms -> Degrades ROS
    S3 = 1;      % Influence of genetic damage -> Promotes the formation of αSyn
    dAlphaSyn = 15; % αSyn∗-dependent fractional activation of ROS

    % Rate Constants
    kAlphaSyn = 8.5;     % Hill constant of αSyn∗ aggregation
    k1 = 0.72;           % Generation rate of ROS
    k2 = 0.72;           % Removal rate constant of ROS
    k3 = 0.7;            % Generation rate constant of αSyn∗
    k4 = 0.7;            % Removal rate constant of αSyn∗
    k5 = 2.7;            % Beclin1- and mTOR-dependent rate constant of αSyn∗ degradation
    k6 = 1;              % αSyn∗-dependent rate constant of ERS activation
    k7 = 0.5;            % Basal rate constant of ERS activation
    k8 = 1;              % Basal rate constant of ERS inactivation
    k9 = 2;              % Basal rate of mTOR activation
    k10 = 10;            % ERS-dependent rate constant of mTOR activation
    k11 = 0.4;           % Basal rate of mTOR inactivation
    k12 = 7;             % Beclin1-dependent rate constant of mTOR inactivation
    k13 = 2;             % Basal rate of Beclin1 activation
    k14 = 4;             % ERS-dependent rate constant of Beclin1 activation
    k15 = 1;             % Basal rate of Beclin1 inactivation
    k16 = 10;            % Caspases-dependent rate constant of Beclin1 inactivation
    k17 = 0.6;           % mTOR-dependent rate constant of Beclin1 inactivation
    k18 = 1;             % Basal rate of Caspases inactivation
    k19 = 2;             % ERS-dependent rate constant of Caspases activation
    k20 = 2;             % mTOR-dependent rate constant of Caspases activation
    k21 = 2;             % Basal rate of Caspases inactivation
    k22 = 4.5;           % Beclin1-dependent rate constant of Caspases inactivation

    % Michaelis Constants
    Jbe = 1;    % Beclin1 Michaelis constant
    Jca = 0.04; % Caspases Michaelis constant

    % Total Levels
    ERST = 2;           % Total level of ERS
    mTORT = 1;          % Total level of mTOR
    Beclin1T = 1;       % Total level of Beclin1
    CaspasesT = 1;      % Total level of Caspases

    % ODE system
    dydt = zeros(6, 1);

    dydt(1) = k1 * (1 + S1 + dAlphaSyn * ((Syn / kAlphaSyn)^4 / (1 + (Syn / kAlphaSyn)^4))) - k2 * Ros * S2;
    dydt(2) = k3 * Ros * S3 - k4 * Syn * k5 * Beca * mTOR;
    dydt(3) = k6 * Syn * k7 * (ERST - ERS) - k8 * ERS;
    dydt(4) = (k9 + k10 * ERS) * (mTORT - mTOR) - (k11 + k12 * Beca) * mTOR;
    dydt(5) = ((k13 + k14 * ERS) * (Beclin1T - Beca) / (Jbe + Beclin1T - Beca)) - (k15 + k16 * Casp + k17 * mTOR) * Beca / (Jbe + Beca);
    dydt(6) = ((k18 + k19 * ERS + k20 * mTOR) * (CaspasesT - Casp) / (Jca + CaspasesT - Casp)) - ((k21 + k22 * Beca) * Casp) / (Jca + Casp);
end