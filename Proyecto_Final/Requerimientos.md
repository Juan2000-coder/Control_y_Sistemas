# Requerimientos del Sistema de Control
## AUV Maribot LoLo — Seguimiento de Trayectorias 3D

> **Proyecto:** Control y Sistemas — Facultad de Ingeniería, UNCuyo
>
> **Autor:** Juan Manuel Borquez Perez
>
> **Versión:** 1.0
>
> **Fecha:** 2026-05-28

---

## 1. Alcance

Diseño, simulación y verificación de un sistema de control automático para el
vehículo submarino autónomo Maribot LoLo (KTH SMaRC) capaz de realizar
seguimiento de trayectorias de exploración en 6 grados de libertad (6-DOF),
utilizando un controlador LQR con gain scheduling y un filtro de Kalman
extendido (EKF) para estimación de estados.

El sistema se implementa y verifica íntegramente en Simulink. No se requiere
implementación embebida ni pruebas en agua real.

---

## 2. Requerimientos Funcionales

| ID | Descripción | Criterio de verificación | Ref. |
|----|-------------|--------------------------|------|
| **RF1** | El AUV debe mantener una posición fija en hovering (estabilización en 6-DOF) | Simulación en lazo cerrado: el AUV parte de una condición inicial perturbada y debe retornar al punto de consigna y mantenerse dentro de una tolerancia posicional | [1][2] |
| **RF2** | El AUV debe seguir una trayectoria de referencia 3D definida como una secuencia de waypoints | Simulación del perfil de exploración (Sección 4): error de seguimiento debe cumplir RP1 | [2][3][4] |
| **RF3** | El controlador debe operar utilizando estados estimados por el EKF, no estados ideales | Comparación de la simulación con estados ideales vs. estados estimados; el error de estimación debe cumplir RP4 | [5] |
| **RF4** | El sistema debe rechazar perturbaciones ambientales (corriente marina) manteniendo el seguimiento | Inyección del perfil de corriente (Sección 5) en la simulación; el error máximo transitorio debe recuperarse dentro de los límites de RP2 | [6][7][8] |
| **RF5** | El controlador debe discretizarse para implementación digital | Presentar el modelo discreto (por Tustin o ZOH) y comparar su desempeño contra el control continuo | [3] |

---

## 3. Requerimientos de Performance

| ID | Métrica | Valor | Unidad | Condición | Ref. |
|----|---------|-------|--------|-----------|------|
| **RP1** | Error de seguimiento en estado estacionario | < 2 | % de la escala de la trayectoria | Medido sobre cada eje (x, y, z) después del establecimiento | [3] |
| **RP2** | Tiempo de establecimiento (criterio 5 %) | < 30 | s | Para escalón en cada DOF individual | [2][3] |
| **RP3** | Sobrepico máximo | < 15 | % | Sobre la referencia escalón | [9] |
| **RP4** | Error RMSE de estimación del EKF | < σ | según cada sensor | La desviación RMSE debe ser menor que la desviación estándar del ruido de cada sensor | [5] |
| **RP5** | Esfuerzo de control dentro de límites físicos | Sin saturación permanente | RPM / deg | Actuadores dentro de rango: RPM ≤ 1628, deflexiones ≤ 30° | [10][11] |
| **RP6** | Error máximo bajo perturbación (corriente) | < 5 | % de la escala | Error pico durante evento de corriente, debe recuperarse a < 2 % | [6][7][8] |

> **Nota:** Los valores de RP2 y RP3 están dimensionados para la dinámica de un
> AUV de ~600 kg (constantes de tiempo del orden de 10-20 s). Un quadcopter
> (como el de Salazar) responde en segundos; un AUV no.

---

## 4. Escenario de Prueba: Perfil de Exploración

Trayectoria de referencia típica para una misión de exploración submarina (patrón lawnmower adaptado [4]):

```
Punto 1: (  0,   0,   0)  — Superficie (inicio)
Punto 2: (  0,   0, -50)  — Descenso controlado
Punto 3: (500,   0, -50)  — Transecto horizontal (Norte-Sur)
Punto 4: (500, 100, -50)  — Desplazamiento lateral (Este)
Punto 5: (500, 100,   0)  — Ascenso controlado
Punto 6: (  0, 100,   0)  — Retorno superficial
Punto 7: (  0,   0,   0)  — Cierre
```

Coordenadas en metros (NED: North-East-Down). Velocidad de crucero nominal:
1-2 m/s.

---

## 5. Perturbación: Corriente Marina

Perfil realista de corriente con dependencia de profundidad (modelo de decaimiento lineal [8]):

```
V_corriente(z) = V_sup · (1 - z / z_max)   para 0 ≤ z ≤ z_max
```

Donde:
- `V_sup` = 0.5 m/s (velocidad superficial)
- `z_max` = 100 m (profundidad de referencia donde la corriente se extingue)
- `z` = profundidad actual del AUV (positiva hacia abajo, según NED)
- Dirección: constante, Norte (eje x positivo)

La corriente actúa como fuerza externa sobre la dinámica del vehículo,
sumándose al término de arrastre en las ecuaciones de movimiento.

---

## 6. Criterios de Aceptación

El proyecto se considera completo cuando **todos** los siguientes puntos se
verifican mediante simulación documentada:

