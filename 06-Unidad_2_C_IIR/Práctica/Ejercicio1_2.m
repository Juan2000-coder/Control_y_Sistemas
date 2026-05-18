clear; close all; clc;
%% -------------------------Inciso a---------------------------------------
% Genere una señal senoidal con frecuencia fundamental fn = 100 Hz.

% Parámetros de la señal (1)
fn = 100.0;     % Frecuencia de la señal (Hz)(1)
fs = 4000.0;    % Frecuencia de muestreo (Hz)(1)
TI = 0.0;       % Tiempo inicial (s)(1)
TF = 1.0;       % Tiempo final (s)(1)
%fs  = Fs;       % Frecuencia de muestreo (Hz)(1)

% Parámetros de la señal (2)
%load('Tchaikovsky.mat'); % Incorpor Fs y signal (numel, 2)
%signal_r = signal(:, 1); % Canal derecho
%signal_l = signal(:, 2); % Canal Izquierdo
%fs       = Fs;

% Vector de tiempo (2)
%[len, ~] = size(signal);  % (2)
Ts       = 1/fs;          % Período de muestreo (2)
%TF       = (len - 1)*Ts;  % Instante final (2)
t        = TI:Ts:TF;       % Definir el tiempo con paso constante(2)

x  = sin(2*pi*fn*t);   % (1)
%x        = signal_r;     % Utilice el archivo Tchaikovsky.mat. (2)

%% -------------------------Inciso b---------------------------------------
% Agregue ruido gaussiano a la señal senoidal tal que la relación señal-ruido
% entre la señal senoidal y la señal con ruido sea de 15 dB.

SNR = 15;              % (1)
%SNR = 10;              % (2)
xn  = my_awgn(x, SNR); % n de noisy

%%-------------------------Inciso c---------------------------------------
% Diseñe un filtro leaking integrator (LI) con λ igual a 0.7.
% y[n] = λy[n-1] + (1-λ)x[n]
% y[n] - λy[n-1] = (1-λ)x[n]
% -> a = [1, -lambda];
% -> b = (1-lambda);

lambda = 0.8;
a      = [1, -lambda];
b      = (1 - lambda);

%% -------------------------Inciso d---------------------------------------
% Grafique la respuesta en frecuencia y fase del filtro LI. Use la función freqz().
% Determine la frecuencia de corte fco con:
% fco = - ln (λ) . fs / π

freqz(b, a);

sys = tf(b, a, Ts);

figure;
bode(sys);

fco    = - log(lambda)*fs/(2*pi);
Fcon   = - log(lambda)/pi;  % Buena para lambda > 0.7
Fcon_1 = 1 - lambda;        % No da buenos resultados
Fcon_2 = acos(-lambda/2 + 2 - 1/(2*lambda))/pi; % desde lamnda = 0.1715 (exacta)

disp(['Frecuencia de corte (fco): ', num2str(fco), ' Hz']);
disp(['Frecuencia de corte normalizada (Fco: tp): ', num2str(Fcon)]);
disp(['Frecuencia de corte normalizada (Fcon_1: teoria): ', num2str(Fcon_1)]);
disp(['Frecuencia de corte normalizada (Fcon_2: deduccion): ', num2str(Fcon_2)]);

%% -------------------------Inciso e---------------------------------------
% Determine el cero y el polo del filtro con la función zplane().
% ¿Es el filtro estable?.
figure;
zplane(b, a);

%% -------------------------Inciso f---------------------------------------
% Aplique el filtro LI a la señal con ruido. Utilice la función filter().
y   = filter(b, a, xn);

%% -------------------------Inciso g---------------------------------------
% Grafique las señales en el dominio del tiempo sin ruido, con ruido
% y filtrada, y compare las tres

figure;
subplot(3, 1, 1);
plot(t, x, 'b');
title('Señal Original');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
subplot(3, 1, 2);
plot(t, xn, 'r');
title('Señal con Ruido');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
subplot(3, 1, 3);
plot(t, y, 'g');
title('Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

%% -------------------------Reproduc---------------------------------------
%ruido, con ruido y filtrada.
%sound(x, fs);            % sin ruido
%pause(TF + 0.5);
%sound(y, fs);            % filtrado
%pause(TF + 0.5);
%sound(xn, fs);            % con ruido

%% -------------------------Inciso g---------------------------------------
% Grafique la respuesta en frecuencia de las señales original y filtrada y compare.
% Utilice la función provista my_dft().
% function [f, dft_mag, dft_phase, dft, NFFT] = my_dft(data, Fs)

[f, dft_mag_x, ~, ~, ~]   = my_dft(x, fs);
[~, dft_mag_xn, ~, ~, ~]  = my_dft(xn, fs);
[~, dft_mag_y, ~, ~, ~]   = my_dft(y, fs);

figure;
subplot(3, 1, 1);
plot(f, dft_mag_x, 'b');
title('Magnitud de la Señal Original');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
grid on;
subplot(3, 1, 2);
plot(f, dft_mag_xn, 'r');
title('Magnitud de la Señal con Ruido');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
grid on;
subplot(3, 1, 3);
plot(f, dft_mag_y, 'g');
title('Magnitud de la Señal Filtrada');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
grid on;

%% -------------------------Inciso h---------------------------------------
% Repita los puntos c) a h) para λ igual a 0.9 y 0.98.
% Analice el comportamiento de la fco.