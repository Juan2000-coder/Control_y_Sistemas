# Plan de Trabajo — AUV Maribot LoLo

## Fase 1: Modelado de la Planta (H1 — 10 días)

| # | Tarea | Estimación | ¿Cómo? |
|---|-------|-----------|--------|
| 1.1 | Leer referencias AUV (Fossen, Lolo paper, tesis Holm) | 2d | Extraer ecuaciones 6-DOF, parámetros físicos |
| 1.2 | Derivar modelo matemático 6-DOF | 2d | Ecuaciones de movimiento (surge, sway, heave, roll, pitch, yaw) + VBS |
| 1.3 | Obtener/estimar coeficientes hidrodinámicos | 1d | Del paper Lolo + literatura Fossen |
| 1.4 | Implementar dinámica no-lineal en Simulink | 2d | MATLAB Function Block o Simscape |
| 1.5 | Pruebas lazo abierto: escalón en thrust, superficies | 1d | Verificar respuesta cualitativa |
| 1.6 | Modelar VBS (sistema de flotabilidad variable) | 1d | Ecuación de cambio de masa/volumen |
| 1.7 | Documentar modelo para informe | 1d | Capturas, parámetros, ecuaciones |

## Fase 2: Sensores, Actuadores y Ruido (H2 — 8 días)

| # | Tarea | Estimación | ¿Cómo? |
|---|-------|-----------|--------|
| 2.1 | Modelar actuadores: BLDC + hélices CRP | 2d | Dinámica motor, relación thrust-velocidad |
| 2.2 | Modelar superficies de control (rudders, elevator) | 1d | Mapa elevación → momento |
| 2.3 | Modelar AHRS (acelerómetro, giroscopio, magnetómetro) | 1d | Ruido blanco, bias, cuantización |
| 2.4 | Modelar DVL + altímetro + profundidad | 1d | Ruido, rango válido, bottom-lock |
| 2.5 | Modelar ruido de proceso y medición | 1d | Densidades espectrales → varianzas discretas |
| 2.6 | Integrar todo en Simulink | 1d | Subsistemas separados |
| 2.7 | Pruebas de consistencia | 1d | Verificar señales |

## Fase 3: Controlador (H3 — 12 días)

| # | Tarea | Estimación | ¿Cómo? |
|---|-------|-----------|--------|
| 3.1 | Elegir puntos de operación para linealización | 1d | Velocidad crucero, hovering, ascenso/descenso |
| 3.2 | Linealización Jacobiana en cada punto | 2d | Symbolic Math Toolbox o numerical |
| 3.3 | Verificar controlabilidad y observabilidad | 1d | Matriz de controlabilidad (ctrb, rank) |
| 3.4 | Diseñar LQR base (1 punto) | 2d | Q/R tuning, respuesta escalón |
| 3.5 | Implementar gain scheduling | 2d | Interpolación de ganancias K |
| 3.6 | Diseñar EKF para fusión sensorial | 2d | Matrices Q/R del filtro |
| 3.7 | Integrar controlador + EKF en lazo cerrado | 2d | Simulink |

## Fase 4: Simulación y Validación (H4 — 7 días)

| # | Tarea | Estimación | ¿Cómo? |
|---|-------|-----------|--------|
| 4.1 | Prueba hovering (posición fija) | 1d | Métricas: overshoot, settling time |
| 4.2 | Seguimiento trayectoria exploración | 1d | Waypoints 3D → error de seguimiento |
| 4.3 | Simulación con ruido sensorial | 1d | Comparar estimación vs real |
| 4.4 | Perturbaciones ambientales (corriente) | 1d | Modelo de corriente marina |
| 4.5 | Discretización del controlador | 1d | Tustin/ZOH, elegir Ts |
| 4.6 | Simulación final con todo incluido | 1d | Escenario completo |
| 4.7 | Métricas de desempeño | 1d | RMSE, esfuerzo control, consumo |

## Fase 5: Informe (H5 — 8 días)

| # | Sección | Orden | Notas |
|---|---------|-------|-------|
| 5.1 | Portada + Resumen | 1 | Al final |
| 5.2 | Introducción + Objetivos | 1 | Plantear problema |
| 5.3 | Modelo de la Planta | 2 | Ecuaciones + Simulink |
| 5.4 | Sensores y Actuadores | 3 | Modelos + ruido |
| 5.5 | Estrategia de Control | 4 | LQR + gain scheduling |
| 5.6 | Estimación de Estados | 5 | EKF |
| 5.7 | Resultados | 6 | Plots + métricas |
| 5.8 | Conclusiones | 7 | Discusión + mejoras |
| 5.9 | Referencias + Apéndices | Último | Código fuente |

## Dependencias entre fases

```
H0 ──→ H1 ──→ H2 ──→ H3 ──→ H4 ──→ H5 ──→ H6
       │               │               │
       └── Informe ────┴── Informe ────┘
```
