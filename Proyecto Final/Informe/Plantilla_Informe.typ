// ============================================================
// Plantilla de Informe — Control y Sistemas
// Basada en: Salazar (2025), adaptada a AUV Maribot LoLo
// ============================================================

#let project-title = "Control y Sistemas — Proyecto Final"
#let project-subtitle = "Diseño de un Sistema de Control Automático para el AUV Maribot LoLo"
#let author = "Juan Manuel Borquez Perez"
#let student-id = "13567"
#let university = "Facultad de Ingeniería — Universidad Nacional de Cuyo"
#let date = "Julio 2026"

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  numbering: "1",
)
#set text(font: "Libertinus Serif", size: 11pt)
#set heading(numbering: "1.1")
#set par(justify: true, leading: 0.65em)
#set figure(
  kind: image,
  gap: 0.5em,
  numbering: "1",
)

// ============================================================
// PORTADA
// ============================================================
#align(center, text(size: 24pt, weight: "bold", project-title))
#v(0.3cm)
#align(center, text(size: 14pt, project-subtitle))
#v(1cm)
#align(center, text(size: 11pt, author))
#align(center, text(size: 10pt, student-id))
#v(0.5cm)
#align(center, text(size: 10pt, university))
#align(center, text(size: 10pt, date))
#v(2cm)

#align(center, text(size: 9pt, weight: "bold", "Resumen")) + text(size: 9pt)[
  Este trabajo presenta el desarrollo de una simulación completa de un vehículo submarino
  autónomo (AUV) en Simulink, que incluye la modelación de la dinámica no lineal del sistema
  y el diseño de un controlador LQR con acción integral para el seguimiento de trayectorias 3D,
  basado en la linealización del modelo alrededor de múltiples puntos de operación (gain scheduling).
  Se implementó un Filtro de Kalman Extendido (EKF) para la estimación robusta del vector de
  estados, integrando datos sensoriales provenientes de una AHRS, DVL, altímetro y sensor de
  profundidad. La simulación en lazo cerrado permitió validar el desempeño del sistema ante
  trayectorias de referencia, evidenciando un seguimiento preciso y estable. Además, se modelaron
  detalladamente los errores característicos de cada sensor, incluyendo ruido y cuantización, con el
  objetivo de replicar condiciones realistas de operación.
]

#v(0.5cm)
#align(center, text(size: 9pt, weight: "bold", "Palabras clave")) + text(size: 9pt)[
  AUV, Maribot LoLo, LQR, gain scheduling, EKF, Simulink, control en espacio de estados
]

#pagebreak()

// ============================================================
// TABLA DE CONTENIDOS
// ============================================================
#outline(title: "Índice")

#pagebreak()

// ============================================================
// 1. INTRODUCCIÓN
// ============================================================
= Introducción

Los vehículos submarinos autónomos (AUVs) cuentan con una amplia gama de aplicaciones,
que incluyen exploración oceánica, monitoreo ambiental, inspección de infraestructura submarina
y aplicaciones de defensa. Su versatilidad, y la integración tecnológica variada que se requiere
para su desarrollo, ha hecho de los AUVs un caso de estudio de mucho interés.

El control de un AUV plantea retos importantes desde el punto de vista dinámico, ya que se trata
de un sistema no lineal, multivariable, fuertemente acoplado y subactuado. Esto exige el desarrollo
de modelos precisos del comportamiento del vehículo, así como la implementación de estrategias
de control robustas que garanticen estabilidad y seguimiento de trayectorias bajo diversas
condiciones operativas.

En este trabajo se desarrolla una simulación integral del AUV Maribot LoLo en el entorno Simulink,
que incluye tanto el modelado dinámico del sistema a partir de las ecuaciones de Fossen, como la
implementación de un controlador LQR con acción integral y gain scheduling. Además, se modelan
virtualmente los sensores de navegación del vehículo, como AHRS, DVL, altímetro y sensor de
profundidad, incorporando errores realistas. Para la estimación del vector de estados a partir de
estas mediciones, se implementa un Filtro de Kalman Extendido (EKF).

El AUV a ser modelado está pensado para una aplicación de exploración submarina, lo cual
condiciona su peso, dimensiones, carga y la potencia de los actuadores usados para su propulsión.

El vehículo de referencia es el _Maribot LoLo_, desarrollado en el KTH Centre for Naval
Architecture como parte del Swedish Maritime Robotics Centre (SMaRC). Se trata de un AUV
de 3.8 m de eslora, 600 kg de masa, con 6-DOF y siete actuadores: dos hélices contrarrotantes
(CRP), dos timones acoplados, dos elevones y un elevador. Cuenta además con un sistema de
flotabilidad variable (VBS) y sensores AHRS, DVL, altímetro y de profundidad.

