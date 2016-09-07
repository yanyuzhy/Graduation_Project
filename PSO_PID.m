function z=PSO_PID(x)
x=x';
assignin('base','WW',x);
% load('3-26-3');%调用位置模型
load('dianjisudu');%调用速度模型
assignin('base','tf1',tf1);
out = sim('pingtai_with_control_gaijinPIDNN3_2jianhua',[0,50]);%使用简化模型
% out = sim('pingtai_with_control_gaijinPIDNN3_2',[0,50]);%使用原始模型
itae=out.get('ITAE').signals.values(end);%%ITAE指标
segma1 = min(out.get('thetax').signals(1,2).values-out.get('thetax').signals(1,1).values);%%超调量
segma2 = min(out.get('thetay').signals(1,2).values-out.get('thetay').signals(1,1).values);
segma = segma1 + segma2;
segma = abs(segma);
z = itae + segma*1000;