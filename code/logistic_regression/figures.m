%plot figures 


%communication efficient
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




























