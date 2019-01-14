rng('default');

nn = 4000;
d = 10;
n = 20; % # of nodes

%hyper-parameter
eta = 1e-4;
beta1 = 0.9;%varying beta1 0.9 0.8 0.7
beta2 = 0.8;
beta3 = 0.7;
M = 0; %dynamics
gamma= 1e-3;
%hyper-parameter
T=nn/n;

A = zeros(d,nn);
y = sign(rand(nn,1)-0.5);
Xi = zeros(d,nn);
for i=1:nn/n
    for j=1:n
        if y((i-1)*n+j,:) == 1
            A(:,(i-1)*n+j) = -1+sin(i) + randn(d,1);
        else
            A(:,(i-1)*n+j) = 1+sin(i) + randn(d,1);
        end
        %Xi(:,(i-1)*n+j) = normrnd(0, 1+cos(i)/10,d,1);
        Xi(:,(i-1)*n+j) = (cos(i) +rand(d,1))/1000;
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

for t=1:T

    for i=1:n % # of nodes
        
        y_it = y((t-1)*n+i,:);
        A_it = A(:,(t-1)*n+i);
        xi_it = Xi(:,(t-1)*n+i);
        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i)))...
            + gamma*X_t_basic_lr(:,i); %gradient - basic lr
        grad_our_temp1 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr1(:,i)))...
            + gamma*X_t_our_lr1(:,i);
        grad_our_temp2 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr2(:,i)))...
            + gamma*X_t_our_lr2(:,i);
        grad_our_temp3 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr3(:,i)))...
            + gamma*X_t_our_lr3(:,i);
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
    X_t_basic_lr = X_t_basic_lr * W - eta/sqrt(t) * Grad_basic; %update rule - basic lr
    X_t_our_lr1 = X_t_our_lr1 * W - eta/sqrt(t)  * Grad_our1; %update rule - our lr
    X_t_our_lr2 = X_t_our_lr2 * W - eta/sqrt(t)  * Grad_our2; %update rule - our lr
    X_t_our_lr3 = X_t_our_lr3 * W - eta/sqrt(t)  * Grad_our3; %update rule - our lr
    temp1 = log(1 + exp(-y((t-1)*n+1,:)*transpose(A(:,(t-1)*n+1))* X_t_basic_lr(:,1)));
    temp2 = gamma/2*(transpose(X_t_basic_lr(:,1))*X_t_basic_lr(:,1));
    Loss_basic_lr(:,1) = Loss_basic_lr(:,1) +  temp1 + temp2;
    
    temp1 = log(1 + exp(-y((t-1)*n+1,:)*transpose(A(:,(t-1)*n+1))...
        *X_t_our_lr1(:,1))) + gamma/2*(transpose(X_t_our_lr1(:,1))*X_t_our_lr1(:,1));
    temp2 = transpose(Xi(:,(t-1)*n+1))*X_t_our_lr1(:,1);
    Loss_our_lr1(:,1) = Loss_our_lr1(:,1) + beta1 * temp1 + (1-beta1)*temp2;
    
    temp1 = log(1 + exp(-y((t-1)*n+1,:)*transpose(A(:,(t-1)*n+1))...
        *X_t_our_lr2(:,1)))+ gamma/2*(transpose(X_t_our_lr2(:,1))*X_t_our_lr2(:,1));
    temp2 = transpose(Xi(:,(t-1)*n+1))*X_t_our_lr2(:,1);
    Loss_our_lr2(:,1) = Loss_our_lr2(:,1) + beta2 * temp1 + (1-beta2)*temp2;
    
    temp1 = log(1 + exp(-y((t-1)*n+1,:)*transpose(A(:,(t-1)*n+1))...
        *X_t_our_lr3(:,1)))+ gamma/2*(transpose(X_t_our_lr3(:,1))*X_t_our_lr3(:,1));
    temp2 = transpose(Xi(:,(t-1)*n+1))*X_t_our_lr3(:,1);
    Loss_our_lr3(:,1) = Loss_our_lr3(:,1) + beta3 * temp1 + (1-beta3)*temp2;

    %evaluate dynamic regret on the first node
    if t==T

        %auxiliary matrix R
        R = zeros(t-1,t);
        for row = 1:t-1
            R(row, row) = 1;
            R(row, row+1) = -1;
        end

        % advantage = basic regre - basic lr

        cvx_begin quiet
        variable x_ast_basic(d,t)
        cumu_obj_basic_lr = log(1 + exp(ones(1,d) * (transpose(-y(1:n:(t-1)*n+1,:)*ones(1,d))...
            .* A(:,1:n:(t-1)*n+1) .* x_ast_basic)))*ones(t,1)...
            +gamma/2*(ones(1,d)*(x_ast_basic .* x_ast_basic)*ones(t,1));
        minimize( cumu_obj_basic_lr );
        subject to
        ones(1,t-1)*norms( R * x_ast_basic', 2 , 2) <= M; %dynamics M
        cvx_end

        
        Regret_basic_lr(:,1) = Loss_basic_lr(:,1) - cumu_obj_basic_lr;




        cvx_begin quiet
        variable x_ast1(d,t)
        temp1 = log(1 + exp(ones(1,d) *( transpose(-y(1:n:(t-1)*n+1,:)*ones(1,d))...
            .* A(:,1:n:(t-1)*n+1) .* x_ast1)))*ones(t,1);
        temp2 = gamma/2*(ones(1,d)*(x_ast1 .* x_ast1)*ones(t,1));
        temp3 = ones(1,d)*(Xi(:,1:n:(t-1)*n+1) .* x_ast1)* ones(t,1);
        cumu_obj_our_lr1 =  beta1 * (temp1 + temp2) +(1-beta1) * temp3;
        minimize( cumu_obj_our_lr1 );
        subject to
        ones(1,t-1)*norms( R * x_ast1', 2 , 2) <= M; %dynamics M
        cvx_end

        
        Regret_our_lr1(:,1) = Loss_our_lr1(:,1) - cumu_obj_our_lr1;

        cvx_begin quiet
        variable x_ast2(d,t)
        temp1 = log(1 + exp(ones(1,d) *( transpose(-y(1:n:(t-1)*n+1,:)*ones(1,d))...
            .* A(:,1:n:(t-1)*n+1) .* x_ast2)))*ones(t,1);
        temp2 = gamma/2*(ones(1,d)*(x_ast2 .* x_ast2)*ones(t,1));
        temp3 = ones(1,d)*(Xi(:,1:n:(t-1)*n+1) .* x_ast2)* ones(t,1);
        cumu_obj_our_lr2 =  beta2 * (temp1 + temp2) +(1-beta2) * temp3;
        minimize( cumu_obj_our_lr2 );
        subject to
        ones(1,t-1)*norms( R * x_ast2', 2 , 2) <= M; %dynamics M
        cvx_end

        
        Regret_our_lr2(:,1) = Loss_our_lr2(:,1) - cumu_obj_our_lr2;

        cvx_begin quiet
        variable x_ast3(d,t)
        temp1 = log(1 + exp(ones(1,d) *( transpose(-y(1:n:(t-1)*n+1,:)*ones(1,d))...
            .* A(:,1:n:(t-1)*n+1) .* x_ast3)))*ones(t,1);
        temp2 = gamma/2*(ones(1,d)*(x_ast3 .* x_ast3)*ones(t,1));
        temp3 = ones(1,d)*(Xi(:,1:n:(t-1)*n+1) .* x_ast3)* ones(t,1);
        cumu_obj_our_lr3 = beta3 * (temp1 + temp2) +(1-beta3) * temp3;
        minimize( cumu_obj_our_lr3 );
        subject to
        ones(1,t-1)*norms( R * x_ast3', 2 , 2) <= M; %dynamics M
        cvx_end

        
        Regret_our_lr3(:,1) = Loss_our_lr3(:,1) - cumu_obj_our_lr3;


        output = ['#rounds=' mat2str(t) ' | regret-basic=' mat2str(round(sum(Regret_basic_lr)))...
            ' | regret-our(beta1)=' mat2str(round(sum(Regret_our_lr1)))...
            ' | regret-our(beta2)=' mat2str(round(sum(Regret_our_lr2)))...
            ' | regret-our(beta3)=' mat2str(round(sum(Regret_our_lr3)))];
        fprintf('Begin [%d] iterations ...\n', t);
        fprintf([output '\n']);

        fid=fopen('./output.txt','a');
        fprintf(fid,'%s\n',output);
        fclose(fid);

    end
    
    
    
    
    
    
    
end





%useful functions




