
%load data
fn = './occupancy.mat';
data = load(fn);
data = data.data;
[nn,d] = size(data);
A = transpose(data(:,2:d));
y = data(:,1);
d = d-1;

%hyper-parameter
T=500;
eta = 1e-2;
lambda = 1e-1;
beta1 = 0.9;%varying beta1 0.9 0.8 0.7
beta2 = 0.8;
beta3 = 0.7;
M = 10; %dynamics
n = 5; % # of nodes

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

        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i))); %gradient - basic lr
        grad_our_temp1 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr1(:,i)));
        grad_our_temp2 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr2(:,i)));
        grad_our_temp3 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr2(:,i)));
        grad_h_t1 = lambda * Q' * sign(Q*X_t_our_lr1(:,i));
        grad_h_t2 = lambda * Q' * sign(Q*X_t_our_lr2(:,i));
        grad_h_t3 = lambda * Q' * sign(Q*X_t_our_lr3(:,i));
        grad_our1 = beta1 * grad_our_temp1 + (1-beta1) * grad_h_t1; %gradient - our lr
        grad_our2 = beta2 * grad_our_temp2 + (1-beta2) * grad_h_t2; %gradient - our lr
        grad_our3 = beta1 * grad_our_temp3 + (1-beta3) * grad_h_t3; %gradient - our lr
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
            * lambda * norm(Q*X_t_our_lr1(:,i), 2);
        Loss_our_lr2(:,i) = Loss_our_lr2(:,i) + beta2 * log(1 + exp(-y_it*A_it'*X_t_our_lr2(:,i))) + (1-beta2)...
            * lambda * norm(Q*X_t_our_lr2(:,i), 2);
        Loss_our_lr3(:,i) = Loss_our_lr3(:,i) + beta3 * log(1 + exp(-y_it*A_it'*X_t_our_lr3(:,i))) + (1-beta3)...
            * lambda * norm(Q*X_t_our_lr3(:,i), 2);
        
        %auxiliary matrix R
        R = zeros(t-1,t);
        for row = 1:t-1
            R(row, row) = 1;
            R(row, row+1) = -1;
        end
        
        % advantage = basic regre - basic lr
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_basic_lr = trace( log(1 + exp( (repmat(-y(i:n:(t-1)*n+i,:), 1, d)...
            .* transpose(A(:,i:n:(t-1)*n+i)) )*x_ast)) );
        minimize( cumu_obj_basic_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_basic_lr(:,i) = Loss_basic_lr(:,i) - cumu_obj_basic_lr;
        
        
        
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_our_lr = trace( beta1 * log(1 + exp( repmat(-y(i:n:(t-1)*n+i,:), 1, d)...
            .* transpose(A(:,i:n:(t-1)*n+i)) *x_ast)))...
            +(1-beta1) * sum(lambda * norms(Q*x_ast,2,1) );
        minimize( cumu_obj_our_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_our_lr1(:,i) = Loss_our_lr1(:,i) - cumu_obj_our_lr;
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_our_lr = trace( beta2 * log(1 + exp( repmat(-y(i:n:(t-1)*n+i,:), 1, d)...
            .* transpose(A(:,i:n:(t-1)*n+i)) *x_ast)))...
            +(1-beta2) * sum(lambda * norms(Q*x_ast,2,1) );
        minimize( cumu_obj_our_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_our_lr2(:,i) = Loss_our_lr2(:,i) - cumu_obj_our_lr;
        
        cvx_begin quiet
        variable x_ast(d,t)
        cumu_obj_our_lr = trace( beta3 * log(1 + exp( repmat(-y(i:n:(t-1)*n+i,:), 1, d)...
            .* transpose(A(:,i:n:(t-1)*n+i)) *x_ast)))...
            +(1-beta3) * sum(lambda * norms(Q*x_ast,2,1) );
        minimize( cumu_obj_our_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_our_lr3(:,i) = Loss_our_lr3(:,i) - cumu_obj_our_lr;


        
    end
    
    output = ['time=' mat2str(round(toc,1)) ' | regret-basic=' mat2str(round(sum(Regret_basic_lr),2))...
        ' | regret-our(beta1)=' mat2str(round(sum(Regret_our_lr1),2))...
        ' | regret-our(beta2)=' mat2str(round(sum(Regret_our_lr2),2))...
        ' | regret-our(beta3)=' mat2str(round(sum(Regret_our_lr3),2))];
    fprintf([output '\n']);
    
    fid=fopen('./output.txt','a');
    fprintf(fid,'%s\n',output);
    fclose(fid);
    
    
    
    
    
    
    
    
    
end








%useful functions




