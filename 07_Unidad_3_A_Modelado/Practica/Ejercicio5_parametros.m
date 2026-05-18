clc; clear; close all;
g  = 9.81;
m  = 4;
L  = 0.25;
I1 = 0.0851;
r  = 2;
I2 = 0.37;
R  = 0.5;
l  = 0.002;
w_o = 3*pi/4;   % consigna en el motor
w_o = w_o/r;    % consigna en el brazo

I  = I1*r^2 + I2; % Inercia equiv respecto al secundario
T  = 2*pi*sqrt(I/(m*g*L)) % Período de oscilación natural
