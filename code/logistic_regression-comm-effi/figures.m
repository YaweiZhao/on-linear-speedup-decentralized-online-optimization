%plot figures 


dataset = 'synthetic';
task = 'n_iter';
loss_type = 'loss';
n=100;
net_type = 'off';
if strcmp(net_type, 'off') && n==20 && strcmp(loss_type, 'ave_cumu_loss') && strcmp(dataset, 'synthetic') && strcmp(task, 'n_iter')
    n_iter = (1:20)*200;
    cumu_loss_basic_decen_m10_n1 = [38 94 160 231 307 385 467 549 634 722 813 902 996 1090 1185 1280 1375 1474 1572 1673];
    
    cumu_loss_basic_decen_m10_n2 = 1/2*[59 150 258 380 510 645 785 928 1077 1231 1385 1541 1697 1862 2028 2194 2364 2539 2716 2890];
    
    cumu_loss_basic_decen_m10_n3 = 1/3*[18 42 65 87 105 124 145 168 181 201 226 261 282 310 327 345 364 378 394 422];
    cumu_loss_basic_cen_m10_n3  =  1/3*[18 42 65 87 105 124 145 168 181 201 226 261 282 310 327 345 364 378 394 422];
    cumu_loss_basic_decen_m10_n4 = 1/4*[18 43 67 106 135 172 199 229 273 303 325 354 374 407 427 448 473 500 537 571];
    cumu_loss_basic_cen_m10_n4 = 1/4*[18 43 67 106 135 172 199 229 273 303 325 354 374 407 426 448 473 500 537 571];
    cumu_loss_basic_decen_m10_n5 = 1/5*[34 78 125 167 193 233 281 318 349 372 411 444 481 517 547 591 624 664 692 731];
    cumu_loss_basic_cen_m10_n5 = 1/5*[34 78 125 168 194 234 281 319 349 372 412 445 482 518 547 591 625 664 693 732];
    
    cumu_loss_basic_decen_m10_n20 = 1/20*[102 233 354 492 612 746 895 1057 1196 1330 1445 1599 1750 1911 2064 2192 2348 2499 2650 2794];
    %loss_basic_cen_m10 = [2.1 5.6 0.8 3.9 2.7 0.9 7.7 2 0.8 6.7 3.8 1 6.9 4.2 1 6.8 2.7 1.6 4.9 8];
    %loss_basic_cen_m100 = [5 8.4 2.6 6.3 2.5 1.5 5.8 1.6 1.1 5.7 3 1 5.4 3.4 1 5.1 2.3 1.5 4 6.2];
    plot(n_iter, cumu_loss_basic_decen_m10_n1, '-sk','MarkerSize',10);
    hold on;
    plot(n_iter, cumu_loss_basic_decen_m10_n2, '-<m','MarkerSize',10);
    hold on;
    plot(n_iter, cumu_loss_basic_decen_m10_n3, '-dr','MarkerSize',10);
    hold on;
    plot(n_iter, cumu_loss_basic_decen_m10_n4, '-+c','MarkerSize',10);
    %hold on;
    %semilogy(n_iter, cumu_loss_basic_decen_m10_n5, '-ob','MarkerSize',10);
    hold on;
    plot(n_iter, cumu_loss_basic_decen_m10_n20, ':>r','MarkerSize',10);
    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Averaged cumulative loss on a node');
    legend('n=1', 'n=2',...
        'n=3', 'n=4','n=20', 'Location','northwest'); 
elseif strcmp(net_type, 'off') && n==100 && strcmp(loss_type, 'loss') && strcmp(dataset, 'synthetic') && strcmp(task, 'n_iter')
    n_iter = (1:20)*200;
    loss_basic_decen_m10 = [2 5.5 0.9 4 2.8 0.9 7.8 2 0.8 6.8 3.8 1 6.9 4.2 1 6.8 2.7 1.6 4.9 8];
    loss_basic_decen_m100 = [5.1 8.2 2.7 6.4 2.6 1.5 5.9 1.7 1.1 5.8 2.9 1 5.4 3.3 1 5 2.2 1.5 4.1 6.2];
    loss_basic_cen_m10 = [2.1 5.6 0.8 3.9 2.7 0.9 7.7 2 0.8 6.7 3.8 1 6.9 4.2 1 6.8 2.7 1.6 4.9 8];
    loss_basic_cen_m100 = [5 8.4 2.6 6.3 2.5 1.5 5.8 1.6 1.1 5.7 3 1 5.4 3.4 1 5.1 2.3 1.5 4 6.2];
    plot(n_iter, loss_basic_decen_m10/100, '-ob','MarkerSize',10);
    hold on;
    plot(n_iter, loss_basic_cen_m10/100, '-dr','MarkerSize',10);
    hold on;
    plot(n_iter, loss_basic_decen_m100/100, ':ob','MarkerSize',10);
    hold on;
    plot(n_iter, loss_basic_cen_m100/100, ':dr','MarkerSize',10);
    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Averaged loss');
    legend('Decentralized(M=10)', 'Centralized(M=10)',...
        'Decentralized(M=100)', 'Centralized(M=100)', 'Location','northeast'); 