== Objetivos

El objetivo general es diseñar, simular y verificar un sistema de control automático para el
AUV Maribot LoLo capaz de realizar seguimiento de trayectorias 3D de exploración.

=== Requerimientos funcionales

#table(
  columns: (auto, 1fr, 1.5fr, auto),
  stroke: 0.5pt,
  [*ID*], [*Descripción*], [*Verificación*], [*Ref.*],
  [RF1], [Hovering estabilizado en 6-DOF],
    [Simulación en lazo cerrado: el AUV parte de una condición inicial perturbada y debe retornar al punto de consigna.], "1, 2",
  [RF2], [Seguimiento de trayectoria 3D por waypoints],
    [Simulación del perfil de exploración. Error de seguimiento debe cumplir RP1.], "2, 3, 4",
  [RF3], [Control con estados estimados (EKF)],
    [Comparación de la simulación con estados ideales vs. estados estimados. Error debe cumplir RP4.], "5",
  [RF4], [Rechazo a perturbaciones (corriente marina)],
    [Inyección del perfil de corriente. Error transitorio debe recuperarse dentro de RP2.], "6, 7, 8",
  [RF5], [Controlador discretizado para implementación digital],
    [Comparación del desempeño continuo vs. discreto.], "3",
)

=== Requerimientos de performance

#table(
  columns: (auto, 1fr, auto, auto, 1.5fr, auto),
  stroke: 0.5pt,
  [*ID*], [*Métrica*], [*Valor*], [*Unidad*], [*Condición*], [*Ref.*],
  [RP1], [Error seguimiento estacionario], [$< 2$], [%],
    [Medido sobre cada eje $(x, y, z)$ después del establecimiento.], "3",
  [RP2], [Tiempo de establecimiento (5%)], [$< 30$], [s],
    [Para escalón en cada DOF individual.], "2, 3",
  [RP3], [Sobrepico máximo], [$< 15$], [%],
    [Sobre la referencia escalón.], "9",
  [RP4], [Error RMSE de estimación EKF], [$< sigma$], [según sensor],
    [RMSE menor que desviación estándar del ruido del sensor.], "5",
  [RP5], [Esfuerzo de control dentro de límites], [Sin saturación permanente], [RPM, deg],
    [RPM $<= 1628$, deflexiones $<= 30$°.], "10, 11",
  [RP6], [Error máximo bajo perturbación], [$< 5$], [%],
    [Error pico durante corriente; debe recuperarse a $< 2$% después.], "6, 7, 8",
)

=== Escenario de prueba

Se define un perfil de exploración típico como trayectoria de referencia (patrón lawnmower adaptado [4]):

#align(center, table(
  columns: (auto, auto, auto, auto, 2fr),
  stroke: 0.5pt,
  [*Punto*], [*N (m)*], [*E (m)*], [*D (m)*], [*Descripción*],
  [1], [$0$], [$0$], [$0$], [Superficie (inicio)],
  [2], [$0$], [$0$], [$50$], [Descenso controlado],
  [3], [$500$], [$0$], [$50$], [Transecto horizontal],
  [4], [$500$], [$100$], [$50$], [Desplazamiento lateral],
  [5], [$500$], [$100$], [$0$], [Ascenso controlado],
  [6], [$0$], [$100$], [$0$], [Retorno superficial],
  [7], [$0$], [$0$], [$0$], [Cierre],
))

Velocidad de crucero nominal: 1-2 m/s.

=== Perturbación ambiental

Se modela una corriente marina con perfil dependiente de la profundidad (modelo de decaimiento lineal [8]):

$ V_("curr") (z) = V_("surf") (1 - z / z_("max")) $

con $V_("surf") = 0.5 "m/s"$ y $z_("max") = 100 "m"$. La corriente actúa como fuerza
externa sobre la dinámica del vehículo, sumándose al término de arrastre.

// ============================================================
// 2. MODELO DE LA PLANTA
// ============================================================
= Modelo de la Planta

El Maribot LoLo es un AUV desarrollado en el KTH Centre for Naval Architecture como parte
del Swedish Maritime Robotics Centre (SMaRC). Cuenta con 6 grados de libertad (6-DOF) y
siete actuadores: dos hélices contrarrotantes, dos timones, dos elevones y un elevador.

== Suposiciones que simplifican el modelo físico

