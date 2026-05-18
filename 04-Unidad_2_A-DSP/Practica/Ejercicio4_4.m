%% Ejercicio 4.4

% Muestra la ecuación SNR_ADC de la teoria.
% En este caso lo hacemos para una señal sinusoidal de entrada

% SNR_ADC = 6.02*B - 20log10(Xm/sigma_x) + 10.8
% B         = bits del adc sin el bit de signo
% Xm        = Mitad rango del ADC
% sigma_x   = desviacion estandar de la señal

clc; clear; close all;

Xm      = 2.5;       % Mitad del rango del ADC
Xs      = 5;         % Amplitud de la señal sinusoidal

for B = 1:31
    sigma_x     = Xs/sqrt(2);      % Desviacion estandar de la señal
    SNR         = 6.02*B - 20*log10(Xm/sigma_x) + 10.8;
    % Imprimir el valor 
    fprintf('SNR_ADC para B = %d bits es: %.2f dB\n', B, SNR);
end
