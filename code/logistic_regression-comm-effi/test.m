rng('default');


d = 10;
n = 20; % # of nodes
nn = 200*n;

%hyper-parameter
eta = 1e-4;
beta1 = 0.9;%varying beta1 0.9 0.8 0.7

M = 10; %dynamics
gamma= 1e-3;
%hyper-parameter
T=nn/n;

A = zeros(d,nn);
y = sign(rand(nn,1)-0.5);
for i=1:nn/n
    for j=1:n
        if y((i-1)*n+j,:) == 1
            A(:,(i-1)*n+j) = beta1*sin(i)*(rand(d,1)-0.5)...
                + (1-beta1)*(1+sin(i) + randn(d,1));
        else
            A(:,(i-1)*n+j) = beta1*sin(i)*(rand(d,1)-0.5)...
                + (1-beta1)*(-1+sin(i) + randn(d,1));
        end
        
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
        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i)))...
            + gamma*X_t_basic_lr(:,i); %gradient - basic lr
        
        Grad_basic(:,i) =  grad_basic;

    end
    X_t_basic_lr = X_t_basic_lr * W - eta/sqrt(t) * Grad_basic; %update rule - basic lr
   
    temp1 = log(1 + exp(-y((t-1)*n+1,:)*transpose(A(:,(t-1)*n+1))* X_t_basic_lr(:,1)));
    temp2 = gamma/2*(transpose(X_t_basic_lr(:,1))*X_t_basic_lr(:,1));
    Loss_basic_lr(:,1) = Loss_basic_lr(:,1) +  temp1 + temp2;
    
    %evaluate dynamic regret on the first node
    if mod(t,fix(T/5)) == 0

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

        fprintf('#rounds=%d | regret=%.0f | loss=%.0f\n',t,sum(Regret_basic_lr),sum(Loss_basic_lr));
        
        output = ['#rounds=' mat2str(t) ' | regret=' mat2str(round(sum(Regret_basic_lr)))...
            'loss=' mat2str(round(sum(Loss_basic_lr))) '\n'];
        fid=fopen('./output.txt','a');
        fprintf(fid,'%s\n',output);
        fclose(fid);

    end
    
    
    
    
    
    
    
end





%useful functions




