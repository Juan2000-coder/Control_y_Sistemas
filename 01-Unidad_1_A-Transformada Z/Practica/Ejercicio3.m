clc; clear; close all;
syms z n
assume(n, 'integer');

x = 0.5^n*heaviside(n) + 0.3^n*heaviside(n) + 0.9^n*heaviside(n);
X = ztrans(x, n, z);
pretty(X);

[NUM, DEN] = numden(X);

NUM = sym2poly(NUM);
DEN = sym2poly(DEN);

zplane(NUM, DEN);
title('Ceros y Polos de X(z)');