function [part]=drawdipole(position)
    if position(1) > 0
        part=plot(position(1), position(2), '.', 'MarkerSize', 20,'Color', [255 87 51]/255);
    end
    if position(1) < 0 
        part=plot(position(1), position(2), '.', 'MarkerSize', 20,'Color', [93 173 226]/255);
   end
end