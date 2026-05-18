clc; clear; close all;
%%-------------------------EJERCICIO1---------------------------------------
% Parámetros de la señal
f  = 100.0;   % Frecuencia de la señal (Hz)
fs = 10000.0;  % Frecuencia de muestreo (Hz)
ti = 0.0;     % Tiempo inicial (s)
tf = 1.0;     % Tiempo final (s)

% Vector de tiempo
Ts = 1/fs;      % Período de muestreo
t = ti:Ts:tf;   % Definir el tiempo con paso constante

% Señal seno
X = sin(2*pi*f*t) + 3;

%% --------------------GRAFICA DE PRUEBA DE SENO---------------------------
%{
figure;  % Crear una nueva figura
plot(t, X, 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title(sprintf('Señal senoidal de %.1f Hz', f));
grid on;
xlim([ti tf]);      % Ajustar el eje X
ylim([-1.2 1.2]);   % Ajustar el eje Y para mejorar visualización
%}

%%-------------------------EJERCICIO2---------------------------------------
%% ------- -----------PRUEBA RUIDO GAUSSIANO -------------------------------
%{
mu      = 0;                              % Media
sigma   = 0.5;
gaussian_noise = mu + 2*randn(1, 10000);  % Ruido gaussiano
histograma(gaussian_noise);
%}


% Importante indicara aca 'measured' para que la función awgn calcule la
% potencia de la señal antes de agregarle el ruido gaussiano.
% Sino asume que la potencia de la señal es 0 dBW.

SNR        = 10;
my_X_noisy = my_awgn(X, SNR);
X_noisy    = awgn(X, SNR, 'measured');

%%--------------------------GRAFICAR--------------------------------------
figure;

subplot(2, 1, 1);
hold on;
grid on;
plot(t, my_X_noisy, 'r', 'LineWidth', 1.5);
plot(t, X, 'b', 'LineWidth', 1.5);
legend('Señal con ruido my\_awgn', 'Señal original');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title(sprintf('Comparación de señal con myawgn y señal original de %.1f Hz', f));
xlim([ti tf]);      % Ajustar el eje X
%ylim([-1.2 1.2]);   % Ajustar el eje Y para mejorar visualización

subplot(2, 1, 2);
hold on;
plot(t, X_noisy, 'r', 'LineWidth', 1.5);
plot(t, my_X_noisy, 'b', 'LineWidth', 1.5);
legend('Señal con ruido awgn', ' Señal con ruido my\_awgn');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title(sprintf('Comparación de señal con awgn y myawgn %.1f Hz', f));
grid on;
xlim([ti tf]);      % Ajustar el eje X
%ylim([-1.2 1.2]);   % Ajustar el eje Y para mejorar visualización


% Probar esto indicando 'measured' e indicando nada en awgn
% se puede comprobar que son diferentes la potencia calculada
% del ruido con la fórmula del TP comparada con la que se obtiene
% con el cálculo directo.
% Cuando se asume que la potencia en dbW de la señal es 0
% la potencia del ruido que se calcula con la fórmula coincide
% con la que se obtiene con el cálculo directo de la potencia.

% Extraer el ruido de X_noisy
noise      = X_noisy - X;

% Calcular la media del ruido
mean_noise = mean(noise);

% Calcular la potencia del ruido
P_noise    = var(noise);

% Imprimir los valores
fprintf('Media del ruido awgn: %.4f\n', mean_noise);
fprintf('Potencia del ruido awgn: %.4f\n', P_noise);

% histograma(noise);

%%-------------------------FUNCIONES---------------------------------------
% Una nota es que la función awgn de matlab calcula la potencia de la señal
% como la suma promedio del cuadrado de la señal, mientras que la función
% var calcula la varianza de la señal, que es la suma promedio del cuadrado
% de la señal menos la media al cuadrado.

% Definir una función my_awgn
function noisy_signal = my_awgn(signal, SNR)
    % Calcular la potencia de la señal
    P_signal     = var(signal);      % Potencia de la señal
    noise_factor = 10^(-SNR/10);     % Factor de reducción de la SNR
    
    % Potencia del ruido
    P_noise     = 1 * noise_factor;
    P_noise % Para comprobar la potencia del ruido
    
    mu_noise    = 0;
    sigma_noise = sqrt(P_noise);
    
    % Generar y agregar ruido gaussiano mu = 0; sigma = sigma_noise
    noise        = mu_noise + sigma_noise * randn(size(signal));
    noisy_signal = signal + noise;
end

function histograma(signal)
    % Encontrar mínimo y máximo
    x_min = min(signal);
    x_max = max(signal);

    % Definir los intervalos del histograma con ancho de 0.1
    delta       =   0.1;  
    bin_edges   = x_min:delta:x_max;  

    % Calcular histograma
    counts = histcounts(signal, bin_edges,'Normalization', 'probability');  

    % Graficar histograma
    figure;
    bar(bin_edges(1:end-1), counts, 'histc');  % Se usa 'histc' para alinear los bins
    xlabel('Valor de la señal');
    ylabel('Frecuencia');
    title('Histograma de la señal');
    grid on;
end