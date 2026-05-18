% Paso 1: Definir cuantizadores
q1 = quantizer('fixed', 'floor', 'saturate', [32 0]);   % Q31.0
q2 = quantizer('fixed', 'floor', 'saturate', [32 8]);   % Q23.8
q3 = quantizer('fixed', 'floor', 'saturate', [32 16]);  % Q15.16

% Paso 2: Generar la señal
u = linspace(-15, 15, 1000);

% Paso 3: Aplicar cuantización
y1 = quantize(q1, u);
y2 = quantize(q2, u);
y3 = quantize(q3, u);

% Paso 4: Calcular RMSE
r1 = rmse(u, y1);
r2 = rmse(u, y2);
r3 = rmse(u, y3);

% Mostrar resultados
fprintf('RMSE para Q31.0  = %.6f\n', r1);
fprintf('RMSE para Q23.8  = %.6f\n', r2);
fprintf('RMSE para Q15.16 = %.6f\n', r3);
