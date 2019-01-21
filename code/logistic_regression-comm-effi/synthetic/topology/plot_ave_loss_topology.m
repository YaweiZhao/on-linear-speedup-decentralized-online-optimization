function [ output_args ] = plot_ave_loss_topology( input_args )

    guli_decen = load('ave_loss_basic_lr_seq_n10e3_m10_decen_guli.mat');
    watts05_decen = load('ave_loss_basic_lr_seq_n10e3_m10_10neighbours_decen_watts05.mat');
    watts1_decen = load('ave_loss_basic_lr_seq_n10e3_m10_10neighbours_decen_watts1.mat');
    ring_decen = load('ave_loss_basic_lr_seq_n10e3_m10_decen_ring.mat');
    fully_connect_decen = load('ave_loss_basic_lr_seq_n10e3_m10_cen.mat');
    T = length(guli_decen.ave_loss_basic_lr_seq);
    luckys = 50:100:T;
    plot(luckys, guli_decen.ave_loss_basic_lr_seq(luckys,:)/10e3, '-ob','MarkerSize',10);
    hold on;
    axis tight;
    plot(luckys, watts05_decen.ave_loss_basic_lr_seq(luckys,:)/10e3, '-or','MarkerSize',10);
    hold on;
    plot(luckys, watts1_decen.ave_loss_basic_lr_seq(luckys,:)/10e3, '-sm','MarkerSize',10);
    hold on;
    plot(luckys, ring_decen.ave_loss_basic_lr_seq(luckys,:)/10e3, '-+k','MarkerSize',10);
    hold on;
    plot(luckys, fully_connect_decen.ave_loss_basic_lr_seq(luckys,:)/10e3, '-<b','MarkerSize',10);
    

    xlabel('T');
    ylabel('Average loss');
    legend('Not connected', 'WattsStrog(0.5)', 'WattsStrog(1)',...
        'Ring', 'Fully connected', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;
end

