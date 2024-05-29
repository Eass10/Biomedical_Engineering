function F=CoulombForce(ri,rt,qi,qt)
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;  % Coulomb constant (Nm^2/C^2)
r = norm(rt-ri);  % Distance in the direction ri to rt
u = (rt-ri)/r; % Unitary vector of distance in Cartesian coordinates
F = ke*qi*qt/r^2 * u; % Coulomb force