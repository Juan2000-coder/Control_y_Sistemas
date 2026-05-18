% INVESTIGACIÓN FÓRMULA DE FCO LEaky Integrator
close all; clear; clc;
lambda = linspace(0.1715,1,100);
arg    = -lambda/2 + 2 - 1./(2*lambda);
Fcon_1 = - log(lambda)/pi;
Fcon_2 = acos(arg)/pi;
Fcon_3 = 1 - lambda;
figure;grid on;
plot(lambda, arg)
figure;
plot(lambda, Fcon_2); hold on;
plot(lambda, Fcon_1);
plot(lambda, Fcon_3);
legend("posta", "aprox", "lineal");