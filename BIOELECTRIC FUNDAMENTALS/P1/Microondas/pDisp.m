omega = 0;
x2 = 5; x1 = -5; y2 = 0; y1 = 0;
EF = [sin(omega), cos(omega)];
E = sqrt(EF(1)^2+EF(2)^2);
p_v = [(x2-x1), (y2-y1)];
a = 10;
q =1;
p = 2*a*q;
omega = atan(x2/y2);
torque = EF .* p_v;
tq = p*E*sin(omega);
for i = 0:0.1:1
    x2 = x2 + cos(omega)*tq/5; 
    x1 = x1 - cos(omega)*tq/5;
    y2 = y2 - sin(omega)*tq/5; 
    y1 = y1 + sin(omega)*tq/5;
    clf
    hold on
    prot=plot(x2, y2, '.', 'MarkerSize', 20,'Color', [255 87 51]/255);
    elec=plot(x1, y1, '.', 'MarkerSize', 20,'Color', [93 173 226]/255);
    xlim([-10 10])
    ylim([-10 10])
    grid on
    hold off
    omega = atan(y2/x2);
    EF = [sin(omega), cos(omega)];
    tq = p*E*sin(omega);
    %omega = atan(y2/x2);
    %tq = p*E*sin(omega);
    %torque = EF .* p_v
    %quiver(torque(1), torque(2))
    pause(1/500)
end