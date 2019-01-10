%plot figures 


%communication efficient
time = [468 625 798 1006 1251  1527 1839];
regret_basic = [31 34.2 37.6 41 44.3  47.7 51];
regret_our = [27.8 31 34 36 40 43 46];
plot(time, regret_basic, '-ob','MarkerSize',10);
hold on;
plot(time, regret_our, '-dr','MarkerSize',10);
pax = gca;
pax.FontSize = 15;
axis([450 2000 25 52]);

xlabel('Time(s)');
ylabel('Dynamic regret');
legend('DOGD-PRE', 'DOGD-OUR(0.9)', 'Location','southeast'); 




























