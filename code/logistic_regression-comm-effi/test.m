rng('default');

corenum = 4;
if parpool('size') <= 0
    parpool('open', 'local', corenum);
    fprintf('Begin parallel computing, %d cores...\n', corenum);
else
    fprintf('Alread begin parallel computing, %d cores...\n', corenum);
end



nn = 400;
d = 100;
n = 20; % # of nodes

%hyper-parameter
eta = 1e-2;
lambda = 1e-1;
beta1 = 0.9;%varying beta1 0.9 0.8 0.7
beta2 = 0.8;
beta3 = 0.7;
M = 10; %dynamics

%hyper-parameter
T=nn/n;

A = zeros(d,nn);
y = sign(rand(nn,1)-0.5);
Xi = zeros(d,nn);
for i=1:nn/n
    for j=1:n
        if y((i-1)*n+j,:) == 1
            A(:,(i-1)*n+j) = sin(i)/10 + randn(d,1);
        else
            A(:,(i-1)*n+j) = -sin(i)/10 + randn(d,1);
        end
        Xi(:,(i-1)*n+j) = normrnd(0, (cos(i)+1)/10,d,1);
    end
    
    
end


%construct the confusion matrix W. Ring topology 
W =  eye(n);
for i=1:n
    for j=1:n
        if i==n
             W(i,1) = 1;
        end
        if i+1 <= n && j == i+1
            W(i,j) = 1;
        end
        if i==1
            W(i,n) = 1;
        end
        if i-1>=1 && j == i-1
            W(i,j) = 1;
        end
    end
end
W = W/3;




%online learning
Q = zeros(d-1,d);
for row = 1:d-1
    Q(row,row) = 1; Q(row,row+1) = -1;
end

X_t_basic_lr = zeros(d,n);
X_t_our_lr1 = zeros(d,n);
X_t_our_lr2 = zeros(d,n);
X_t_our_lr3 = zeros(d,n);
Grad_basic = zeros(d,n);
Grad_our1 = zeros(d,n);
Grad_our2 = zeros(d,n);
Grad_our3 = zeros(d,n);


Regret_basic_lr = zeros(1,n);
Regret_our_lr1 = zeros(1,n);
Regret_our_lr2 = zeros(1,n);
Regret_our_lr3 = zeros(1,n);
Loss_basic_lr = zeros(1,n);
Loss_our_lr1 = zeros(1,n);
Loss_our_lr2 = zeros(1,n);
Loss_our_lr3 = zeros(1,n);

