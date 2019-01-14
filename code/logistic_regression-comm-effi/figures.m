%plot figures 


dataset = 'synthetic';
task = 'm=10';

if strcmp(dataset, 'synthetic') && strcmp(task, 'm=10')%m=10
%communication efficient - occupancy
t = 20*[50 100 150 200];
regret_basic = [33 68 102 136]*20;
regret_our_beta1 = [29 58 87 118]*20;
regret_our_beta2 = [26 52 79 106]*20;
regret_our_beta3 = [21 42 61 80]*20;
plot(t, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(t, regret_our_beta1, '-dr','MarkerSize',10);
hold on;
plot(t, regret_our_beta2, '-*c','MarkerSize',10);
hold on;
plot(t, regret_our_beta3, '-+g','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([1000 4000 400 2750]);

xlabel('Number of iterations');
ylabel('Dynamic regret');
legend('PDR', 'ODR(\beta=0.9)','ODR(\beta=0.8)','ODR(\beta=0.7)',...
    'Location','southeast'); 

elseif strcmp(dataset, 'online-tail') && strcmp(task, 'comm-effi')

%communication efficient - online-tail
time = [809 1126 1519 1925 2449 2984 3687];
regret_basic = [27.7 31 34.5 38 42 45 49];
regret_our_beta1 = [20.8 23 25.8 28.6 31.5 34.5 37];
regret_our_beta2 = [16.4 18 20 22.6 25 27.8 29.8];
regret_our_beta3 = [12.7 14 15.7 17.6 19.7 22 23.7];
plot(time, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(time, regret_our_beta1, '-dr','MarkerSize',10);
hold on;
plot(time, regret_our_beta2, '-*c','MarkerSize',10);
hold on;
plot(time, regret_our_beta3, '-+g','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([800 3800 10 50]);

xlabel('Time(s)');
ylabel('Dynamic regret');
legend('DOGD-PRE', 'DOGD-OUR(\beta=0.9)','DOGD-OUR(\beta=0.8)','DOGD-OUR(\beta=0.7)',...
    'Location','southeast'); 


elseif strcmp(dataset, 'pm25') && strcmp(task, 'comm-effi')

%communication efficient - online-tail
time = [236 367 544 792 1098];
regret_basic = [17.3 20.6 23.4 25.5 26.8];
regret_our_beta1 = [14.8 17.7 20.25 22.3 24];
regret_our_beta2 = [12.7 15.2 17.52 19.4 20.61];
regret_our_beta3 = [10.7 12.9 14.8 16.4 17.4];
plot(time, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(time, regret_our_beta1, '-dr','MarkerSize',10);
hold on;
plot(time, regret_our_beta2, '-*c','MarkerSize',10);
hold on;
plot(time, regret_our_beta3, '-+g','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([200 1100 10 30]);

xlabel('Time(s)');
ylabel('Dynamic regret');
legend('DOGD-PRE', 'DOGD-OUR(\beta=0.9)','DOGD-OUR(\beta=0.8)','DOGD-OUR(\beta=0.7)',...
    'Location','southeast'); 

elseif strcmp(dataset, 'spam') && strcmp(task, 'comm-effi')
%communication efficient - occupancy
time = [10 38 75 156 276];
regret_basic = [3.35 6.88 10.2 13.63 16.93];
regret_our_beta1 = [3 6.2 9.2 12.3 15.3];
regret_our_beta2 = [2.7 5.5 8.2 11 13.6];
regret_our_beta3 = [2.3 4.8 7 9.5 11.9];
plot(time, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(time, regret_our_beta1, '-dr','MarkerSize',10);
hold on;
plot(time, regret_our_beta2, '-*c','MarkerSize',10);
hold on;
plot(time, regret_our_beta3, '-+g','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([10 280 1 20]);

xlabel('Time(s)');
ylabel('Dynamic regret');
legend('DOGD-PRE', 'DOGD-OUR(\beta=0.9)','DOGD-OUR(\beta=0.8)','DOGD-OUR(\beta=0.7)',...
    'Location','southeast');  


end





