- Se asume que el vehículo es un cuerpo rígido.
- Se asume que los propulsores son rígidos.
- El casco es simétrico respecto a los planos XZ (port-estribor) y XY (fondo-superficie).
- El centro de masa y el centro de flotabilidad coinciden en los ejes $x$ e $y$.
- Se asume que la Tierra es plana y es el sistema de referencia inercial (NED).
- Las fuerzas de arrastre se modelan como proporcionales a la velocidad lineal en cada eje.
- Se ignoran efectos complejos como la dependencia con la velocidad cuadrática.
- En un principio se asume velocidad de corriente nula. Más adelante se incluye como
  perturbación externa.

== Sistemas de referencia

Se toman en consideración dos sistemas de referencia: el sistema de referencia inercial NED
(North-East-Down) y el sistema de referencia del cuerpo del vehículo (BODY).

== Análisis cinemático

=== Matrices de Rotación

Para describir la orientación del AUV en el espacio tridimensional, se utilizan las matrices de
rotación asociadas a los ángulos de Euler $phi$ (roll), $theta$ (pitch) y $psi$ (yaw).

#pagebreak()

=== Cinemática rotacional

Para el análisis de la cinemática rotacional, se toma la relación entre las derivadas de los
ángulos de Euler y el vector de velocidad angular del AUV en su propio sistema de referencia.

== Dinámica del AUV

La determinación de las ecuaciones representantes de la dinámica del AUV se realiza a través
del modelo vectorial de Fossen:

$ M bold(nu) dot + C(bold(nu)) bold(nu) + D(bold(nu)) bold(nu) + g(bold(eta)) + g_0 = bold(tau) $

Donde $bold(eta) = [x, y, z, phi, theta, psi]^T$ es la posición y orientación en NED, y
$bold(nu) = [u, v, w, p, q, r]^T$ son las velocidades lineales y angulares en BODY.

=== Masa e inercia

| Parámetro | Símbolo | Valor | Unidad |
|-----------|---------|-------|--------|
| Eslora | $L$ | 3.8 | m |
| Manga | $b$ | 1.05 | m |
| Puntal | $h$ | 0.6 | m |
| Masa | $m$ | 600 | kg |
| Inercia roll | $I_x$ | 37 | kg·m² |
| Inercia pitch | $I_y$ | 370 | kg·m² |
| Inercia yaw | $I_z$ | 389 | kg·m² |

=== Modelo de propulsores

Los propulsores son dos hélices contrarrotantes (CRP) accionadas por motores BLDC de 7 kW
cada una. El empuje de cada hélice en función de las RPM es:

$ T = 5.1 times 10^(-5) R |R| + 0.0026 |R| $

=== Modelo de superficies de control

El vehículo cuenta con dos timones acoplados y un elevador. Las fuerzas generadas dependen
de la velocidad de avance $u$ y del ángulo de deflexión.

=== Sistema de flotabilidad variable (VBS)

El VBS permite mantener flotabilidad neutra, controlar profundidad a velocidad cero, y ajustar
los ángulos de pitch y roll mediante el desplazamiento de agua de mar entre tanques.

== Implementación en Simulink

La planta fue simulada a través de bloques MATLAB Function Block de Simulink, implementando
las ecuaciones de movimiento del AUV vistas anteriormente.

=== Simulación a lazo abierto

// ============================================================
// 3. DISEÑO DEL CONTROLADOR LQR
// ============================================================
= Diseño del Controlador LQR

Se optó por un controlador LQR en el espacio de estados. Esto requiere una aproximación lineal
de la planta no lineal mediante linealización Jacobiana.

== Análisis de controlabilidad

La controlabilidad del sistema se verificó mediante un script en MATLAB, calculando el rango de
la matriz de controlabilidad.

== Cálculo de la ganancia de realimentación

$ bold(u) = -K bold(x) $

La matriz $K$ se calcula con el método LQR de MATLAB, utilizando las matrices de ponderación
$Q$ y $R$.

== Ganancia de referencia

Para el seguimiento de trayectorias, se utiliza una matriz $k_r$ que modifica la ley de control:

$ bold(u) = -K bold(x) + k_r bold(r)(t) $

== Acción integral

Para eliminar el error de estado estacionario, se añaden variables de estado que representan la
integral del error entre la posición medida y la referencia.

// ============================================================
// 4. SELECCIÓN DE ACTUADORES
// ============================================================
= Selección de Actuadores

// ============================================================
// 5. SENSORES Y ESTIMACIÓN DEL VECTOR DE ESTADOS
// ============================================================
= Sensores y Estimación del Vector de Estados

