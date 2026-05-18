% Ejercicio4_Práctico_nuevo
clc; clear; close all;

%%-------------------------SEAÑES Y RUIDO----------------------------------
fn = 100;             % Hz (Límite de la banda de la señal útil)
fm = 2000;            % Hz (frecuencia a los -60 dB mínima atenuación)
fs = fn + fm + 50;         % Hz frecuenca de sampling requerida mínima

tfinal   = 0.5;                % s
t        = 0:1/fs:tfinal;    % Vector de tiempo
len      = length(t);
x_signal = zeros(size(t));   % Señal útil

for f_util   = 10:10:100 % Vector de f útiles a intervalos de 10 Hz
    %(10, 20, 30, 40, 50, 60, 70, 80, 90, 100 Hz)
    % Suma de senos com amplitudes aleatorias entre 1 y 5
    x_signal = x_signal + (rand(1)*4 + 1)*sin(2*pi*f_util*t);
end

x_noise = zeros(size(t));   % Señal CON RUIDO
for f_util = 200:100:2000    % Vector de f de ruido a intervalos de 50 Hz
    %(150, 200, 250, 300, 350, 400... Hz)
    % Suma de senos com amplitudes aleatorias entre 1 y 3
    x_noise = x_noise + (rand(1)*2 + 1)*sin(2*pi*f_util*t);
end

x_sampled = x_signal + x_noise;    % Señal medida: RUIDO + SEÑAL
delta_om  = 2*pi/len;

% Graficar la señal medida
%{
figure(1);
subplot(3, 1, 1);
plot(t, x_sampled);
title('Señal medida');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

% Graficar la señal útil
subplot(3, 1, 2);
plot(t, x_signal);
title('Señal útil');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

% Grafica del espectro de frecuencia de la señal sampleada
subplot(3, 1, 3);
plot(0:delta_om:2*pi-delta_om, abs(fft(x_sampled)));
title('Espectro de la señal sampleada');
xlabel('Frecuencia discreta(\omega)');
ylabel('Amplitud');
grid on;
%}


%%---------------CARACTERÍSTICAS DEL FILTRO--------------------------------
% Primero aplico un filtro suave de 2 orden de butterwords
N_antialiasing  = 2;                                   % Orden del filtro
fc              = 500;                                 % Frecuencia de corte
[b_ant, a_ant]  = butter(N_antialiasing, fc/(fs/2));   % Filtro de orden N
x_antialiasing  = filter(b_ant, a_ant, x_sampled);     % filtro antialiasing

%{
figure(2);
grid on;
subplot(4, 1, 1); % Gráfica de la respuesta en frecuencia del filtro
freqz(b_ant, a_ant);
title("Filtro Antialiasing");

subplot(4, 1, 3);
plot(t, x_antialiasing);
title('Señal medida filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

subplot(4, 1, 4);
plot(0:delta_om:2*pi-delta_om, abs(fft(x_antialiasing)));
title('Espectro de la señal sampleada luego de filtro antialiasing');
xlabel('Frecuencia discreta (\omega)');
ylabel('Amplitud');
grid on;
%}

%%-----------------FILTRO PASABAJOS ABRUPTO-------------------------------
N_digital               = 15;                             % Orden del filtro
fc                      = fn + 10;                         % Frecuencia de corte
[b_digital, a_digital]  = butter(N_digital, fc/(fs/2));   % Filtro de orden N
x_filter_digital        = filter(b_digital, a_digital, x_antialiasing); % filtro digital

% Gráfica de la resulta del filtro
%{
figure(3);
subplot(4, 1, 1); % Gráfica de la respuesta en frecuencia del filtro
grid on;
freqz(b_digital, a_digital);
title("Filtro Digital");

subplot(4, 1, 3);
grid on;
plot(t, x_filter_digital);
title('Señal medida filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(4, 1, 4);
plot(0:delta_om:2*pi-delta_om, abs(fft(x_filter_digital)));
title('Espectro de la señal filtrada digitalmente');
xlabel('Frecuencia discreta (\omega)');
ylabel('Amplitud');
grid on;
%}

%%------------------------DECIMACIÓN----------------------------------------
% redondeo al entero mas pequeño de fs/(2fn)
M_orig       = floor(fs/(2*fn));          % Factor de decimación
M            = 1;                  % Decimación menos brusca
f_decim      = fs/M;                      % Frecuencia decimación
x_decim      = x_filter_digital(1:M:end); % Decimación de la señal
t_decim      = t(1:M:end);                % Vector de tiempo decimado
delta_om_decim = 2*pi/length(x_decim);

% Graficar la señal decimada
%{
figure(4);
subplot(2, 1, 1);
plot(t_decim, x_decim);
title('Señal decimada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
subplot(2, 1, 2);
plot(0:delta_om_decim:2*pi-delta_om_decim, abs(fft(x_decim)));
title('Espectro de la señal decimada');
xlabel('Frecuencia discreta (\omega)');
ylabel('Amplitud');
grid on;
%}

%%-------------------COMPARACIÓN FINAL--------------------
figure(5);
% En un subplot, la x_sampled, x_antialiasing, x_filter_digital y x_decim
subplot(4, 1, 1);
plot(t, x_sampled);
title('Señal medida');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
subplot(4, 1, 2);
plot(t, x_antialiasing);
title('Señal luego de filtro antialisasing');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
subplot(4, 1, 3);
plot(t, x_filter_digital);
title('Señal medida filtrada digitalmente');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
subplot(4, 1, 4);
plot(t_decim, x_decim);
title('Señal decimada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
% En otro subplot, el espectro de la señal medida, filtrada, digitalmente
% filtrada y decimada
figure(6);
subplot(4, 1, 1);
plot(0:delta_om:2*pi-delta_om, abs(fft(x_sampled)));
title('Espectro de la señal medida');
xlabel('Frecuencia discreta (\omega)');
ylabel('Amplitud');
grid on;
subplot(4, 1, 2);
plot(0:delta_om:2*pi-delta_om, abs(fft(x_antialiasing)));
title('Espectro de la señal luego de filtro antialiasing');
xlabel('Frecuencia discreta (\omega)');
ylabel('Amplitud');
grid on;
subplot(4, 1, 3);
plot(0:delta_om:2*pi-delta_om, abs(fft(x_filter_digital)));
title('Espectro de la señal medida filtrada digitalmente');
xlabel('Frecuencia discreta (\omega)');
ylabel('Amplitud');
grid on;
subplot(4, 1, 4);
plot(0:delta_om_decim:2*pi-delta_om_decim, abs(fft(x_decim)));
title('Espectro de la señal decimada');
xlabel('Frecuencia discreta (\omega)');
ylabel('Amplitud');
grid on;

% En otro plot superponer x_sampled, x_signal, x_decim;
figure(7);
%plot(t, x_sampled);
%hold on;
plot(t_decim, x_decim);
hold on;
plot(t, x_signal);
title('Señal decimada y señal útil');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
legend('Señal decimada', 'Señal util');
