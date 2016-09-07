function y = fcn(u)
t = u(1);
itae = u(2);
if t == 0
    tic
    timer = 0 ;
else
    timer = toc;
end

if timer>10^20
    y(1) = 1;
    y(2) = 10^10;
else
    y(1) = 0;
    y(2) = itae;
end