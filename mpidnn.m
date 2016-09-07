function uu = mpidnn(u,WW)
t = u(end);
persistent x y1 uu1 V_TEMP ST1 ST2 t_1;
persistent hidenlayer input_d output_d hidenlayer_d xite alfa I_temp D_temp layer_vector layer_yz Dlayer_yz_1 Dlayer_yz_2 W;
persistent DW_1 DW_2 up_b down_b;
if t==0
    t_1 = t;
    up_b=6;
    down_b=-6;
%     up_b = max(abs(u(1:4)));
%     down_b = -up_b;
    hidenlayer=1;                 %隐层数
    input_d=2;                    %输入维数
    output_d=2;                   %输出向量维数
    hidenlayer_d=6;               %隐层维数
    xite=0.01;                    %动量因子
    alfa=0.005;                       %学习率
    % input_vector=rand(input_d,1);  %数据输入向量
    % exp_vector=rand(output_d,1);   %期望输出向量
    I_temp=zeros(hidenlayer_d,1);
    D_temp = zeros(hidenlayer_d,1);
    
    ST1 =  zeros(hidenlayer_d,1);
    ST2 =zeros(hidenlayer_d,1);
    y1 = zeros(input_d,3);
    uu1 = zeros(output_d,3);
    
    %% 输入输出向量
    layer_vector{1}=zeros(input_d,1);%输入向量
    for i=2:hidenlayer+1
        layer_vector{i}=zeros(hidenlayer_d,1);%隐层输出
    end
    layer_vector{hidenlayer+2}=zeros(output_d,1);%输出向量
    V_TEMP= layer_vector{2};
    
    
    
    %% 权值
    W{1}=rand(hidenlayer_d,input_d);
    for i=2:hidenlayer
        W{i}=rand(hidenlayer_d,hidenlayer_d);
    end
    W{hidenlayer+1}=rand(output_d,hidenlayer_d);
    DW_1=W;%权值改变量
    DW_2=W;%权值改变量
    
    %     x=-1+rand(1,36).*2;
    x=WW;
    temp(:,1)=x(1:6)';
    temp(:,2)=x(7:12)';
    W{1} = temp;
    temp2(1,:)=x(13:18);
    temp2(2,:)=x(19:24);
    %     temp2(3,:)=x(25:30);
    %     temp2(4,:)=x(31:36);
    W{2} = temp2;
    
    
    uu = layer_vector{3};
%     load('3-7-3.mat');
    return;
end
y1(:,2:3) = y1(:,1:2);
y1(:,1) = [u(3);u(4)];
if t-t_1>=0.05
    
    % if t>=1
    t_1 =t;
    if t>120
%      if abs(u(1))<0.35 && abs(u(2))<0.35
        %% 反向学习
        
        e=u(1:2);%计算输出误差
        e=tansig(e);
        A = (y1(:,1)-y1(:,2))*(1./(uu1(:,1)-uu1(:,2)+1E-20))';
        A = sign(A)';
        delta{hidenlayer+1}=A*e;
        % delta{hidenlayer+1}=e;%计算输出层deta
        DW_1{hidenlayer+1}=delta{hidenlayer+1}*layer_vector{hidenlayer+1}';%计算权值修改量
        for i=hidenlayer:-1:1
            %     delta{i}=(delta{i+1}'*W{i+1})'.*(layer_vector{i+1}+1).*(1-layer_vector{i+1}); %计算中间层delta值
            B = (layer_vector{2}-V_TEMP)./((ST1-ST2)+1e-20);
            B=sign(B);
            delta{i}=(delta{i+1}'*W{i+1})'.*B;
            DW_1{i}=delta{i}*layer_vector{i}';%计算中间层权值修改量
        end
        
        for i=1:hidenlayer+1 %修改权值和阈值
            W{i}=W{i}+xite.*DW_1{i}+alfa.*DW_2{i};
            DW_2{i}=DW_1{i};
        end
    end
    
    
    %% 前向传递
    
    u(find(u>=up_b))=up_b;
    u(find(u<=down_b))=down_b;
    V_TEMP = layer_vector{2};
    layer_vector{1}=[u(1);u(2)];
    for i=1:hidenlayer
        %     layer_vector{i+1}=W{i}*layer_vector{i}-layer_yz{i};
        %     layer_vector{i+1}=(1./(1+exp(-layer_vector{i+1})));
        sum=W{i}*layer_vector{i};%-layer_yz{i};
        %             layer_vector{i+1}=tansig(sum);%bp网络
        %     sum = tansig(sum).*up_b;
        ST2 = ST1;
        ST1 = sum;
        layer_vector{i+1}(1:3:end)=sum(1:3:end);%比例神经元
        layer_vector{i+1}(2:3:end)=sum(2:3:end)+I_temp(2:3:end);%积分神经元
        layer_vector{i+1}(3:3:end)=sum(3:3:end)-D_temp(3:3:end);%微分神经元
        layer_vector{i+1} = tansig(layer_vector{i+1}).*up_b;
        I_temp = layer_vector{i+1};
        D_temp = sum;
    end
    % layer_vector{hidenlayer+2}=W{hidenlayer+1}*layer_vector{hidenlayer+1};
    % layer_vector{hidenlayer+2}=(1./(1+exp(-layer_vector{hidenlayer+2})));
    sum=W{hidenlayer+1}*layer_vector{hidenlayer+1};%-layer_yz{hidenlayer+1};
    sum(find(sum>=up_b))=up_b;
    sum(find(sum<=down_b))=down_b;
    layer_vector{hidenlayer+2}=sum;
    uu = layer_vector{hidenlayer+2};
    uu1(:,2:3) = uu1(:,1:2);
    uu1(:,1) = uu;
else
%     if t == 99
%         save('3-7-2.mat','W');
%     end
    uu = uu1(:,1);
end
end