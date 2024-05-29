r=rs(1,:)-rs(2,:); % va de la carga negativa a la positiva
    P=r*qs(1);
    T=cross(P,Et(1,:))
    o=findobj(gca, 'Marker','.');
    while norm(T)>1e-6
        r=rs(1,:)-rs(2,:);
        direccion_avance=[r(2),-r(1), 0]; direccion_avance=direccion_avance/norm(direccion_avance);
        T=cross(r*qs(2), Et(1,:));
        o(1).XData=rs(1,1)+T(3)*direccion_avance(1); o(1).YData=rs(1,2)+T(3)*direccion_avance(2); o(1).ZData=0;
        o(2).XData=rs(2,1)-T(3)*direccion_avance(1); o(2).YData=rs(2,2)-T(3)*direccion_avance(2); o(2).ZData=0;
        rs(1,1)=o(1).XData;
        rs(1,2)=o(1).YData;
        rs(2,1)=o(2).XData;
        rs(2,2)=o(2).YData;
        axis equal; xlabel('x (m)'), ylabel('y (m)');
        drawnow, pause(0), view(0,90)
    end