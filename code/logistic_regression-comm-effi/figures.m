%plot figures 


dataset = 'synthetic';
task = 'n_instance';

if strcmp(dataset, 'synthetic') && strcmp(task, 'n_instance')
n_instance = [33 66 99 132 165 200]*20;
regret_basic = [23 45 66 88 106 124];
regret_our_beta1 = [20 40 60 79 95 112];
regret_our_beta2 = [18 36 53 70 85 100];
regret_our_beta3 = [16 32 47 62 74 87];
plot(n_instance, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(n_instance, regret_our_beta1, '-dr','MarkerSize',10);
hold on;
plot(n_instance, regret_our_beta2, '-*c','MarkerSize',10);
hold on;
plot(n_instance, regret_our_beta3, '-+g','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([650 4000 15 130]);

xlabel('Number of instances');
ylabel('Regret');
legend('PDR', 'ODR(\beta=0.9)','ODR(\beta=0.8)','ODR(\beta=0.7)',...
    'Location','southeast'); 

elseif strcmp(dataset, 'synthetic') && strcmp(task, 'm')
m = [0 0 1 10 50 100];
regret_basic = [99 104 124 136 137]*20;
regret_our_beta1 = [90 94 112 122 123]*20;
regret_our_beta2 = [80 84 100 109 110]*20;
regret_our_beta3 = [70 73 87 95 96]*20;

data = [regret_basic; regret_our_beta1;regret_our_beta2;regret_our_beta3];
bar(1:5, data');
xlabel('M','FontSize', 15);
ylabel('Regret','FontSize', 15);
set(gca,'FontSize',15);
set(gca, 'xticklabel', {'M=0','M=1',...
        'M=10', 'M=50', 'M=100'});
legend('PDR', 'ODR(\beta=0.9)','ODR(\beta=0.8)','ODR(\beta=0.7)',...
    'Location','southeast'); 


end





















