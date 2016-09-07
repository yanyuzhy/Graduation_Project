%% 支腿位置绘图
figure(1)
hFig=figure(1);
set(hFig, 'Position', [300 300 600 280])
plot(zposition.time,zposition.signals.values,'linewidth',2)
xlabel('Time (s)')
ylabel('Height (mm)')
grid on
box off
legend('支腿1', '支腿2','支腿3','支腿4');
%% 平台倾角绘图
figure(2)
hFig=figure(2);
set(hFig, 'Position', [300 300 600 280])
plot(theta.time,theta.signals.values,'linewidth',2)
xlabel('Time (s)')
ylabel('Angle (deg)')
grid on
box off
legend('θx', 'θy');
%% 支腿受力绘图
figure(3)
hFig=figure(3);
set(hFig, 'Position', [300 300 600 280])
plot(force.time,force.signals.values,'linewidth',2)
xlabel('Time (s)')
ylabel('Force (N)')
grid on
box off
legend('支腿1', '支腿2','支腿3','支腿4');

%% 支腿伸长量绘图
figure(4)
hFig=figure(4);
set(hFig, 'Position', [300 300 600 280])
plot(scl.time,scl.signals.values,'linewidth',2)
xlabel('Time (s)')
ylabel('Length (mm)')
grid on
box off
legend('支腿1', '支腿2','支腿3','支腿4');