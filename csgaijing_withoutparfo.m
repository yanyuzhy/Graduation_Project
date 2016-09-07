

% clc
% clear all
% close all
global nest best fmin fitness best_ind best_ind_fitness Vstep c1 c2 w Vmax Vmin alpha levy_times beta p_s p_m rate;
global p_e;
% if nargin<1,
    % Number of nests (or different solutions)
    n=24;
    dim =2;
        ObjFun = @Rastrigin;
%         ObjFun = @PSO_PID;
%     ObjFun = @Rosenbrock;
%     ObjFun = @Griewank;
% end
flag_success = 0;
% Discovery rate of alien eggs/solutions
pa=0.75;

%% Change this if you want to get better results
N_IterTotal=303;
%% Simple bounds of the search domain
% Lower bounds
nd=dim;
Lb=-2*ones(1,nd);
% Upper bounds
Ub=2*ones(1,nd);
alpha = 1;
beta=1;
levy_times=1;
p_s=0.2;
p_m=1;p_e = 1;
rate = 0.2;
p_min = 0.4;
%% PSO parameters c1为全局最优，c2为个体最优
c1=2;  c2=2;  w=0.5;  Vmax=0.2;  Vmin=-0.2;
Vstep = rand(n,dim)*(Vmax-Vmin) + Vmin;
best_ind=zeros(n,nd);
fitness=10^10*ones(n,1);
best_ind_fitness=fitness;
%%
% Random initial solutions
for i=1:n
    nest(i,:)=Lb+(Ub-Lb).*rand(size(Lb));
    %     nest(i,:)=Lb+(Ub-Lb).*rand(size(Lb));
    fitness(i)=fobj(nest(i,:),ObjFun);
end
best_ind=nest;
best_ind_fitness=fitness;
[fmin,K]=min(fitness);
best=nest(K,:);
% Get the current best

N_iter=0;
%% Starting iterations
flag =0;%%操作是否执行
iter=1;
% for iter=1:N_IterTotal,
fmin_temp1 = fmin;
% fmin_temp2 = fmin;
f_dec1 =0;f_dec2=0;f_dec3 = 0;
while(iter<N_IterTotal)
    %     % Generate new solutions (but keep the current best)
    tic
    fmin_temp1 = fmin;
    if rand < p_s
        pso_search(Lb,Ub,ObjFun);%粒子群寻优
        flag=1;
        N_iter=N_iter+n;
        f_dec1 = f_dec1 + fmin_temp1 - fmin;
        %         fmin_temp1 = fmin;
    end
    
    fmin_temp1 = fmin;
    if rand < p_m
        cs_search(Lb,Ub,ObjFun);
%         empty_nests(Lb,Ub,pa,ObjFun);
        flag=1;
        N_iter=N_iter+n;
%         N_iter=N_iter+n;
        f_dec2 = f_dec2 + fmin_temp1 - fmin;
    end

    fmin_temp1 = fmin;
    if rand <p_e %均执行
        empty_nests(Lb,Ub,pa,ObjFun);
        flag=1;
        N_iter=N_iter+n;
        %         fmin_temp2 = fmin;
        f_dec3 = f_dec3 + fmin_temp1 - fmin;
    end
    
 %算符执行概率更新
if mod(iter,20)==0
    
    if f_dec1>f_dec2 && f_dec1>f_dec3%
%         p_s=iter/2000;
%         if p_s > 0.1 p_s =0.1; end

%         p_m=0.8;
%         p_e = 0.8;
        p_s = 0.6;
        p_m=1*(f_dec2/f_dec1)+0.001;
        p_e=1*(f_dec3/f_dec1)+0.001;
        if p_m <p_min  p_m=p_min; end
        if p_m >1 p_m = 1; end
        if p_e <p_min  p_e=p_min; end
        if p_e >1 p_e = 1; end
        if iter >500 p_s = 0.5;end;
        if iter >1000 p_s = 0.2;end;
    elseif f_dec2>f_dec1 && f_dec2>f_dec3   %
%         p_s = 0.6;
        p_m = 1;
%         p_e = 0.8;
        p_s=p_m*(f_dec1/f_dec2)+0.001;
        p_e=p_m*(f_dec3/f_dec2)+0.001;
        if p_s <0.1  p_s=0.1; end
        if p_s >1 p_s = 1; end
        if p_e <p_min  p_e=p_min; end
        if p_e >1 p_e = 1; end
    elseif f_dec3>f_dec1 && f_dec3>f_dec2
        p_e=1;
        p_s=p_e*(f_dec1/f_dec3)+0.001;
        p_m=p_e*(f_dec2/f_dec3)+0.001;
        if p_s <0.1  p_s=0.1; end
        if p_s >1 p_s = 1; end
        if p_m <p_min  p_m=p_min; end
        if p_m >1 p_m = 1; end
    else
        p_s=0.2;
        p_m=1;
        p_e=1;
    end
    f_dec1 = 0;
    f_dec2 = 0;
    f_dec3 = 0;
end
    
    % Update the counter again
    if flag==1
        flag=0;
        % Find the best objective so far
        fitness_list(iter)=fmin;
        fitness_list_all(:,iter)=fitness;
        bestnest_list(iter,:)=best;
        p_s_list(iter)=p_s;
        p_m_list(iter)=p_m;
        p_e_list(iter)=p_e;
        iter = iter+1
    end
%     toc
    if fmin<5e-7
        flag_success = 1;%搜索成功置标志位
        break;
    end
    %     alpha = alpha*100000/iter;
end %% End of iterations

%% Post-optimization processing
bestnest = best
fmin_out = fmin
iter_times = iter
N_times = N_iter
%% Display all the nests


best
plot(fitness_list);
figure();
plot(fitness_list_all');
figure()
plot([p_s_list;p_m_list;p_e_list]');
legend('p_s', 'p_m','p_e');
fmin
disp(strcat('Total number of iterations=',num2str(N_iter)));
% end