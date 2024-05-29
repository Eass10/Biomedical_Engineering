function E=ElectricField(ri,R,qi)
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;  % Coulomb constant (Nm^2/C^2)
% r = norm(R-ri);  % Distance in the direction ri to rt
r =sqrt(sum((R-ri).^2,2));  % Distance in the direction ri to rt
u = (R-ri)./r; % Unitary vector of distance in Cartesian coordinates
E = ke*qi./r.^2 .* u; % Electric field (E)