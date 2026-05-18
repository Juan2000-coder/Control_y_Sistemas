clear; close all; clc;
clc; clear; close all;
%% -------------------------Inciso a---------------------------------------
% Genere una señal senoidal con frecuencia fundamental fn = 100 Hz. Elija una
% frecuencia de muestreo adecuada.

% Parámetros de la señal
fn = 100.0;     % Frecuencia de la señal (Hz)
fs = 5000.0;    % Frecuencia de muestreo (Hz)
ti = 0.0;       % Tiempo inicial (s)
tf = 20.0;       % Tiempo final (s)

% Vector de tiempo
Ts = 1/fs;      % Período de muestreo
t  = ti:Ts:tf;  % Definir el tiempo con paso constante

% Señal seno
x  = sin(2*pi*fn*t);

%% -------------------------Inciso b---------------------------------------
% Agregue ruido gaussiano a la señal senoidal tal que la relación señal-ruido
% entre la señal senoidal y la señal con ruido sea de 15 dB.

SNR = 15;
xn = my_awgn(x, SNR); % n de noisy

%%-------------------------Inciso c---------------------------------------
% Calcule el valor máximo del orden del filtro (N_max) fco = 2 fn.
fco  = 2*fn;
Nmax = floor(fs/(2*fco));        % f_zero aprox 2fco = fs/N

%% -------------------------Inciso d---------------------------------------
% Aplique filtrado del tipo moving average a la señal con ruido para un
% filtro MA con dimensión igual N = N_max. Utilice la función filter()
N    = Nmax/2;
b    = (1/N)*ones(1, N);
a    = 1;                 % filtro tipo FIR a=1
y    = filter(b, a, xn);

%%-------------------------Inciso e---------------------------------------
% Grafique la respuesta en frecuencia y fase del filtro MA. Use la función
% freqz()
freqz(b, a);

%% -------------------------Inciso f---------------------------------------
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


%% -------------------------Inciso g---------------------------------------
% Grafique la respuesta en frecuencia de las señales original y filtrada y compare.
% Utilice la función provista my_dft.
% function [f, dft_mag, dft_phase, dft, NFFT] = my_dft(data, Fs)

[f, dft_mag_x, ~, ~, ~]   = my_dft(x, fs);
[~, dft_mag_xn, ~, ~, ~]  = my_dft(xn, fs);
[~, dft_mag_y, ~, ~, ~]   = my_dft(y, fs);

figure;
subplot(3, 1, 1);
plot(f, 10*log10(dft_mag_x), 'b');
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
% Repita los puntos d) a g) para N = N_max / 2 y N = N_max * 10.

%% -------------------------Inciso i---------------------------------------
% Determinar la relación señal ruido resultante

ynoise         = y(floor(N/2)+ 1:end) - x(1:end-floor(N/2)); % Ruido de la señal filtrada
SNR_resultante = 10*log10(mean(x.^2)/mean(ynoise.^2));
disp(['SNR resultante: ', num2str(SNR_resultante), ' dB']);
[fynoise, dft_mag_ynoise, ~, ~, ~]   = my_dft(ynoise, fs);

% Graficar el espectro de frecuencia de noise
figure;
subplot(3, 1, 1);
plot(t, x, 'r');hold on;
plot(t(1:end-floor(N/2)), y((floor(N/2)+ 1:end)), 'b');
title('superposicion');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('seno','filtrado');
grid on;
subplot(3, 1, 2);
plot(fynoise, dft_mag_ynoise, 'm');
title('Magnitud del Ruido en la señal filtrada');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
grid on;
subplot(3, 1, 3);
plot(t(floor(N/2)+1:end), ynoise, 'c');
title('Ruido Filtrado');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;