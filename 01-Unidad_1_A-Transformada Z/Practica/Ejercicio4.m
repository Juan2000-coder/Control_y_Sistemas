clc; clear; close all;
syms z n
assume(n, 'integer');

%4.1
sys = filt([1], [1 -0.7]);

%4.2 respuesta al impulso
[hnum, hden] = tfdata(sys, 'v');            % Obtiene los coeficientes del numerador y denominador
H = poly2sym(hnum, z) / poly2sym(hden, z);  % Expresa H(z) simbólicamente
h_n = iztrans(H, z, n)                      % Obtiene la Transformada Z inversa
h_n

%4.3 respuesta al escalón
x = ztrans(heaviside(n));
[num, den] = numden(x);
num = sym2poly(num);
den = sym2poly(den);
X = tf(num, den, -1);

Y = X * sys;
[num, den] = tfdata(Y, 'v');
Y = poly2sym(num, z) / poly2sym(den, z);
y_n = iztrans(Y, z, n);
y_n

%residuez: residuos de las fracciones, polos, y los coeficientes d elos términos directos.
[r, p, k] = residuez(num, den);
r
p
k

% Respuesta al impulso
x1    = zeros(1, 10);
x1(1) = 1;
y1    = filter(hnum, hden, x1);
figure;
stem(0:9, y1);
title('Respuesta al impulso');

% Respuesta al escalón
x2    = ones(1, 10);
y2    = filter(hnum, hden, x2);
figure;
stem(0:9, y2);
title('Respuesta al escalón');
