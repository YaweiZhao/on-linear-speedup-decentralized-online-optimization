%plot figures 


dataset = 'spam.mat';
task = 'comm-effi';

if strcmp(dataset, 'occupancy') && strcmp(task, 'comm-effi')
%communication efficient - occupancy
time = [292 461 684 1012 1400  1943 2474];
regret_basic = [17 20.3 23.7 27 30 33 37];
regret_our_beta1 = [15.2 18.3 21.4 24.4 27 30 33];
regret_our_beta2 = [13.6 16 19 21.7 24 27 29];
regret_our_beta3 = [11.8 14.3 16.6 19 21 23.6 25.8];
plot(time, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(time, regret_our_beta1, '-dr','MarkerSize',10);
hold on;
plot(time, regret_our_beta2, '-*c','MarkerSize',10);
hold on;
plot(time, regret_our_beta3, '-+g','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([280 2500 10 40]);

xlabel('Time(s)');
ylabel('Dynamic regret');
legend('DOGD-PRE', 'DOGD-OUR(\beta=0.9)','DOGD-OUR(\beta=0.8)','DOGD-OUR(\beta=0.7)',...
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


end





















