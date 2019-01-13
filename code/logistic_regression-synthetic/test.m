
%load data
fn = './spam.mat';
nn = 1000;
d = 20;


%hyper-parameter
T=nn;
eta = 1e-2;
lambda = 1e-1;
beta1 = 0.9;%varying beta1 0.9 0.8 0.7
beta2 = 0.8;
beta3 = 0.7;
%M = 10; %dynamics
n = 5; % # of nodes


A = zeros(d,nn);
y = sign(rand(nn,1)-0.5);
Xi = zeros(d,nn);
for i=1:nn
    if y(i,:) == 1
        A(:,i) = 1 + randn(d,1);
    else
        A(:,i) = -1 + randn(d,1);
    end
    Xi(:,i) = sin(i)*rand(d,1);
end

%compute the optimal reference point
%for basic
cvx_begin quiet
variable x_ast(d,1)
cumu_obj_basic_lr = sum( log(1 + exp( (repmat(-y(1:nn/100,:), 1, d)...
    .* transpose(A(:,1:nn/100)) )*x_ast)) );
minimize( cumu_obj_basic_lr );
cvx_end
x_opt_basic = x_ast;

%for beta1
cvx_begin quiet
variable x_ast(d,1)
cumu_obj_basic_lr = (1-beta1) * sum( log(1 + exp( (repmat(-y(1:nn/100,:), 1, d)...
    .* transpose(A(:,1:nn/100)) )*x_ast)) ) + beta1 * sum(Xi'* x_ast);
minimize( cumu_obj_basic_lr );
cvx_end        
x_opt_beta1 = x_ast;

%for beta2
cvx_begin quiet
variable x_ast(d,1)
cumu_obj_basic_lr = (1-beta2) * sum( log(1 + exp( (repmat(-y(1:nn/100,:), 1, d)...
    .* transpose(A(:,1:nn/100)) )*x_ast)) ) + beta2 * sum(Xi'* x_ast);
minimize( cumu_obj_basic_lr );
cvx_end        
x_opt_beta2 = x_ast;

%for beta3
cvx_begin quiet
variable x_ast(d,1)
cumu_obj_basic_lr = (1-beta3) * sum( log(1 + exp( (repmat(-y(1:nn/100,:), 1, d)...
    .* transpose(A(:,1:nn/100)) )*x_ast)) ) + beta3 * sum(Xi'* x_ast);
minimize( cumu_obj_basic_lr );
cvx_end        
x_opt_beta3 = x_ast;


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
Loss_basic_lr_opt = zeros(1,n);
Loss_our_lr1 = zeros(1,n);
Loss_our_lr1_opt = zeros(1,n);
Loss_our_lr2 = zeros(1,n);
Loss_our_lr2_opt = zeros(1,n);
Loss_our_lr3 = zeros(1,n);
Loss_our_lr3_opt = zeros(1,n);

loss_basic_lr = 0;
loss_our_lr1 = 0;
loss_our_lr2 = 0;
loss_our_lr3 = 0;

fprintf('Begin to itertion...\n');
tic;
for t=1:T/n
    
    for i=1:n % # of nodes
        
        y_it = y((t-1)*n+i,:);
        %y_it = sign(rand(1)-0.5);
        A_it = A(:,(t-1)*n+i);
        %A_it = randn(d,1);

        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i))); %gradient - basic lr
        grad_our_temp1 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr1(:,i)));
        grad_our_temp2 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr2(:,i)));
        grad_our_temp3 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr2(:,i)));
        xi_it = normrnd(0,0.1*abs(cos(t)),d,1);
        grad_h_t1 = xi_it;
        grad_h_t2 = xi_it;
        grad_h_t3 = xi_it;
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
        Loss_basic_lr_opt(:,i) = Loss_basic_lr(:,i) + log(1 + exp(-y_it*A_it' * x_opt_basic));
        Loss_our_lr1(:,i) = Loss_our_lr1(:,i) + beta1 * log(1 + exp(-y_it*A_it'*X_t_our_lr1(:,i))) + (1-beta1)...
            * (xi_it'*X_t_our_lr1(:,i));
        Loss_our_lr1_opt(:,i) = Loss_our_lr1_opt(:,i) + beta1 * log(1 + exp(-y_it*A_it'*x_opt_beta1)) + (1-beta1)...
            * (xi_it'*x_opt_beta1);
        Loss_our_lr2(:,i) = Loss_our_lr2(:,i) + beta2 * log(1 + exp(-y_it*A_it'*X_t_our_lr2(:,i))) + (1-beta2)...
            * (xi_it'*X_t_our_lr1(:,i));
        Loss_our_lr2_opt(:,i) = Loss_our_lr2_opt(:,i) + beta2 * log(1 + exp(-y_it*A_it'*x_opt_beta2)) + (1-beta2)...
            * (xi_it'*x_opt_beta2);
        Loss_our_lr3(:,i) = Loss_our_lr3(:,i) + beta3 * log(1 + exp(-y_it*A_it'*X_t_our_lr3(:,i))) + (1-beta3)...
            * (xi_it'*X_t_our_lr1(:,i));
        Loss_our_lr3_opt(:,i) = Loss_our_lr3_opt(:,i) + beta3 * log(1 + exp(-y_it*A_it'*x_opt_beta3)) + (1-beta3)...
            * (xi_it'*x_opt_beta3);
    end
    
    
    if mod(t,2000) == 0
        
        output = ['time=' mat2str(round(toc,1)) ' | regret-basic=' mat2str(sum(Loss_basic_lr - Loss_basic_lr_opt))...
            ' | regret-our(beta1)=' mat2str(sum(Loss_our_lr1 - Loss_our_lr1_opt))...
            ' | regret-our(beta2)=' mat2str(sum(Loss_our_lr2 - Loss_our_lr2_opt))...
            ' | regret-our(beta3)=' mat2str(sum(Loss_our_lr3 - Loss_our_lr3_opt))];
        fprintf([output '\n']);

        fid=fopen('./output.txt','a');
        fprintf(fid,'%s\n',output);
        fclose(fid);
    
    
    end
    
    
    
    
    
    
end




