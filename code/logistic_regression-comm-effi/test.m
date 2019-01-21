clc;
clear all;
rng('default');
data = load('spam.mat');
data = data.new_data;
[~,d] = size(data);
A = transpose(data(:,2:d));
[d,nn] = size(A);
y=data(:,1);

n = 20; % # of nodes

%hyper-parameter
beta1 = 0.1;

M = 10; %dynamics
eta = 1e-1*sqrt(M);%occupancy: 10*sqrt(M);%spam: 20*sqrt(M); %usenet1, usenet2: 10*sqrt(M);
gamma= 1e-3;
%hyper-parameter
T=fix(nn/n);




%construct the confusion matrix W. Ring topology 
tag = 'decentralized';
topology = 'ring';
if strcmp(tag, 'centralized')
    W =  ones(n,n)/n;
elseif strcmp(tag, 'decentralized') && strcmp(topology, 'watts')
    graph = WattsStrogatz(n,2,0.5);
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
elseif strcmp(tag, 'decentralized') && strcmp(topology, 'guli')
    W = eye(n);
elseif strcmp(tag, 'decentralized') && strcmp(topology, 'ring')
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
end

%online learning
Q = zeros(d-1,d);
for row = 1:d-1
    Q(row,row) = 1; Q(row,row+1) = -1;
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
for t=1:T

    for i=1:n % # of nodes
        
        y_it = y((t-1)*n+i,:);
        A_it = A(:,(t-1)*n+i);
        grad_basic = (-y_it * A_it) / (1 + exp(y_it * A_it'* X_t_basic_lr(:,i)))...
            + gamma*X_t_basic_lr(:,i); %gradient - basic lr
        
        Grad_basic(:,i) =  grad_basic;

    end
    X_t_basic_lr = X_t_basic_lr * W - eta/sqrt(t) * Grad_basic; %update rule - basic lr
   
    for i=1:n
        temp1 = log(1 + exp(-y((t-1)*n+i,:)*transpose(A(:,(t-1)*n+i))* X_t_basic_lr(:,i)));
        temp2 = gamma/2*(transpose(X_t_basic_lr(:,i))*X_t_basic_lr(:,i));
        Loss_basic_lr(:,i) =  temp1 + temp2;
    end
    Cumu_Loss_basic_lr = Cumu_Loss_basic_lr + Loss_basic_lr;
    ave_loss_basic_lr_seq(t,:) = sum(Cumu_Loss_basic_lr)/(n*t);
    
    
    
    %evaluate dynamic regret on the first node
    if mod(t,fix(T/200)) == 0

        %auxiliary matrix R
        R = zeros(t-1,t);
        for row = 1:t-1
            R(row, row) = 1;
            R(row, row+1) = -1;
        end

        % advantage = basic regre - basic lr

%         cvx_begin quiet
%         variable x_ast_basic(d,t)
%         cumu_obj_basic_lr = log(1 + exp(ones(1,d) * (transpose(-y(1:n:(t-1)*n+1,:)*ones(1,d))...
%             .* A(:,1:n:(t-1)*n+1) .* x_ast_basic)))*ones(t,1)...
%             +gamma/2*(ones(1,d)*(x_ast_basic .* x_ast_basic)*ones(t,1));
%         minimize( cumu_obj_basic_lr );
%         subject to
%         ones(1,t-1)*norms( R * x_ast_basic', 2 , 2) <= M; %dynamics M
%         cvx_end       
 %       Regret_basic_lr(:,1) = Loss_basic_lr(:,1) - cumu_obj_basic_lr;
%         fprintf('#rounds=%d | regret=%.2f | loss=%.2f\n',t,sum(Regret_basic_lr),sum(Loss_basic_lr));
%         output = ['#rounds=' mat2str(t) ' | regret=' mat2str(round(sum(Regret_basic_lr),2))...
%             'loss=' mat2str(round(sum(Loss_basic_lr),2)) '\n'];
         loss_draw = [loss_draw sum(Loss_basic_lr)];
         cumu_loss_draw = [cumu_loss_draw sum(Cumu_Loss_basic_lr)];
%         fprintf('#rounds=%d |  loss=%.3f | cumu loss = %.3f\n',t,sum(Loss_basic_lr),sum(Cumu_Loss_basic_lr));
%          output = [ mat2str(round(sum(Loss_basic_lr),3)) ' '];
%         fid=fopen('./output.txt');
%         fprintf(fid,'%s\n',output);
%         fclose(fid);

    end   
    
end


save('ave_loss_basic_lr_seq_n20_m10_guli_decen_spam.mat','ave_loss_basic_lr_seq');


fprintf(['loss>> ' mat2str(round(loss_draw,3)) ' \n'...
    'cumu loss>> ' mat2str(round(cumu_loss_draw))]);


