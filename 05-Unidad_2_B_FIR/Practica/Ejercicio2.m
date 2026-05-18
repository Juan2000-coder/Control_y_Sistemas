clear; close all; clc;
%% -------------------------Inciso a---------------------------------------
% Cargue el archivo de audio provisto llamado Tchaikovsky.mat. En el mismo
% encontrará dos variables, la matriz signal con dos canales (stereo) y la
% variable Fs. Elija 1 de los 2 canales disponibles.

load('Tchaikovsky.mat'); % Incorpor Fs y signal (numel, 2)
signal_r = signal(:, 1); % Canal derecho
signal_l = signal(:, 2); % Canal Izquierdo
x        = signal_r;     % Usamos la signal_r

%% -------------------------Inciso b---------------------------------------
% Agregue ruido gaussiano a esta señal tal que la relación señal-ruido
% entre la señal y la señal con ruido sea de 50 dB.
SNR = 18;
xn  = my_awgn(x, SNR); % n de noisy

%% -------------------------Inciso c---------------------------------------
% Calcule el valor máximo de N (N_max), con las frecuencias fs = Fs y fco = 22.050
fs  = Fs;       % Frecuencia de muestreo (Hz)
fco = 11025.0;  % Frecuencia de corte(Hz)

% Vector de tiempo
[len, ~] = size(signal);
Ts       = 1/fs;        % Período de muestreo
tf       = (len-1)*Ts;  % Instante final
t        = 0:Ts:tf;     % Definir el tiempo con paso constante

Nmax     = floor(fs/(2*fco));

%% -------------------------Inciso d---------------------------------------
% Aplique filtrado del tipo moving average a la señal con ruido para un
% filtro MA con dimensión igual N = N_max. Utilice la función filter().
N    = Nmax*5;
b    = (1/N)*ones(1, N);
a    = 1;                 % filtro tipo FIR a=1
y    = filter(b, a, xn);

%% -------------------------Inciso e---------------------------------------
% Utilice la función sound(signal_n, Fs) para reproducir las señales sin
% ruido, con ruido y filtrada.
sound(x, fs);   % sin ruido
pause(tf + 0.5);
sound(xn, fs);  % con ruido
pause(tf + 0.5);
sound(y, fs);   % filtrado

%% -------------------------Inciso f---------------------------------------
% Grafique la respuesta en frecuencia de las señales original y filtrada
% y compare. Utilice la función provista my_dft.
[f, dft_mag_x, ~, ~, ~]   = my_dft(x, fs);
[~, dft_mag_xn, ~, ~, ~]  = my_dft(xn, fs);
[~, dft_mag_y, ~, ~, ~]   = my_dft(y, fs);

%% -------------------------Graficas---------------------------------------
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