elseif strcmp(net_type, 'off') && n==100 && strcmp(loss_type, 'cumu_loss') && strcmp(dataset, 'synthetic') && strcmp(task, 'n_iter')
    n_iter = (1:20)*200;
    ave_cumu_loss_basic_decen_m10 = [484 1103 1751 2423 3110 3782 4392 5092 5770 6457 7153 7839 8564 9261 9946 10651 11373 12129 12870 13587];
    ave_cumu_loss_basic_decen_m100 = [1535 2712 3661 4517 5266 5938 6503 7128 7703 8276 8835 9393 9976 10536 11093 11662 12246 12857 13461 14052];
    ave_cumu_loss_basic_cen_m10 = [477 1089 1731 2398 3084 3753 4362 5061 5736 6423 7117 7801 8525 9222 9907 10611 11333 12089 12829 13546];
    ave_cumu_loss_basic_cen_m100 = [1474 2625 3552 4387 5123 5784 6340 6955 7522 8088 8642 9197 9775 10334 10889 11458 12040 12651 13253 13844];
    plot(n_iter, ave_cumu_loss_basic_decen_m10/100, '-ob','MarkerSize',10);
    hold on;
    plot(n_iter, ave_cumu_loss_basic_cen_m10/100, '-dr','MarkerSize',10);
    hold on;
    plot(n_iter, ave_cumu_loss_basic_decen_m100/100, ':ob','MarkerSize',10);
    hold on;
    plot(n_iter, ave_cumu_loss_basic_cen_m100/100, ':dr','MarkerSize',10);
    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Averaged cumulative loss');
    legend('Decentralized(M=10)', 'Centralized(M=10)',...
        'Decentralized(M=100)', 'Centralized(M=100)', 'Location','southeast'); 

    
    
elseif strcmp(net_type, 'on') && n==100 && strcmp(loss_type, 'loss') && strcmp(dataset, 'synthetic') && strcmp(task, 'n_iter')
    n_iter = (1:20)*200;
    loss_basic_decen_m10_ring = [2 5.5 0.9 4 2.8 0.9 7.8 2 0.8 6.8 3.8 1 6.9 4.2 1 6.8 2.7 1.6 4.9 8];
    loss_basic_cen_m10_full_connected = [2.1 5.6 0.8 3.9 2.7 0.9 7.7 2 0.8 6.7 3.8 1 6.9 4.2 1 6.8 2.7 1.6 4.9 8];
    loss_basic_decen_m10_guli = [3.3 4.6 1.6 4.8 3.8 1.6 9 2.1 1.4 8.7 4.6 1.3 8 4.4 1.3 10.3 2.3 1.8 5.3 10.1]; %gu li
    loss_basic_decen_m10_wattsStrogatz_1 = [2.2 5.8 0.9 4.2 3.2 1 8.5 2.1 0.9 7.9 3.9 1.1 7.7 4.7 1.3 6.8 2.6 1.7 5.5 7.6]; %0.5
    loss_basic_decen_m10_wattsStrogatz_2 = [2.4 5.1 0.9 3.4 2.9 1.1 8.5 2.2 1 8.9 4 1.2 7.6 4.4 1.3 7 2.5 1.8 5.7 7.2]; %1, random graph
    plot(n_iter, loss_basic_decen_m10_ring/100, '-ob','MarkerSize',10);
    hold on;
    plot(n_iter, loss_basic_cen_m10_full_connected/100, '-dr','MarkerSize',10);
    hold on;
    plot(n_iter, loss_basic_decen_m10_wattsStrogatz_1/100, '-+c','MarkerSize',10);
    hold on;
    plot(n_iter, loss_basic_decen_m10_wattsStrogatz_2/100, '-<m','MarkerSize',10);
    hold on;
    plot(n_iter, loss_basic_decen_m10_guli/100, '-*g','MarkerSize',10);
    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Averaged loss');
    legend('Ring', 'Fully connected',...
        'WattsStrogatz(0.5)', 'WattsStrogatz(1)','No connected', 'Location','northwest'); 
elseif strcmp(net_type, 'on') && n==100 && strcmp(loss_type, 'cumu_loss') && strcmp(dataset, 'synthetic') && strcmp(task, 'n_iter')
    n_iter = (1:20)*200;
    cumu_loss_basic_decen_m10_ring = [484 1103 1751 2423 3110 3782 4392 5092 5770 6457 7153 7839 8564 9261 9946 10651 11373 12129 12870 13587];
    cumu_loss_basic_decen_m10_wattsStrogatz_1 = [506 1155 1845 2571 3312 4041 4693 5457 6170 6903 7638 8365 9143 9882 10613 11362 12138 12953 13736 14511];
    cumu_loss_basic_cen_m10_fully_connected = [477 1089 1731 2398 3084 3753 4362 5061 5736 6423 7117 7801 8525 9222 9907 10611 11333 12089 12829 13546];
    cumu_loss_basic_decen_m10_wattsStrogatz_2 = [517 1169 1863 2604 3343 4085 4750 5517 6246 6981 7733 8472 9262 10014 10749 11502 12276 13106 13895 14674];
    cumu_loss_basic_decen_m10_guli = [994 2086 3132 4147 5107 6032 6813 7734 8610 9451 10287 11101 11936 12766 13533 14336 15153 15995 16826 17630];
    plot(n_iter, cumu_loss_basic_decen_m10_ring/100, '-ob','MarkerSize',10);
    hold on;
    plot(n_iter, cumu_loss_basic_cen_m10_fully_connected/100, '-dr','MarkerSize',10);
    hold on;
    plot(n_iter, cumu_loss_basic_decen_m10_wattsStrogatz_1/100, '-+c','MarkerSize',10);%0.5
    hold on;
    plot(n_iter, cumu_loss_basic_decen_m10_wattsStrogatz_2/100, '-<m','MarkerSize',10);%1
    hold on;
    plot(n_iter, cumu_loss_basic_decen_m10_guli/100, '-*g','MarkerSize',10);%1

    pax = gca;
    pax.FontSize = 15;

    xlabel('T');
    ylabel('Averaged cumulative loss');
    legend('Ring', 'Fully connected',...
        'WattsStrogatz(0.5)', 'WattsStrogatz(1)','No connected', 'Location','northwest'); 
end





















