function [ output_args ] = plot_ave_loss_size( input_args )
    n10_decen_var1 = load('ave_loss_basic_lr_seq_n10e3_m10_decen_watts_var1.mat');
    n5_decen_var1 = load('ave_loss_basic_lr_seq_n5e3_m10_decen_watts_var1.mat');
    n10_decen_var2 = load('ave_loss_basic_lr_seq_n10e3_m10_decen_watts_var2.mat');
    n5_decen_var2 = load('ave_loss_basic_lr_seq_n5e3_m10_decen_watts_var2.mat');
    %n15_decen = load('ave_loss_basic_lr_seq_n15e3_m10_decen_centralized.mat');
    T = length(n5_decen_var1.ave_loss_basic_lr_seq);
    luckys = 150:100:T-600;

    plot(luckys, n5_decen_var1.ave_loss_basic_lr_seq(luckys,:), '-dr','MarkerSize',10);
    hold on;
    plot(luckys, n10_decen_var1.ave_loss_basic_lr_seq(luckys,:), '-+b','MarkerSize',10);
    hold on;
    plot(luckys, n5_decen_var2.ave_loss_basic_lr_seq(luckys,:), '-sk','MarkerSize',10);
    hold on;
    plot(luckys, n10_decen_var2.ave_loss_basic_lr_seq(luckys,:), '-*m','MarkerSize',10);
    axis tight;
    %hold on;
    %plot(luckys, n15_decen.ave_loss_basic_lr_seq(luckys,:), '-+m','MarkerSize',10);

    xlabel('T');
    ylabel('Average loss');
    legend('n=5\times10^3,\sigma=1','n=1\times10^4,\sigma=1','n=\times10^3,\sigma=2','n=1\times10^4,\sigma=2', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;

end

