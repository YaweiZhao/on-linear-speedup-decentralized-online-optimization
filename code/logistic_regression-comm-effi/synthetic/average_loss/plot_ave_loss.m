function [  ] = plot_ave_loss( )

    m10_decen = load('ave_loss_basic_lr_seq_n10e3_m10_10neighbours_decen.mat');
    m10_cen = load('ave_loss_basic_lr_seq_n10e3_m10_cen.mat');
    T = length(m10_decen.ave_loss_basic_lr_seq);
    luckys = 200:100:T;
    plot(luckys, m10_decen.ave_loss_basic_lr_seq(luckys,:)/10e3, '-ob','MarkerSize',10);
    hold on;
    axis tight;
    plot(luckys, m10_cen.ave_loss_basic_lr_seq(luckys,:)/10e3, '-+r','MarkerSize',10);

    

    xlabel('T');
    ylabel('Average loss');
    legend('DOG(M=10)', 'COG(M=10)', 'Location','northeast'); 

    pax = gca;
    pax.FontSize = 25;
end

