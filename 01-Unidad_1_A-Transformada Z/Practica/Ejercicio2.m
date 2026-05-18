% 2.3
% Coeficientes de los polinomios X1(z) y X2(z)
X1 = [1 1 3]; % Representa 1 + z^(-1) + 3z^(-2)
X2 = [1 0 3]; % Representa 1 + 0*z^(-1) + 3z^(-2)

% Los coeficientes del polinomio indican directamente los valores
% de la señal en el tiempo.

% Multiplicación de los polinomios usando la función conv
X = conv(X1, X2);

% Mostrar el resultado
disp('El resultado de la multiplicación de los polinomios es:');
disp(X);

% 2.4
sX1 = filt(X1, [1]); % Se crea el filtro con los coeficientes de X1
sX2 = filt(X2, [1]); % Se crea el filtro con los coeficientes de X2
sX1X2 = sX1*sX2; % Se realiza la multiplicación de los filtros

% Mostrar el resultado
disp('El resultado de la multiplicación de los filtros es:');
sX1X2

% Si se pode hacer con filter
X2_padded = [X2 0 0 0 0];
X1_padded = [X1 0 0 0 0];

% X1 sería el sistema, el filtro.
yX1 = filter(X1, 1, X2_padded);
% X2 sería el sistema, el filtro.
yX2 = filter(X2, 1, X1_padded);

% Mostrar el resultado
disp('El resultado de la multiplicación con X1 como filtro:');
yX1
disp('El resultado de la multiplicación con X2 como filtro:');
yX2
% Graficar

% Señal X1
figure;
subplot(3, 1, 1);
stem(X1);
title('Señal X1');

% Señal X2
subplot(3, 1, 2);
stem(X2);
title('Señal X2');

% Señal X1*X2
subplot(3, 1, 3);
stem(X);
title('Señal X1*X2');

% Señal X1*X2 con X1 filter
figure;
subplot(2, 1, 1);
stem(yX1);
subplot(2, 1, 2);
stem(yX2);
title('Señal X1*X2 con filter');
