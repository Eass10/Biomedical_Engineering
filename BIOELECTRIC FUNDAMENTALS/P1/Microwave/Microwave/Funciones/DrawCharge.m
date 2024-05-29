function [charge,r]=DrawCharge(value,position)
if nargin<1 || isempty(value); value=sign(rand-.5)*(4*rand+1)*1e-6; end
if nargin<2 || isempty(position); position=[1.95*(rand-.5) 1.95*(rand-.5) 0]; end
charge=value; r=position;
colors={[255,87,51]/255,[93,173,226]/255};
if charge>0; c=1; else; c=2; end
plot3(r(1),r(2),r(3),'.','MarkerSize',30,'Color',colors{c});
text(r(1)+0.03,r(2)+0.03,r(3)+0.03,[num2str(charge*1e6,'%.2f'),' \muC']);