| # | Requisito | ¿Cumple? | Evidencia |
|---|-----------|----------|-----------|
| 1 | RF1: Hovering estabilizado | ☐ | Plot posición vs. tiempo (sección resultados) |
| 2 | RF2: Seguimiento de trayectoria | ☐ | Plot trayectoria 3D + error vs. tiempo |
| 3 | RF3: Control con EKF | ☐ | Comparación estados reales vs. estimados |
| 4 | RF4: Rechazo a perturbaciones | ☐ | Plot con corriente inyectada |
| 5 | RF5: Controlador discretizado | ☐ | Comparación continuo vs. discreto |
| 6 | RP1: Error < 2 % | ☐ | Tabla de métricas por eje |
| 7 | RP2: Settling < 30 s | ☐ | Tabla de métricas |
| 8 | RP3: Sobrepico < 15 % | ☐ | Tabla de métricas |
| 9 | RP4: Error EKF < σ | ☐ | RMSE de estimación |
| 10 | RP5: Esfuerzo dentro de límites | ☐ | Plot de actuadores |
| 11 | RP6: Error bajo corriente < 5 % | ☐ | Plot con perturbación |

> Los archivos de simulación, plots y tablas se referencian desde el informe.
> Cada ☐ se marca como ✅ cuando la simulación lo verifica.

---

## 7. Referencias

| # | Cita | Uso |
|---|------|-----|
| [1] | Deutsch, C. et al. (2018). *Design of an AUV Research Platform for Demonstration of Novel Technologies*. OCEANS 2018 MTS/IEEE Charleston. | Parámetros físicos del Maribot LoLo, configuración de actuadores, diseño del vehículo. |
| [2] | Holm, G. (2020). *Optimal Control Model for an Autonomous Underwater Vehicle*. MSc Thesis, KTH Royal Institute of Technology, Stockholm. DiVA: diva2:1453639. | Modelo dinámico 6-DOF, coeficientes de amortiguamiento, diseño LQR y MPC para el LoLo, tiempo de establecimiento de la respuesta. |
| [3] | Fossen, T. I. (1994). *Guidance and Control of Ocean Vehicles*. John Wiley & Sons, Chichester. ISBN 0-471-94113-1. | Ecuaciones de movimiento 6-DOF para vehículos marinos, especificaciones de desempeño (error estacionario, tiempo de establecimiento), discretización de controladores. |
| [4] | Pyo, J., Cho, H., Joe, H., Ura, T. & Yu, S.-C. (2015). Development of hovering type AUV "Cyclops" and its performance evaluation using image mosaicing. *Ocean Engineering*, 109, 517–530. DOI: 10.1016/j.oceaneng.2015.09.023. | Patrón de trayectoria lawnmower para misiones de exploración con AUV. |
| [5] | Bar-Shalom, Y., Li, X. R. & Kirubarajan, T. (2001). *Estimation with Applications to Tracking and Navigation*. John Wiley & Sons, New York. ISBN 0-471-41655-X. | Principio de fusión sensorial por EKF: el RMSE del estimador debe ser inferior a la desviación estándar del ruido de cada sensor. |
| [6] | Zhang, Y., Che, J., Hu, Y., Cui, J. & Cui, J. (2023). Real-Time Ocean Current Compensation for AUV Trajectory Tracking Control Using a Meta-Learning and Self-Adaptation Hybrid Approach. *Sensors*, 23(14), 6417. DOI: 10.3390/s23146417. | Compensación de corriente oceánica en el seguimiento de trayectorias de AUV, error máximo admisible bajo perturbación. |
| [7] | Jimoh, I. A., Yue, H. & Küçükdemiral, I. B. (2023). Autonomous Underwater Vehicle Positioning Control — a Velocity Form LPV-MPC Approach. *IFAC-PapersOnLine*, 56(2), 4388–4393. DOI: 10.1016/j.ifacol.2023.10.1820. | Control de AUV con corrientes variables, rechazo a perturbaciones ambientales. |
| [8] | Ardhuin, F. et al. (2008). The Depth-Dependent Current and Wave Interaction Equations: A Revision. *Journal of Physical Oceanography*, 38(11), 2589–2608. | Perfil de corriente con dependencia de profundidad (decaimiento lineal desde superficie). |
| [9] | Ogata, K. (2010). *Modern Control Engineering*. 5th ed., Prentice Hall, Upper Saddle River, NJ. ISBN 978-0-13-615673-4. | Especificaciones de respuesta transitoria: sobrepico máximo, tiempo de establecimiento, error en estado estacionario. |
| [10] | Galeani, S., Tarbouriech, S., Turner, M. & Zaccarian, L. (2009). A Tutorial on Modern Anti-windup Design. *European Journal of Control*, 15(3–4), 418–440. DOI: 10.3166/ejc.15.418-440. | Técnicas anti-windup para evitar saturación permanente de actuadores. |
| [11] | Sarhadi, P., Ranjbar Noei, A. & Khosravi, A. (2016). Model reference adaptive PID control with anti-windup compensator for an autonomous underwater vehicle. *Robotics and Autonomous Systems*, 83, 87–93. DOI: 10.1016/j.robot.2016.05.016. | Anti-windup aplicado a AUV de 6-DOF, saturación de actuadores en vehículos submarinos. |
| [12] | Salazar, R. (2025). *Control y Simulación de un Cuadricóptero*. Proyecto Final, UNCuyo. | Estructura de informe, métricas y referencias de verificación. |
