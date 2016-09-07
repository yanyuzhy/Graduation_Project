function empty_nests(Lb,Ub,pa,ObjFun)
global nest best fmin fitness best_ind best_ind_fitness Vstep c1 c2 w Vmax Vmin beta;
% [fitness k]=sort(fitness);
% nest_temp = nest(k,:);
% nest = nest_temp;

n=size(nest,1);
K=rand(size(nest))>pa;
stepsize=rand*(nest(randperm(n),:)-nest(randperm(n),:))+ -1+2*rand;
% stepsize=rand*(nest(randperm(n-12),:)-nest(randperm(n-12),:));
% stepsize(14:25,:)=rand*(nest(randperm(n-12,12),:)-nest(randperm(n-12,12),:));

new_nest=nest+beta*stepsize.*K;
parfor j=1:size(new_nest,1)
    s=new_nest(j,:);
    new_nest(j,:)=simplebounds(s,Lb,Ub);
    fitness_new(j) = fobj(new_nest(j,:),ObjFun);
end

for j=1:size(new_nest,1)
    if fitness_new(j)<best_ind_fitness(j)%个体最优更新
        best_ind_fitness(j)=fitness_new(j);
        best_ind(j,:) = new_nest(j,:);
    end
    if fitness_new(j)<fitness(j)%个体最优更新
        nest(j,:) = new_nest(j,:);
        fitness(j)=fitness_new(j);
    end
    if fitness_new(j)<fmin %全体最优更新
        fmin=fitness_new(j);
        best = new_nest(j,:);
    end
end
end