== Representación de Sensores y Parámetros de Referencia

Cada sensor fue modelado en Simulink incorporando efectos de ruido y limitaciones prácticas.

=== AHRS (Attitude and Heading Reference System)

=== DVL (Doppler Velocity Log)

=== Altímetro

=== Sensor de profundidad

== Aplicación del EKF en Sistemas No Lineales

Debido a la naturaleza no lineal del sistema, se implementó un Filtro de Kalman Extendido (EKF).

== Ajuste de Covarianzas

Las matrices de covarianza del EKF se definieron a partir de las especificaciones técnicas de
cada sensor.

// ============================================================
// 6. SIMULACIÓN A LAZO CERRADO
// ============================================================
= Simulación a Lazo Cerrado

== Simulación sin ruido

=== Prueba de Hovering

=== Seguimiento de trayectoria

== Simulación con ruido

== Incorporación de perturbaciones externas

=== Modelo de corriente marina

=== Respuesta del sistema

== Discretización del controlador

=== Selección del tiempo de muestreo

=== Comparación continuo vs discreto

// ============================================================
// 7. CONCLUSIONES
// ============================================================
= Conclusiones

== Trabajos futuros

- Optimización de Pesos en Control LQR y EKF
- Aerodinámica más detallada (arrastre cuadrático)
- Dinámica de los Actuadores (retrasos y saturación)
- Considerar pérdida de carga
- Utilización de un método de control no lineal (MPC)

// ============================================================
// 8. REFERENCIAS
// ============================================================
= Referencias

#align(left, text(size: 9pt)[
  [1] Deutsch, C. et al. (2018). *Design of an AUV Research Platform for Demonstration of
  Novel Technologies*. OCEANS 2018 MTS/IEEE Charleston. +
  [2] Holm, G. (2020). *Optimal Control Model for an Autonomous Underwater Vehicle*.
  MSc Thesis, KTH Royal Institute of Technology, Stockholm. DiVA: diva2:1453639. +
  [3] Fossen, T. I. (1994). *Guidance and Control of Ocean Vehicles*. John Wiley & Sons,
  Chichester. ISBN 0-471-94113-1. +
  [4] Pyo, J., Cho, H., Joe, H., Ura, T. & Yu, S.-C. (2015). Development of hovering type
  AUV "Cyclops" and its performance evaluation using image mosaicing. *Ocean Engineering*,
  109, 517--530. DOI: 10.1016/j.oceaneng.2015.09.023. +
  [5] Bar-Shalom, Y., Li, X. R. & Kirubarajan, T. (2001). *Estimation with Applications to
  Tracking and Navigation*. John Wiley & Sons, New York. ISBN 0-471-41655-X. +
  [6] Zhang, Y., Che, J., Hu, Y., Cui, J. & Cui, J. (2023). Real-Time Ocean Current
  Compensation for AUV Trajectory Tracking Control Using a Meta-Learning and Self-Adaptation
  Hybrid Approach. *Sensors*, 23(14), 6417. DOI: 10.3390/s23146417. +
  [7] Jimoh, I. A., Yue, H. & Küçükdemiral, I. B. (2023). Autonomous Underwater Vehicle
  Positioning Control --- a Velocity Form LPV-MPC Approach. *IFAC-PapersOnLine*, 56(2),
  4388--4393. DOI: 10.1016/j.ifacol.2023.10.1820. +
  [8] Ardhuin, F. et al. (2008). The Depth-Dependent Current and Wave Interaction Equations:
  A Revision. *Journal of Physical Oceanography*, 38(11), 2589--2608. +
  [9] Ogata, K. (2010). *Modern Control Engineering*. 5th ed., Prentice Hall, Upper Saddle
  River, NJ. ISBN 978-0-13-615673-4. +
  [10] Galeani, S., Tarbouriech, S., Turner, M. & Zaccarian, L. (2009). A Tutorial on Modern
  Anti-windup Design. *European Journal of Control*, 15(3--4), 418--440.
  DOI: 10.3166/ejc.15.418-440. +
  [11] Sarhadi, P., Ranjbar Noei, A. & Khosravi, A. (2016). Model reference adaptive PID
  control with anti-windup compensator for an autonomous underwater vehicle. *Robotics and
  Autonomous Systems*, 83, 87--93. DOI: 10.1016/j.robot.2016.05.016. +
  [12] Salazar, R. (2025). *Control y Simulación de un Cuadricóptero*. Proyecto Final,
  UNCuyo.
])
