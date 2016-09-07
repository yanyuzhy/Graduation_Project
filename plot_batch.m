figure(1)
hFig=figure(1);
set(hFig, 'Position', [300 300 600 280])
plot(fitness_list,'linewidth',2);
hold on
plot(fitness_list1,'linewidth',2);
grid on
box off
axis([0 200 0 inf])
legend('改进布谷鸟算法', '经典布谷鸟算法');
xlabel('迭代次数')
ylabel('适应度值')