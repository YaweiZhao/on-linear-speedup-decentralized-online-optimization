function [  ] = plot_ave_loss( )

    m20_decen = load('ave_loss_basic_lr_seq_n100_m20_decen.mat');
    m10_decen = load('ave_loss_basic_lr_seq_n100_m10_decen.mat');
    m20_cen = load('ave_loss_basic_lr_seq_n100_m20_cen.mat');
    m10_cen = load('ave_loss_basic_lr_seq_n100_m10_cen.mat');
    T = 4000;
    luckys = 2000:200:T;
    plot(luckys, m20_decen.ave_loss_basic_lr_seq(luckys,:), '-.sg','MarkerSize',10);
    hold on;
    plot(luckys, m20_cen.ave_loss_basic_lr_seq(luckys,:), '-.*k','MarkerSize',10);
    hold on;
    plot(luckys, m10_decen.ave_loss_basic_lr_seq(luckys,:), '-ob','MarkerSize',10);
    hold on;
    plot(luckys, m10_cen.ave_loss_basic_lr_seq(luckys,:), '-+r','MarkerSize',10);

    

    xlabel('T');
    ylabel('Average loss');
    legend('DOG(M=10)', 'COG(M=10)',...
        'DOG(M=20)', 'COG(M=20)', 'Location','northeast'); 

    pax = gca;
    pax.FontSize = 25;
end

