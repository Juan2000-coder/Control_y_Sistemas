clear; clc; close all;

m      = 1000;   % kg
g      = 9.82;   % m/s^2
b      = 10000;  % N.s/m
a      = 200;    % N.s/m (también debería ser en esta unidad)
alfa_c = 0;      % bool: se mide alfa?
alfa   = 1;      % bool: se usa alfa?
ol     = 1;      % bool: open loop?
cl     = 0;      % bool: closed loop?
indice = 15;

% kp kd ki
k = [    8.0200         0    3.2000;
    8.9192    0.0112    3.5579;
    9.8184    0.0224    3.9158;
   10.7176    0.0336    4.2737;
   11.6168    0.0447    4.6316;
   12.5161    0.0559    4.9895;
   13.4153    0.0671    5.3474;
   14.3145    0.0783    5.7053;
   15.2137    0.0895    6.0632;
   16.1129    0.1007    6.4211;
   17.0121    0.1118    6.7789;
   17.9113    0.1230    7.1368;
   18.8105    0.1342    7.4947;
   19.7097    0.1454    7.8526;
   20.6089    0.1566    8.2105;
   21.5082    0.1678    8.5684;
   22.4074    0.1789    8.9263;
   23.3066    0.1901    9.2842;
   24.2058    0.2013    9.6421;
   25.1050    0.2125   10.0000];

kp = k(indice, 1);          % ganancia proporcional
kd = k(indice, 2);          % ganancia derivativa
ki = k(indice, 3);          % ganancia integral