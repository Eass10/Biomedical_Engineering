function [nodosS] = interpolaNodos(nodosE,n)
    nodos = [nodosE;nodosE(1,:)];
    nodos = nodos+0.0001*rand(size(nodos));
    nodosS = [];
    for i = 1:length(nodos)-1
        xq = linspace(nodos(i,1),nodos(i+1,1),n);
        yq = interp1([nodos(i,1),nodos(i+1,1)],[nodos(i,2),nodos(i+1,2)],xq);
        nodosS = [nodosS;xq',yq'];
    end
    nodosS = unique(nodosS,'stable','rows');
    nodosS = [smooth(nodosS(1:end-n,1)),smooth(nodosS(1:end-n,2))];
end