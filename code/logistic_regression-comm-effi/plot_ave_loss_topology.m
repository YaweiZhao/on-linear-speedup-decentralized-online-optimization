function [ output_args ] = plot_ave_loss_topology( input_args )
dataset = 'occupancy';
if strcmp(dataset, 'occupancy')
    %guli_decen = load('ave_loss_basic_lr_seq_n100_m10_guli_decen.mat');
    watts05_decen = load('ave_loss_basic_lr_seq_n20_m10_watts05_decen_occupancy.mat');
    watts1_decen = load('ave_loss_basic_lr_seq_n20_m10_watts1_decen_occupancy.mat');
    ring_decen = load('ave_loss_basic_lr_seq_n20_m10_ring_decen_occupancy.mat');
    fully_connect_decen = load('ave_loss_basic_lr_seq_n20_m10_fully_connect_decen_occupancy.mat');
    T = length(watts05_decen.ave_loss_basic_lr_seq);
    luckys = 1:20:T;
    %plot(luckys, guli_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-ob','MarkerSize',10);
    %hold on;
    plot(luckys, watts05_decen.ave_loss_basic_lr_seq(luckys,:), '-or','MarkerSize',10);
    hold on;
    plot(luckys, watts1_decen.ave_loss_basic_lr_seq(luckys,:), '-sm','MarkerSize',10);
    hold on;
    plot(luckys, ring_decen.ave_loss_basic_lr_seq(luckys,:), '-+c','MarkerSize',10);
    hold on;
    plot(luckys, fully_connect_decen.ave_loss_basic_lr_seq(luckys,:), '-<b','MarkerSize',10);
    

    xlabel('T');
    ylabel('Average loss');
    legend('WattsStrogatz(0.5)', 'WattsStrogatz(1)',...
        'Ring', 'Fully connected', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;
elseif strcmp(dataset, 'online-retail')
    %guli_decen = load('ave_loss_basic_lr_seq_n100_m10_guli_decen.mat');
    watts05_decen = load('ave_loss_basic_lr_seq_n20_m10_watts05_decen_online_retail.mat');
    watts1_decen = load('ave_loss_basic_lr_seq_n20_m10_watts1_decen_online_retail.mat');
    ring_decen = load('ave_loss_basic_lr_seq_n20_m10_ring_decen_online_retail.mat');
    fully_connect_decen = load('ave_loss_basic_lr_seq_n20_m10_fully_connect_decen_online_retail.mat');
    T = length(watts05_decen.ave_loss_basic_lr_seq);
    luckys = 1:100:T;
    %plot(luckys, guli_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-ob','MarkerSize',10);
    %hold on;
    plot(luckys, watts05_decen.ave_loss_basic_lr_seq(luckys,:), '-or','MarkerSize',10);
    hold on;
    plot(luckys, watts1_decen.ave_loss_basic_lr_seq(luckys,:), '-sm','MarkerSize',10);
    hold on;
    plot(luckys, ring_decen.ave_loss_basic_lr_seq(luckys,:), '-+c','MarkerSize',10);
    hold on;
    plot(luckys, fully_connect_decen.ave_loss_basic_lr_seq(luckys,:), '-<b','MarkerSize',10);
    

    xlabel('T');
    ylabel('Average loss');
    legend('WattsStrogatz(0.5)', 'WattsStrogatz(1)',...
        'Ring', 'Fully connected', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;
elseif strcmp(dataset, 'spam')
    %guli_decen = load('ave_loss_basic_lr_seq_n100_m10_guli_decen.mat');
    watts05_decen = load('ave_loss_basic_lr_seq_n5_m10_watts05_decen_spam.mat');
    watts1_decen = load('ave_loss_basic_lr_seq_n5_m10_watts1_decen_spam.mat');
    ring_decen = load('ave_loss_basic_lr_seq_n5_m10_ring_decen_spam.mat');
    fully_connect_decen = load('ave_loss_basic_lr_seq_n5_m10_fully_connect_decen_spam.mat');
    T = length(watts05_decen.ave_loss_basic_lr_seq);
    luckys = 1:200:T;
    %plot(luckys, guli_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-ob','MarkerSize',10);
    %hold on;
    plot(luckys, watts05_decen.ave_loss_basic_lr_seq(luckys,:), '-or','MarkerSize',10);
    hold on;
    plot(luckys, watts1_decen.ave_loss_basic_lr_seq(luckys,:), '-sm','MarkerSize',10);
    hold on;
    plot(luckys, ring_decen.ave_loss_basic_lr_seq(luckys,:), '-+c','MarkerSize',10);
    hold on;
    plot(luckys, fully_connect_decen.ave_loss_basic_lr_seq(luckys,:), '-<b','MarkerSize',10);
    

    xlabel('T');
    ylabel('Average loss');
    legend('WattsStrogatz(0.5)', 'WattsStrogatz(1)',...
        'Ring', 'Fully connected', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;
elseif strcmp(dataset, 'synthetic')
    %guli_decen = load('ave_loss_basic_lr_seq_n100_m10_guli_decen.mat');
    watts05_decen = load('ave_loss_basic_lr_seq_n100_m10_watts05_decen.mat');
    watts1_decen = load('ave_loss_basic_lr_seq_n100_m10_watts1_decen.mat');
    ring_decen = load('ave_loss_basic_lr_seq_n100_m10_ring_decen.mat');
    fully_connect_decen = load('ave_loss_basic_lr_seq_n100_m10_fully_connect_decen.mat');
    T = 4000;
    luckys = 1:200:T;
    %plot(luckys, guli_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-ob','MarkerSize',10);
    %hold on;
    plot(luckys, watts05_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-or','MarkerSize',10);
    hold on;
    plot(luckys, watts1_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-sm','MarkerSize',10);
    hold on;
    plot(luckys, ring_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-+c','MarkerSize',10);
    hold on;
    plot(luckys, fully_connect_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-<b','MarkerSize',10);
    pax = gca;
    pax.FontSize = 25;

    xlabel('T');
    ylabel('Average loss');
    legend('WattsStrogatz(0.5)', 'WattsStrogatz(1)',...
        'Ring', 'Fully connected', 'Location','northeast'); 
    
end




end


