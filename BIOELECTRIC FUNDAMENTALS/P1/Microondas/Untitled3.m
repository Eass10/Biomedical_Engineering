hold on
for i=1:0.5:10; j=1:0.5:10;
    quiver3(i, j, 0, cos(i), sin(j), 0)
        pause(1/2)

end
    