loss_basic_lr = 0;
loss_our_lr1 = 0;
loss_our_lr2 = 0;
loss_our_lr3 = 0;
tic;
fprintf('Begin iterations ...\n');
for t=1:T
    
    for i=1:n % # of nodes
        y_it = y((t-1)*n+i,:);
        A_it = A(:,(t-1)*n+i);
        xi_it = Xi(:,(t-1)*n+i);
        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i))); %gradient - basic lr
        grad_our_temp1 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr1(:,i)));
        grad_our_temp2 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr2(:,i)));
        grad_our_temp3 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr3(:,i)));
        grad_h_t1 = xi_it;
        grad_h_t2 = xi_it;
        grad_h_t3 = xi_it;
        grad_our1 = beta1 * grad_our_temp1 + (1-beta1) * grad_h_t1; %gradient - our lr
        grad_our2 = beta2 * grad_our_temp2 + (1-beta2) * grad_h_t2; %gradient - our lr
        grad_our3 = beta3 * grad_our_temp3 + (1-beta3) * grad_h_t3; %gradient - our lr
        Grad_basic(:,i) =  grad_basic;
        Grad_our1(:,i) = grad_our1;
        Grad_our2(:,i) = grad_our2;
        Grad_our3(:,i) = grad_our3;
    end
    X_t_basic_lr = X_t_basic_lr * W - eta * Grad_basic; %update rule - basic lr
    X_t_our_lr1 = X_t_our_lr1 * W - eta * Grad_our1; %update rule - our lr
    X_t_our_lr2 = X_t_our_lr2 * W - eta * Grad_our2; %update rule - our lr
    X_t_our_lr3 = X_t_our_lr3 * W - eta * Grad_our3; %update rule - our lr
    
    for i=1:n
        %evaluate dynamic regret
        Loss_basic_lr(:,i) = Loss_basic_lr(:,i) + log(1 + exp(-y_it*A_it' * X_t_basic_lr(:,i)));
        Loss_our_lr1(:,i) = Loss_our_lr1(:,i) + beta1 * log(1 + exp(-y_it*A_it'*X_t_our_lr1(:,i))) + (1-beta1)...
            * (xi_it'*X_t_our_lr1(:,i));
        Loss_our_lr2(:,i) = Loss_our_lr2(:,i) + beta2 * log(1 + exp(-y_it*A_it'*X_t_our_lr2(:,i))) + (1-beta2)...
            * (xi_it'*X_t_our_lr2(:,i));
        Loss_our_lr3(:,i) = Loss_our_lr3(:,i) + beta3 * log(1 + exp(-y_it*A_it'*X_t_our_lr3(:,i))) + (1-beta3)...
            * (xi_it'*X_t_our_lr3(:,i));
        
        %auxiliary matrix R
        R = zeros(t-1,t);
        for row = 1:t-1
            R(row, row) = 1;
            R(row, row+1) = -1;
        end
        
        % advantage = basic regre - basic lr
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_basic_lr = ones(1,d)*log(1 + exp( transpose(-y(i:n:(t-1)*n+i,:)*ones(1,d))...
            .* A(:,i:n:(t-1)*n+i) .* x_ast))*ones(t,1);
        minimize( cumu_obj_basic_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_basic_lr(:,i) = Loss_basic_lr(:,i) - cumu_obj_basic_lr;
        
        
        
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_our_lr =  beta1 * ones(1,d)*log(1 + exp( transpose(-y(i:n:(t-1)*n+i,:)*ones(1,d))...
            .* A(:,i:n:(t-1)*n+i) .* x_ast))*ones(t,1)...
            +(1-beta1) * ones(1,d)*(Xi(:,i:n:(t-1)*n+i) .* X_t_our_lr1(:,i:n:(t-1)*n+i))* ones(1:t,1);
        minimize( cumu_obj_our_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_our_lr1(:,i) = Loss_our_lr1(:,i) - cumu_obj_our_lr;
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_our_lr =  beta2 * ones(1,d)*log(1 + exp( transpose(-y(i:n:(t-1)*n+i,:)*ones(1,d))...
            .* A(:,i:n:(t-1)*n+i) .* x_ast))*ones(t,1)...
            +(1-beta2) * ones(1,d)*(Xi(:,i:n:(t-1)*n+i) .* X_t_our_lr1(:,i:n:(t-1)*n+i))* ones(1:t,1);
        minimize( cumu_obj_our_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_our_lr2(:,i) = Loss_our_lr2(:,i) - cumu_obj_our_lr;
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_our_lr =  beta3 * ones(1,d)*log(1 + exp( transpose(-y(i:n:(t-1)*n+i,:)*ones(1,d))...
            .* A(:,i:n:(t-1)*n+i) .* x_ast))*ones(t,1)...
            +(1-beta3) * ones(1,d)*(Xi(:,i:n:(t-1)*n+i) .* X_t_our_lr1(:,i:n:(t-1)*n+i))* ones(1:t,1);
        minimize( cumu_obj_our_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_our_lr3(:,i) = Loss_our_lr3(:,i) - cumu_obj_our_lr;


        
    end
    
    output = ['#rounds=' mat2str(t) ' | regret-basic=' mat2str(round(sum(Regret_basic_lr),2))...
        ' | regret-our(beta1)=' mat2str(round(sum(Regret_our_lr1),2))...
        ' | regret-our(beta2)=' mat2str(round(sum(Regret_our_lr2),2))...
        ' | regret-our(beta3)=' mat2str(round(sum(Regret_our_lr3),2))];
    fprintf([output '\n']);
    
    fid=fopen('./output.txt','a');
    fprintf(fid,'%s\n',output);
    fclose(fid);
    
    
    
    
    
    
    
    
    
end


parpool close;





%useful functions




