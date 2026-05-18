clc;clear;close all;

% Ejercicio 5
Xm = 5;         % Mitad del rango del ADC
B  = 11;        % Bits de la parte sin signo del ADC
q  = Xm/(2^B);  % Tamaño del paso

% Definimos la señal de entrada
% Una señal sinusoidal de 7v pap

Vp       = 7/2;          % Voltaje pico
sigma_x  = Vp/sqrt(2);   % Desviacion estandar
SNR      = 6.02*B - 20*log10(Xm/sigma_x) + 10.8;

%Imprimir el valor
fprintf('SNR_ADC para B = %d bits es: %.2f dB\n', B, SNR);