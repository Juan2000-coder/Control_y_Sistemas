clc; clear; close all;
syms z n k

X1 = 3*z/(3*z - 1);
X2 = 2*z/(2*z - 1);
X3 = 1/(1-(2*z)^-1) + 1/(1-2*z^-1);

% Obtener numerador y denominador
[num1, den1] = numden(X1);
[num2, den2] = numden(X2);
[num3, den3] = numden(X3);

% Imprimir los numeradores y denominadores
%{
disp('Numerador y Denominador de X1(z):');
pretty([num1, den1]);
disp('Numerador y Denominador de X2(z):');
pretty([num2, den2]);
disp('Numerador y Denominador de X3(z):');
pretty([num3, den3]);
%}

% Convertir expresiones simbólicas a coeficientes numéricos
num1 = sym2poly(num1); den1 = sym2poly(den1);
num2 = sym2poly(num2); den2 = sym2poly(den2);
num3 = sym2poly(num3); den3 = sym2poly(den3);

% Graficar los polos y ceros
figure;
subplot(2,2,1);
zplane(num1, den1);
title('Ceros y Polos de X1(z)');

subplot(2,2,2);
zplane(num2, den2);
title('Ceros y Polos de X2(z)');

subplot(2,2,3);
zplane(num3, den3);
title('Ceros y Polos de X3(z)');

% Visualización de la respuesta en frecuencia
figure;
freqz(num1, den1);
title('Respuesta en frecuencia de X1(z)');

figure;
freqz(num2, den2);
title('Respuesta en frecuencia de X2(z)');

figure;
freqz(num3, den3);
title('Respuesta en frecuencia de X3(z)');