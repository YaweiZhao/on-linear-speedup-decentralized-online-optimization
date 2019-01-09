
%load data
fn = './ijcnn1.mat';
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
beta = 0.9;%varying beta 0.9 0.8 0.7
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
X_t_our_lr = zeros(d,n);
Grad_basic = zeros(d,n);
Grad_our = zeros(d,n);
Regret_basic_lr = zeros(1,n);
Regret_our_lr = zeros(1,n);
Loss_basic_lr = zeros(1,n);
Loss_our_lr = zeros(1,n);

loss_basic_lr = 0;
loss_our_lr = 0;
tic;
for t=1:T
    
    for i=1:n % # of nodes
        y_it = y((t-1)*n+i,:);
        A_it = A(:,(t-1)*n+i);

        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i))); %gradient - basic lr
        grad_our_temp = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr(:,i)));
        grad_h_t = lambda * Q' * sign(Q*X_t_our_lr(:,i));
        grad_our = beta * grad_our_temp + (1-beta) * grad_h_t; %gradient - our lr
        Grad_basic(:,i) =  grad_basic;
        Grad_our(:,i) = grad_our;
    end
    X_t_basic_lr = X_t_basic_lr * W - eta * Grad_basic; %update rule - basic lr
    X_t_our_lr = X_t_our_lr * W - eta * Grad_our; %update rule - our lr
    
    for i=1:n
        %evaluate dynamic regret
        Loss_basic_lr(:,i) = Loss_basic_lr(:,i) + log(1 + exp(-y_it*A_it' * X_t_basic_lr(:,i)));
        Loss_our_lr(:,i) = Loss_our_lr(:,i) + beta * log(1 + exp(-y_it*A_it'*X_t_our_lr(:,i))) + (1-beta)...
            * lambda * norm(Q*X_t_our_lr(:,i), 2);
        
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
        cumu_obj_our_lr = trace( beta * log(1 + exp( repmat(-y(i:n:(t-1)*n+i,:), 1, d)...
            .* transpose(A(:,i:n:(t-1)*n+i)) *x_ast)))...
            +(1-beta) * sum(lambda * norms(Q*x_ast,2,1) );
        minimize( cumu_obj_our_lr );
        subject to
        norms( R * x_ast', 2 , 2) <= M; %dynamics M
        cvx_end
        Regret_our_lr(:,i) = Loss_our_lr(:,i) - cumu_obj_our_lr;


        
    end
    
    
    fprintf('time=%d | regret-basic=%.2f | regret-our=%.2f \n',...
        toc, sum(Regret_basic_lr), sum(Regret_our_lr));
    
    
    
    
    
    
    
    
    
    
    
end








%useful functions




