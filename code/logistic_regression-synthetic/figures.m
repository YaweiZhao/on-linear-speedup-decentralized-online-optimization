%plot figures 


dataset = 'synthetic';
task = 'node';

if strcmp(dataset, 'synthetic') && strcmp(task, 'time')
%communication efficient - occupancy
time = [6 13 19 26 32];
regret_basic = [1e5 3e5 5.3e5 8.2e5 11.5e5];
regret_our_beta1 = [8.4e4 2.4e5 4.4e5 6.7e5 9.3e5];
regret_our_beta2 = [6.8e4 1.9e5 3.5e5 5.4e5 7.6e5];
regret_our_beta3 = [5.6e4 1.6e5 2.9e5 4.4e5 6.2e5];
plot(time, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(time, regret_our_beta1, '-dr','MarkerSize',10);
hold on;
plot(time, regret_our_beta2, '-*c','MarkerSize',10);
hold on;
plot(time, regret_our_beta3, '-+g','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([5 32 5e4 12e5 ]);

xlabel('Time(s)');
ylabel('Dynamic regret');
legend('PDR', 'ODR(\beta=0.9)','ODR(\beta=0.8)','ODR(\beta=0.7)',...
    'Location','northwest'); 

elseif strcmp(dataset, 'synthetic') && strcmp(task, 'node')
    
n = [5 10 15 20];
regret_basic = [80e5 30e5 14e5  11.5e5];
regret_our_beta1 = [65e5 24e5 11e5 9.3e5];
regret_our_beta2 = [52e5 19e5 9e5 7.6e5];
regret_our_beta3 = [41e5 15.5e5 7.6e5 6.2e5]; 

data = [regret_basic; regret_our_beta1; regret_our_beta2; regret_our_beta3];

bar(1:4, data');


xlabel('Number of nodes','FontSize', 15);
ylabel('Dynamic regret','FontSize', 15);
set(gca,'FontSize',15);
set(gca, 'xticklabel', {'n=5','n=10',...
        'n=15', 'n=20'});

legend('DOGD-PRE', 'DOGD-OUR(\beta=0.9)','DOGD-OUR(\beta=0.8)','DOGD-OUR(\beta=0.7)',...
    'Location','northeast');
 
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




















