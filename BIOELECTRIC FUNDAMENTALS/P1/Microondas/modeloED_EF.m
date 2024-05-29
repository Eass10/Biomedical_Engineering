
modeloElD_EF(1, (-2 -2), (+2 +2), line(1,0))


function[]= modeloElD_EF(q, p1, p2, EF)

i=0
alpha
amp = distance(p1, p2);

p_m = 2*amp*q;
p_v = line(p1, p2);

F_pos_m = +q*EF;
F_neg_m = -q*EF;

torq = p_m*EF*sin(alpha)

torq_v = cross(p_v, EF);

dW = p_m*EF(cos(i)-cos(f));

Ue = -p_v * EF;


clf
plot(p1(0), p1(1), '.', 'MarkerSize', 20,'Color', [255 87 51]/255); %prot 
hold on
plot(p2(0), p2(1), '.', 'MarkerSize', 20,'Color', [93 173 226]/255); %elec
xlim([0 20])
ylim([0 20])
grid on

q_EF = quiver(0, 0, cos(alpha), sin(alpha) 'Color', [0 0 0]/255)
q_p = quiver(0, 0 ,'Color', [255 87 51]/255)
q_e = quiver(-EF(0), -EF(1), 'Color', [93 173 226]/255)
hold off
pause(1/500)
end

function EF(px, py, q)
[x,y] = meshgrid(1:0.01:3,1:0.01:3);
u = px*cos(x+pi/6);
v = py*cos(x+pi/6);
quiver(u,v), 'Color', [0 0 0]/255)
end
