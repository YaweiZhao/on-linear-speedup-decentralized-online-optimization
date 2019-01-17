function [ output_args ] = plot_ave_loss_size( input_args )
    n10_decen = load('ave_loss_basic_lr_seq_n10_m10_decen.mat');
    n5_decen = load('ave_loss_basic_lr_seq_n5_m10_decen.mat');
    n20_decen = load('ave_loss_basic_lr_seq_n20_m10_decen.mat');
    n15_decen = load('ave_loss_basic_lr_seq_n15_m10_decen.mat');
    %m10_cen = load('ave_loss_basic_lr_seq_n100_m10_cen.mat');
    T = 4000;
    luckys = 200:100:T;

    plot(luckys, n5_decen.ave_loss_basic_lr_seq(luckys,:), '-dr','MarkerSize',10);
    hold on;
    plot(luckys, n10_decen.ave_loss_basic_lr_seq(luckys,:), '-sc','MarkerSize',10);
    hold on;
    plot(luckys, n15_decen.ave_loss_basic_lr_seq(luckys,:), '-+m','MarkerSize',10);
    hold on;
    plot(luckys, n20_decen.ave_loss_basic_lr_seq(luckys,:), '-<g','MarkerSize',10);
    
    
    xlabel('T');
    ylabel('Average loss');
    legend('n=5', 'n=10',...
        'n=15','n=20', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;

end

