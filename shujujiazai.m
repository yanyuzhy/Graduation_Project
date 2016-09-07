x=best;
x=x';
assignin('base','WW',x);
% load('3-26-3');%调用位置模型
load('dianjisudu');
assignin('base','tf1',tf1);
% tic
% out = sim('pingtai_with_control_gaijinPIDNN3_2jianhua',[0,100]);
out = sim('pingtai_with_control_gaijinPIDNN3_2',[0,100]);
% toc