function [ output_args ] = plot_ave_loss_size( input_args )
    dataset = 'occupancy';
    if strcmp(dataset, 'occupancy')
        n10_decen = load('ave_loss_basic_lr_seq_n10_m10_decen_occupancy.mat');
        n5_decen = load('ave_loss_basic_lr_seq_n5_m10_decen_occupancy.mat');
        n20_decen = load('ave_loss_basic_lr_seq_n20_m10_decen_occupancy.mat');
        n15_decen = load('ave_loss_basic_lr_seq_n15_m10_decen_occupancy.mat');
        %m10_cen = load('ave_loss_basic_lr_seq_n100_m10_cen.mat');
        T = length(n20_decen.ave_loss_basic_lr_seq);
        luckys = 1:20:T;

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
    elseif strcmp(dataset, 'online-retail')
        n10_decen = load('ave_loss_basic_lr_seq_n10_m10_decen_online_retail.mat');
        n5_decen = load('ave_loss_basic_lr_seq_n5_m10_decen_online_retail.mat');
        n20_decen = load('ave_loss_basic_lr_seq_n20_m10_decen_online_retail.mat');
        n15_decen = load('ave_loss_basic_lr_seq_n15_m10_decen_online_retail.mat');
        %m10_cen = load('ave_loss_basic_lr_seq_n100_m10_cen.mat');
        T = length(n20_decen.ave_loss_basic_lr_seq);
        luckys = 1:40:T;

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
    elseif strcmp(dataset, 'spam')
        n10_decen = load('ave_loss_basic_lr_seq_n10_m10_decen_spam.mat');
        n5_decen = load('ave_loss_basic_lr_seq_n5_m10_decen_spam.mat');
        n20_decen = load('ave_loss_basic_lr_seq_n20_m10_decen_spam.mat');
        n15_decen = load('ave_loss_basic_lr_seq_n15_m10_decen_spam.mat');
        %m10_cen = load('ave_loss_basic_lr_seq_n100_m10_cen.mat');
        T = length(n5_decen.ave_loss_basic_lr_seq)/4;
        luckys = 1:10:T;

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
    elseif strcmp(dataset, 'synthetic')
        n10_decen = load('ave_loss_basic_lr_seq_n10_m10_decen.mat');
        n5_decen = load('ave_loss_basic_lr_seq_n5_m10_decen.mat');
        n20_decen = load('ave_loss_basic_lr_seq_n20_m10_decen.mat');
        n15_decen = load('ave_loss_basic_lr_seq_n15_m10_decen.mat');
        %m10_cen = load('ave_loss_basic_lr_seq_n100_m10_cen.mat');
        T = 4000;
        luckys = 1:100:T;

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

end

