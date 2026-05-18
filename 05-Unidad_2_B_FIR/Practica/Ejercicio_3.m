clear; close all; clc;
%% -------------------------Inciso d y c-----------------------------------
% Utilice como señal de entrada el archivo Tchaikovsky.mat.
load('Tchaikovsky.mat'); % Incorpor Fs y signal (numel, 2)
signal_r = signal(:, 1); % Canal derecho
signal_l = signal(:, 2); % Canal Izquierdo
x        = signal_r;     % Usamos la signal_r

% Aplique a la señal de interés el filtro diseñado en el punto b) haciendo:
Hd         = fir_kaiser_300_3400;
b          = Hd.Numerator;
a          = 1;
fir_output = filter(b, a, x);

%% -------------------------Inciso f---------------------------------------
% Grafique los espectros de la señal original (signal) y filtrada (fir_output)
% con la función my_dft().
fs  = Fs;       % Frecuencia de muestreo (Hz)

% Vector de tiempo
[len, ~] = size(signal);
Ts       = 1/fs;        % Período de muestreo
tf       = (len-1)*Ts;  % Instante final
t        = 0:Ts:tf;     % Definir el tiempo con paso constante

[f, dft_mag_x, ~, ~, ~]             = my_dft(x, fs);
[~, dft_mag_fir_output, ~, ~, ~]    = my_dft(fir_output, fs);

% ruido, con ruido y filtrada.
%sound(x, fs);            % sin ruido
%pause(tf + 0.5);
%sound(fir_output, fs);   % filtrado

%% -------------------------Graficas---------------------------------------
figure;
subplot(2, 1, 1);
plot(t, x, 'b');
title('Señal Original');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
subplot(2, 1, 2);
plot(t, fir_output, 'r');
title('Señal con Ruido');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

figure;
subplot(2, 1, 1);
plot(f, dft_mag_x, 'b');
title('Magnitud de la Señal Original');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
grid on;
subplot(2, 1, 2);
plot(f, dft_mag_fir_output, 'r');
title('Magnitud de la Señal con Ruido');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
grid on;