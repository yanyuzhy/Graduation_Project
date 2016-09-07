function  pso_search(Lb,Ub,ObjFun)
% 速度更新
%
global nest best fmin fitness best_ind best_ind_fitness Vstep c1 c2 w Vmax Vmin levy_times rate p_s p_m;
n=size(nest,1);
m = n;
% [fitness_temp k]=sort(fitness);%%%不能够打乱原来的顺序，只需把前20位的粒子按照PSO算法执行即可
for i = 1:m
    Vstep(i,:)=w*Vstep(i,:)+c1*rand*(best-nest(i,:))+c2*rand*(best_ind(i,:)-nest(i,:));%仅使用全局最优值进行引导
    Vstep(i,find(Vstep(i,:)>Vmax))=Vmax;
    Vstep(i,find(Vstep(i,:)<Vmin))=Vmin;
end
for i = 1:m %位置更新
    newnest(i,:) = nest(i,:)+Vstep(i,:);
    s= newnest(i,:);
    nest(i,:)=simplebounds(s,Lb,Ub);
end
% fiteness_temp = ones(1,m)*10^10;
parfor i = 1:m%计算适应度
    fiteness(i)=fobj(nest(i,:),ObjFun);
end
for i = 1:m  %种群更新
    if fitness(i)<best_ind_fitness(i)%个体最优更新
        best_ind_fitness(i)=fitness(i);
        best_ind(i,:) = nest(i,:);
    end
    if fitness(i)<fmin %全体最优更新
        fmin=fitness(i);
        best = nest(i,:);
    end
end
end