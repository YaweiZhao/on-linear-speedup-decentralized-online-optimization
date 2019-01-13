rng('default');

nn = 500000;
d = 100;
n = 20; % # of nodes


%hyper-parameter
T=nn/n;
eta = 1e-3;
eta_opt_basic = eta*5;
eta_opt_1 = eta*5;
eta_opt_2 = eta*5;
eta_opt_3 = eta*5;

beta1 = 0.9;%varying beta1 0.9 0.8 0.7
beta2 = 0.80;
beta3 = 0.70;
%M = 10; %dynamics



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



%construct the confusion matrix W. Ring/random topology 
topology = 'random';
W =  eye(n);
if strcmp(topology, 'ring')
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
elseif strcmp(topology, 'random')
    graph = WattsStrogatz(n,3,1);
    edges_list = graph.Edges.EndNodes;
    [n_edges,~] = size(edges_list);
    for i=1:n_edges
        W(edges_list(i,1), edges_list(i,2)) = 1;
        W(edges_list(i,2), edges_list(i,1)) = 1;
    end
    for i=1:n
        W(i,:) = W(i,:)/sum(W(i,:));
    end
    
end


X_t_basic_lr = ones(d,n);
X_t_our_lr1 = ones(d,n);
X_t_our_lr2 = ones(d,n);
X_t_our_lr3 = ones(d,n);
Grad_basic = zeros(d,n);
Grad_our1 = zeros(d,n);
Grad_our2 = zeros(d,n);
Grad_our3 = zeros(d,n);


Regret_basic_lr = 0;
Regret_our_lr1 = 0;
Regret_our_lr2 = 0;
Regret_our_lr3 = 0;
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
for t=1:T
    
    for i=1:n % # of nodes
        
        y_it = y((t-1)*n+i,:);
        %y_it = sign(rand(1)-0.5);
        A_it = A(:,(t-1)*n+i);
        %A_it = randn(d,1);
        xi_it = Xi(:,(t-1)*n+i);
        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i))); %gradient - basic lr
        grad_our_temp1 = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_our_lr1(:,i))) ;
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
    
    X_t_basic_lr_opt = X_t_basic_lr;
    X_t_our_lr1_opt = X_t_our_lr1;
    X_t_our_lr2_opt = X_t_our_lr2;
    X_t_our_lr3_opt = X_t_our_lr3;
    
    
    X_t_basic_lr = X_t_basic_lr * W - eta/sqrt(t) * Grad_basic; %update rule - basic lr
    X_t_our_lr1 = X_t_our_lr1 * W - eta/sqrt(t) * Grad_our1; %update rule - our lr
    X_t_our_lr2 = X_t_our_lr2 * W - eta/sqrt(t) * Grad_our2; %update rule - our lr
    X_t_our_lr3 = X_t_our_lr3 * W - eta/sqrt(t) * Grad_our3; %update rule - our lr
    
    
    
    X_t_basic_lr_opt = X_t_basic_lr_opt * W - eta_opt_basic/sqrt(t) * Grad_basic; %update rule - basic lr
    X_t_our_lr1_opt = X_t_our_lr1_opt* W - eta_opt_1/sqrt(t) * Grad_our1;
    X_t_our_lr2_opt = X_t_our_lr2_opt* W - eta_opt_2/sqrt(t) * Grad_our2;
    X_t_our_lr3_opt = X_t_our_lr3_opt* W - eta_opt_3/sqrt(t) * Grad_our3;

    
    
    for i=1:n
        xi_it = Xi(:,(t-1)*n+i);
        %evaluate dynamic regret
        Loss_basic_lr(:,i) = Loss_basic_lr(:,i) + log(1 + exp(-y_it*A_it' * X_t_basic_lr(:,i)));
        Loss_basic_lr_opt(:,i) = Loss_basic_lr_opt(:,i) + log(1 + exp(-y_it*A_it' * X_t_basic_lr_opt(:,i)));
        Regret_basic_lr = Regret_basic_lr + max(0,Loss_basic_lr(:,i)  - Loss_basic_lr_opt(:,i) );
        
        Loss_our_lr1(:,i) = Loss_our_lr1(:,i) + beta1 * log(1 + exp(-y_it*A_it'*X_t_our_lr1(:,i))) + (1-beta1)...
            * (xi_it'*X_t_our_lr1(:,i));
        Loss_our_lr1_opt(:,i) = Loss_our_lr1_opt(:,i) + beta1 * log(1 + exp(-y_it*A_it'*X_t_our_lr1_opt(:,i))) + (1-beta1)...
            * (xi_it'*X_t_our_lr1_opt(:,i));
        Regret_our_lr1 = Regret_our_lr1 + max(0,Loss_our_lr1(:,i)-Loss_our_lr1_opt(:,i));
        
        Loss_our_lr2(:,i) = Loss_our_lr2(:,i) + beta2 * log(1 + exp(-y_it*A_it'*X_t_our_lr2(:,i))) + (1-beta2)...
            * (xi_it'*X_t_our_lr2(:,i));
        Loss_our_lr2_opt(:,i) = Loss_our_lr2_opt(:,i) + beta2 * log(1 + exp(-y_it*A_it'*X_t_our_lr2_opt(:,i))) + (1-beta2)...
            * (xi_it'*X_t_our_lr2_opt(:,i));
        Regret_our_lr2 = Regret_our_lr2 + max(0,Loss_our_lr2(:,i)-Loss_our_lr2_opt(:,i));
        
        Loss_our_lr3(:,i) = Loss_our_lr3(:,i) + beta3 * log(1 + exp(-y_it*A_it'*X_t_our_lr3(:,i))) + (1-beta3)...
            * (xi_it'*X_t_our_lr3(:,i));
        Loss_our_lr3_opt(:,i) = Loss_our_lr3_opt(:,i) + beta3 * log(1 + exp(-y_it*A_it'*X_t_our_lr3_opt(:,i))) + (1-beta3)...
            * (xi_it'*X_t_our_lr3_opt(:,i));
        Regret_our_lr3 = Regret_our_lr3 + max(0,Loss_our_lr3(:,i)-Loss_our_lr3_opt(:,i));
    end
    
    
    if mod(t,5000) == 0
        
        output = ['time=' mat2str(round(toc,1)) ' | regret-basic=' mat2str(Regret_basic_lr)...
            ' | regret-our(beta1)=' mat2str(Regret_our_lr1)...
            ' | regret-our(beta2)=' mat2str(Regret_our_lr2)...
            ' | regret-our(beta3)=' mat2str(Regret_our_lr3)];
        fprintf([output '\n']);

        fid=fopen('./output.txt','a');
        fprintf(fid,'%s\n',output);
        fclose(fid);
    
    
    end
    
    
    
    
    
    
end




