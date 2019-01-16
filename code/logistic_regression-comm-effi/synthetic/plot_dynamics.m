function [  ] = plot_dynamics(  )
x = -10:0.01:10;
t=0;
A1 = normpdf(x, 1+sin(t), 1);
A2 = normpdf(x, -1+sin(t), 1);
plot(x,A1,':b','LineWidth',1.5);
hold on;
plot(x,A2,':r','LineWidth',1.5);
hold on;
plot(x,A1+A2, ':k','LineWidth',1.5);
hold on;

t=10;
x2 = -10:0.01:10;
t2=0;
A3 = normpdf(x2, 1+sin(t), 1);
A4 = normpdf(x2, -1+sin(t), 1);
plot(x,A3,':b','LineWidth',2);
hold on;
plot(x,A4,':r','LineWidth',2);
hold on;
plot(x,A3+A4, '-k','LineWidth',2);


pax = gca;
pax.FontSize = 20;

axis([-6 15 0 0.6]);
xlabel('Variable');
ylabel('Density');
h = legend('Data distribution 1(t=0)','Data distribution 2(t=0)', 'Data distribution 3(t=0)',...
    'Data distribution 1(t=10)','Data distribution 2(t=10)', 'Data distribution 3(t=10)','Location','northeast'); 
set(h,'Interpreter','latex')
end

