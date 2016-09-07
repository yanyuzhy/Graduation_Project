% function [bestnest,fmin_out,iter_times,N_times,flag_success]=PSO(n,Dim,ObjFun)
%% 清空环境
% clc
% clear all
% close all
%% 参数设置
% Dim = Dim1;            % 维数
% if nargin<1,
    % Number of nests (or different solutions)
tic    
% open_system('pingtai_with_control_gaijinPIDNN3_2');
% simulator = sdo.SimulationTest('pingtai_with_control_gaijinPIDNN3_2');
% simulator = fastRestart(simulator,'on');
    n=21;
    MaxIter=10;
    Dim =24;
    ObjFun = @PSO_PID;
% end
MaxIter=10;
flag_success =0;
w = 0.8;      % 惯性因子
% c1 = 1.49445;       % 加速常数
% c2 = 1.49445;       % 加速常数
c1 = 2;       % 加速常数
c2 = 2;       % 加速常数


SwarmSize = n;    % 粒子群规模
Vaule_max=2;    % 最大值限制
Vaule_min=-2;    % 最大值限制
% ObjFun = @Griewank2;  % 待优化函数句柄
% ObjFun = @Schaffer2;  % 待优化函数句柄
% ObjFun = @Rastrigin2;  % 待优化函数句柄

% MaxIter = 100000;      % 最大迭代次数
MinFit = 0.000000000001;       % 最小适应值

Vmax = 0.1;
Vmin = -0.1;

Ub = ones(1,Dim)*Vaule_max;
Lb = ones(1,Dim)*Vaule_min;
trace=[];

%% 粒子群初始化
Range = ones(SwarmSize,1)*(Ub-Lb);
Swarm = rand(SwarmSize,Dim).*Range + ones(SwarmSize,1)*Lb;      % 初始化粒子群
VStep = rand(SwarmSize,Dim)*(Vmax-Vmin) + Vmin;                 % 初始化速度
fSwarm = zeros(SwarmSize,1);
for i=1:SwarmSize
    fSwarm(i,:) = feval(ObjFun,Swarm(i,:)')+1e-7; % 粒子群的适应值
end

%% 个体极值和群体极值
[bestf bestindex]=min(fSwarm);
zbest=Swarm(bestindex,:);   % 全局最佳
gbest=Swarm;                % 个体最佳
fgbest=fSwarm;              % 个体最佳适应值
fzbest=bestf;               % 全局最佳适应值

%% 迭代寻优

iter = 0;
y_fitness = zeros(1,MaxIter);   % 预先产生4个空矩阵
K_p = zeros(1,MaxIter);
K_i = zeros(1,MaxIter);
K_d = zeros(1,MaxIter);
flag=0;
while( (iter < MaxIter)  )
    for i=1:SwarmSize
        fSwarm(i,:) = feval(ObjFun,Swarm(i,:)')+1e-7; % 粒子群的适应值
    end
    
    for j=1:SwarmSize
        % 个体最优更新
        if fSwarm(j) < fgbest(j)
            gbest(j,:) = Swarm(j,:);
            fgbest(j) = fSwarm(j);
        end
        % 群体最优更新
        if fSwarm(j) < fzbest
            zbest = Swarm(j,:);
            fzbest = fSwarm(j);
        end
    end
    for j=1:SwarmSize
        % 速度更新
        VStep(j,:) = w*VStep(j,:) + c1*rand*(gbest(j,:) - Swarm(j,:)) + c2*rand*(zbest - Swarm(j,:));
        VStep(j,find(VStep(j,:)>Vmax))=Vmax;
        VStep(j,find(VStep(j,:)<Vmin))=Vmin;
        % 位置更新
        Swarm(j,:)=Swarm(j,:)+VStep(j,:);
        for k=1:Dim
            if Swarm(j,k)>Ub(k), Swarm(j,k)=Ub(k); end
            if Swarm(j,k)<Lb(k), Swarm(j,k)=Lb(k); end
        end
    end
    iter=iter+1
    avgfitness=sum(fSwarm)/SwarmSize;
    trace=[trace;avgfitness fzbest]; %记录每一代进化中最好的适应度和平均适应度
    %     iter = iter+1;                      % 迭代次数更新
    %     y_fitness(1,iter) = fzbest;         % 为绘图做准备
    %     K_p(1,iter) = zbest(1);
    %     K_i(1,iter) = zbest(2);
    if fzbest <=5e-7
        flag_success = 1;%成功置标志位
    end
end
bestnest = zbest;
fmin_out = fzbest;
iter_times = iter;
N_times = iter*n;


%% 绘图输出
[r,c]=size(trace);
figure
% plot([1:r]',trace(:,1),'r-',[1:r]',trace(:,2),'b--');
plot([1:r]',trace(:,2),'b--');
title(['PSO函数值曲线  ' '终止代数＝' num2str(MaxIter)],'fontsize',12);
xlabel('进化代数','fontsize',12);ylabel('函数值','fontsize',12);
legend('各代平均值','各代最佳值','fontsize',12);
% ylim([-0 1.01])
disp('函数值                   变量');
% 窗口显示
disp([fzbest zbest]);
toc
%%
% ret=[fzbest iter flag];
% end
