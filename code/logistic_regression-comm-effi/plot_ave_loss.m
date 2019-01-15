function [  ] = plot_ave_loss( )

    m100_decen = load('ave_loss_basic_lr_seq_n100_m100_decen.mat');
    m10_decen = load('ave_loss_basic_lr_seq_n100_m10_decen.mat');
    m100_cen = load('ave_loss_basic_lr_seq_n100_m100_cen.mat');
    m10_cen = load('ave_loss_basic_lr_seq_n100_m10_cen.mat');
    T = 4000;
    luckys = T-100:10:T;
    plot(luckys, m10_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-ob','MarkerSize',10);
    hold on;
    plot(luckys, m10_cen.ave_loss_basic_lr_seq(luckys,:)/100, '-+r','MarkerSize',10);
    hold on;
    plot(luckys, m100_decen.ave_loss_basic_lr_seq(luckys,:)/100, '-.sg','MarkerSize',10);
    hold on;
    plot(luckys, m100_cen.ave_loss_basic_lr_seq(luckys,:)/100, '-.*k','MarkerSize',10);
    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Averaged loss');
    legend('Decentralized(M=10)', 'Centralized(M=10)',...
        'Decentralized(M=100)', 'Centralized(M=100)', 'Location','northeast'); 


end

