clc; clear; close all;
syms z m
assume(m, 'integer');

% coeficientes de la salida
a = [1 -0.5 -0.1 -0.2];
% coeficientes de la entrada
b = [1];
% salidas pasadas
Y = [1 2 3];
% entrada escalon u[n]
u = ones(1, 50);
% condiciones iniciales
xic = filtic(b, a, Y);
% respuesta al escalon
y = filter(b, a, u, xic);
% grafico
n = 0:49;
stem(n, y);
xlabel('n');
ylabel('y[n]');
title('Respuesta al escalon');
grid on;

%a partir del escalon
x = ztrans(heaviside(m));
[num, den] = numden(x);
num = sym2poly(num);
den = sym2poly(den);
X = tf(num, den, -1);

%graficar polos y zeros con zplane
sys = filt(b,a);
sys

Yaux = sys*X;
Yaux

[numaux, denaux] = tfdata(Yaux, 'v')
[r, p, k] = residuez(numaux, denaux);
r
p
k

[hnum, hden] = tfdata(sys, 'v');
figure;
zplane(hnum, hden);
title('Polos y zeros');
grid on;
% Todos los polos dentro del círculo unidad ESTABLE