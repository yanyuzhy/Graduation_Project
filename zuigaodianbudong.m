function y = zuigaodianbudong(u)
%#codegen
global index;
zhitui=zeros(5,1);
t=u(5);
if t==0
%     [zuida,index]=min(u(1:4));
    index=3;
    zhitui=u;
else
    zhitui(1)= u(1)-u(index);
    zhitui(2)= u(2)-u(index);
    zhitui(3)= u(3)-u(index);
    zhitui(4)= u(4)-u(index);
    zhitui(5)=0;
end
y = zhitui;