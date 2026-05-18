close all; clear; clc;

% Parámetros
fs      = 10000;          % Frecuencia de muestreo en Hz
dt      = 1/fs;           % Período de muestreo
fc1     = 300;            % Frecuencia de corte inferior (Hz)
fc2     = 3400;           % Frecuencia de corte superior (Hz)
ripple  = 1;              % Ripple en dB
orden   = 10;             % Orden del filtro (ajustable)

% Paso b: Frecuencias normalizadas (radianes)
wc1_n = 2*pi*fc1/fs;
wc2_n = 2*pi*fc2/fs;

% Paso c: Pre-warping
wc1_p = (2/dt)*tan(wc1_n/2);
wc2_p = (2/dt)*tan(wc2_n/2);

% Paso d: Filtro Chebyshev I analógico y paso-banda
[Z, P, K]   = cheb1ap(orden, ripple);
[B, A]      = zp2tf(Z, P, K);       % Numerador (B), denominador (A)
figure;
sys = tf(B, A);
pzmap(sys);
title('Polos zeros pasabajos chev'); grid on;

figure;
freqs(B, A)                         % (opcional: graficar si querés ver esto)
title('Filtro analogico chev'); grid on;

w_central       = sqrt(wc1_p * wc2_p);    % Frecuencia central (media geom)
bw              = wc2_p - wc1_p;          % Ancho de banda
[num_a, den_a]  = lp2bp(B, A, w_central, bw);

figure;
freqs(num_a, den_a)                         % (opcional: graficar si querés ver esto)
title('Filtro pasabandeado'); grid on;

% Paso e: Discretización con Tustin
H_analog  = tf(num_a, den_a);        % Sistema analógico
figure;
pzmap(H_analog);
title('Polos zeros filtro pasabandeado'); grid on;

H_digital = c2d(H_analog, dt, 'tustin');
num_d     = H_digital.Numerator{1};
den_d     = H_digital.Denominator{1};

% Paso f: Diagrama de polos y ceros
disp('Diagrama de polos y ceros en Z')
figure;
zplane(num_d, den_d);
title('Polos y zeros del filtro digital')
grid on

% Paso g: Respuesta en frecuencia
[h_a, w_a] = freqs(num_a, den_a, 1000);
[h_d, w_d] = freqz(num_d, den_d, 1000);

% Paso h: Gráficos
mag_a = abs(h_a);
phi_a = angle(h_a);
f_a   = w_a/(2*pi);       % Frecuencia en Hz

mag_d = abs(h_d);
phi_d = angle(h_d);
f_d   = w_d/(2*pi)*fs;    % Frecuencia en Hz

figure
plot(f_a, mag_a, 'b'); hold on
plot(f_d, mag_d, 'g');
title('RESPUESTA EN FRECUENCIA')
xlabel('Frecuencia (Hz)'); ylabel('|H(w)|')
grid on
legend('Filtro analógico', 'Filtro digital')

figure
plot(f_a, phi_a, 'b'); hold on
plot(f_d, phi_d, 'g');
title('RESPUESTA EN FASE')
xlabel('Frecuencia (Hz)'); ylabel('Fase (rad)')
grid on
legend('Filtro analógico', 'Filtro digital')
