function [  ] = plot_ave_loss()
dataset = 'online-retail';
if strcmp(dataset, 'occupancy') 
    m20_decen = load('ave_loss_basic_lr_seq_n5_m20_decen_occupancy.mat');
    m10_decen = load('ave_loss_basic_lr_seq_n5_m10_decen_occupancy.mat');
    m20_cen = load('ave_loss_basic_lr_seq_n5_m20_cen_occupancy.mat');
    m10_cen = load('ave_loss_basic_lr_seq_n5_m10_cen_occupancy.mat');
    T = length(m10_decen.ave_loss_basic_lr_seq);
    luckys = 1:100:T;
    plot(luckys, m10_decen.ave_loss_basic_lr_seq(luckys,:), '-ob','MarkerSize',10);
    hold on;
    plot(luckys, m10_cen.ave_loss_basic_lr_seq(luckys,:), '-+r','MarkerSize',10);
    hold on;
    plot(luckys, m20_decen.ave_loss_basic_lr_seq(luckys,:), '-.sg','MarkerSize',10);
    hold on;
    plot(luckys, m20_cen.ave_loss_basic_lr_seq(luckys,:), '-.*k','MarkerSize',10);
    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Average loss');
    legend('DOG(M=10)', 'COG(M=10)',...
        'DOG(M=20)', 'COG(M=20)', 'Location','northeast'); 

elseif  strcmp(dataset, 'online-retail') 
    m20_decen = load('ave_loss_basic_lr_seq_n5_m20_decen_online_retail.mat');
    m10_decen = load('ave_loss_basic_lr_seq_n5_m10_decen_online_retail.mat');
    m20_cen = load('ave_loss_basic_lr_seq_n5_m20_decen_online_retail.mat');
    m10_cen = load('ave_loss_basic_lr_seq_n5_m10_cen_online_retail.mat');
    T = length( m10_decen.ave_loss_basic_lr_seq);
    luckys = 1:200:T;
    plot(luckys, m10_decen.ave_loss_basic_lr_seq(luckys,:), '-ob','MarkerSize',10);
    hold on;
    plot(luckys, m10_cen.ave_loss_basic_lr_seq(luckys,:), '-+r','MarkerSize',10);
    hold on;
    plot(luckys, m20_decen.ave_loss_basic_lr_seq(luckys,:), '-.sg','MarkerSize',10);
    hold on;
    plot(luckys, m20_cen.ave_loss_basic_lr_seq(luckys,:), '-.*k','MarkerSize',10);
    
    xlabel('T');
    ylabel('Average loss');
    legend('DOG(M=10)', 'COG(M=10)',...
        'DOG(M=20)', 'COG(M=20)', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;
    
    elseif  strcmp(dataset, 'usenet2') 
    m20_decen = load('ave_loss_basic_lr_seq_n5_m20_decen_usenet2.mat');
    m10_decen = load('ave_loss_basic_lr_seq_n5_m10_decen_usenet2.mat');
    m20_cen = load('ave_loss_basic_lr_seq_n5_m20_cen_usenet2.mat');
    m10_cen = load('ave_loss_basic_lr_seq_n5_m10_cen_usenet2.mat');
    T = length(m10_decen.ave_loss_basic_lr_seq);
    luckys = 1:20:T;
    plot(luckys, m10_decen.ave_loss_basic_lr_seq(luckys,:), '-ob','MarkerSize',10);
    hold on;
    plot(luckys, m10_cen.ave_loss_basic_lr_seq(luckys,:), '-+r','MarkerSize',10);
    hold on;
    plot(luckys, m20_decen.ave_loss_basic_lr_seq(luckys,:), '-.sg','MarkerSize',10);
    hold on;
    plot(luckys, m20_cen.ave_loss_basic_lr_seq(luckys,:), '-.*k','MarkerSize',10);
    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Average loss');
    legend('DOG(M=10)', 'COG(M=10)',...
        'DOG(M=20)', 'COG(M=20)', 'Location','northeast'); 
    
    elseif  strcmp(dataset, 'spam') 
    m20_decen = load('ave_loss_basic_lr_seq_n5_m20_decen_spam.mat');
    m10_decen = load('ave_loss_basic_lr_seq_n5_m10_decen_spam.mat');
    m20_cen = load('ave_loss_basic_lr_seq_n5_m20_cen_spam.mat');
    m10_cen = load('ave_loss_basic_lr_seq_n5_m10_cen_spam.mat');
    T = length(m10_decen.ave_loss_basic_lr_seq);
    luckys = 1:100:T;
    plot(luckys, m10_decen.ave_loss_basic_lr_seq(luckys,:), '-ob','MarkerSize',10);
    hold on;
    plot(luckys, m10_cen.ave_loss_basic_lr_seq(luckys,:), '-+r','MarkerSize',10);
    hold on;
    plot(luckys, m20_decen.ave_loss_basic_lr_seq(luckys,:), '-.sg','MarkerSize',10);
    hold on;
    plot(luckys, m20_cen.ave_loss_basic_lr_seq(luckys,:), '-.*k','MarkerSize',10);
    

    xlabel('T');
    ylabel('Average loss');
    legend('DOG(M=10)', 'COG(M=10)',...
        'DOG(M=20)', 'COG(M=20)', 'Location','northeast'); 
    pax = gca;
    pax.FontSize = 25;
end

end

