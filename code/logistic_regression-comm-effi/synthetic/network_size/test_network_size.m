clc;
clear all;
rng('default');
d = 10;
n = 15e3; % # of nodes
nn = 2000*n;

%hyper-parameter
beta1 = 0.1;

M = 10; %dynamics

gamma= 1e-3;
%hyper-parameter
T=nn/n;



%construct the confusion matrix W. Ring topology 
tag = 'decentralized';
topology = 'watts';
if strcmp(tag, 'centralized')
    W = load('centralized_W_10e3nodes.mat');
    W = W.W;
    %W =  ones(n,n)/n;
    %save('centralized_W_10e3nodes.mat', 'W');
elseif strcmp(tag, 'decentralized') && strcmp(topology, 'watts')
%     W = load('watts1_W_10e3nodes.mat');
%     W = W.W;
    graph = WattsStrogatz(n,50,1);
    edges_list = graph.Edges.EndNodes;
    [n_edges,~] = size(edges_list);
    W = eye(n);
    for i=1:n_edges
        W(edges_list(i,1), edges_list(i,2)) = 1;
        W(edges_list(i,2), edges_list(i,1)) = 1;
    end
    for i=1:n
        W(i,:) = W(i,:)/sum(W(i,:));
    end
    save('watts1_W_15e3nodes.mat', 'W');
elseif strcmp(tag, 'decentralized') && strcmp(topology, 'guli')
    W = load('guli_W_10e3nodes.mat');
    W = W.W;
    %W = eye(n);
    %save('guli_W_10e3nodes.mat', 'W');
elseif strcmp(tag, 'decentralized') && strcmp(topology, 'ring')
    W = load('ring_W_10e3nodes.mat');
    W = W.W;
%     W =  eye(n);
%     for i=1:n
%         for j=1:n
%             if i==n
%                  W(i,1) = 1;
%             end
%             if i+1 <= n && j == i+1
%                 W(i,j) = 1;
%             end
%             if i==1
%                 W(i,n) = 1;
%             end
%             if i-1>=1 && j == i-1
%                 W(i,j) = 1;
%             end
%         end
%     end
%     W = W/3;
%     save('ring_W_10e3nodes.mat', 'W');
end


X_t_basic_lr = zeros(d,n);
Grad_basic = zeros(d,n);
Regret_basic_lr = zeros(1,n);
Loss_basic_lr = zeros(1,n);
Cumu_Loss_basic_lr = zeros(1,n);

ave_loss_basic_lr_seq = zeros(T,1);

tic;
cumu_loss_draw = [];
loss_draw = [];

%compute variance

y = sign(rand(1,n)-0.5);
A = beta1*(rand(d,n)-0.5*ones(d,n)) + (1-beta1)*(ones(d,1)*sin(1:n)/2 + randn(d,n)+ones(d,1)*y);
variance = var(log(1 + exp(- (A .* X_t_basic_lr)*y'))...
        + gamma/2*(X_t_basic_lr .* X_t_basic_lr)*ones(n,1));
    
for t=1:T
    eta = 20*sqrt(M/(d+variance/n));
    y = sign(rand(1,n)-0.5);
    A = beta1*(rand(d,n)-0.5*ones(d,n)) + (1-beta1)*(ones(d,1)*sin(1:n)/2 + randn(d,n)+ones(d,1)*y);
    %grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i)))...
    %        + gamma*X_t_basic_lr(:,i); %gradient - basic lr 
    
    Grad_basic =  (-(ones(d,1)*y) .* A) / (1 + exp( ones(1,d)*(A .* X_t_basic_lr)*y'))...
            + gamma*X_t_basic_lr;
    X_t_basic_lr = X_t_basic_lr * W - eta/sqrt(t) * Grad_basic; %update rule - basic lr
   
%     for i=1:n
%         temp1 = log(1 + exp(-y((t-1)*n+i,:)*transpose(A(:,(t-1)*n+i))* X_t_basic_lr(:,i)));
%         temp2 = gamma/2*(transpose(X_t_basic_lr(:,i))*X_t_basic_lr(:,i));
%         Loss_basic_lr(:,i) =  temp1 + temp2;
%     end
    Loss_basic_lr = log(1 + exp(- ones(1,d)*(A .* X_t_basic_lr)*y'))...
        + gamma/2*ones(1,d)*(X_t_basic_lr .* X_t_basic_lr)*ones(n,1);
    
    
    Cumu_Loss_basic_lr = Cumu_Loss_basic_lr + Loss_basic_lr;
    ave_loss_basic_lr_seq(t,:) = sum(Cumu_Loss_basic_lr)/(n*t);
    
    
    %evaluate dynamic regret on the first node
    if mod(t,fix(T/5)) == 0
        fprintf('#itera: %d ... \n', t);
    end  
   
    
end


save('ave_loss_basic_lr_seq_n10e3_m10_decen.mat','ave_loss_basic_lr_seq');



fprintf(['loss>> ' mat2str(round(loss_draw,3)) ' \n'...
    'cumu loss>> ' mat2str(round(cumu_loss_draw))]);


