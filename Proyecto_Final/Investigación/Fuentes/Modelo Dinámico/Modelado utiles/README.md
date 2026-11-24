* La carpeta de [modelado general](./modelado-en-general/) contiene los documentos de Fossen para el modelado general de un AUV
## [A Comprehensive Study on Modelling and Control of Autonomous Underwater Vehicle](./5-Paper_modelado_2024.pdf)
**ESTOS TOMAN EXACTAMENTE LOS MISMOS PARÁMETROS DE PRESTERO**
**SIRVE PARA MODELAR**

**Descripción:** Estudio de modelado y control de un AUV tipo REMUS, cuya geometría de casco se basa en el perfil de Myring. Utiliza un modelo dinámico no lineal de 6 GDL como punto de partida, pero desarrolla principalmente los controladores sobre modelos linealizados y desacoplados en el plano horizontal para la orientación y para la velocidad de rumbo y en el vertical para controlar el pitch y la profundidad.

**Relación con Prestero:** Toma de [Prestero](./verification-of-a-six-degree-of-freedom-simulation-model-for-4n98272on0.pdf) la geometría y diversos parámetros físicos e hidrodinámicos del REMUS, además de datos experimentales del propulsor y modelos de las superficies de control y los thrusters. No realiza una validación experimental independiente.

**Rescatable:**
- Procedimiento de desacoplamiento en los planos horizontal y vertical.
- Linealización alrededor de puntos de operación.
- Estructura de control en cascada:
  - Profundidad → pitch.
  - Desplazamiento lateral → yaw.
- Controladores PD para profundidad, pitch, yaw y velocidad de rumbo.
- Comparación de controladores PD, SMC y MPC.
- Escenarios de simulación y seguimiento de trayectorias, incluyendo trayectorias *lawn-mowing*.
- Evaluación ante perturbaciones externas (corrientes oceánicas) e incertidumbres paramétricas (centro de gravedad, parámetros hidrodinámicos).
- Evaluación de robustez frente a variaciones de parámetros del modelo.

**Descartable para el alcance del proyecto:**
- Modelo dinámico como fuente principal de la planta: deriva de trabajos anteriores.
- Identificación de parámetros: no realiza una identificación original.
- Implementación de SMC y MPC: fuera del alcance previsto.
- Resultados de simulación como validación experimental: no hay ensayos propios con el vehículo real.


## [Autonomous Underwater Vehicle Dynamics](./6-Underwater_vehicle_dynamics.pdf) - se puede descartar
**utilizan el REMUS como vehículo de referencia y realizan una identificación de parámetros mediante LSE, pero la identificación se hace con datos simulados, no con mediciones experimentales del vehículo real.**

**DESCARTAR - sirve solamente como método para identificar los parámetros de un sistema.**
**NO TOMAN BIEN LOS PARÁMETROS de PRESTERO**
La fuente principal para los parámetros físicos e hidrodinámicos es [Prestero](./verification-of-a-six-degree-of-freedom-simulation-model-for-4n98272on0.pdf). Las tablas de parámetros físicos e hidrodinámicos (tablas 3, 4 y 5) remiten a ese trabajo.

**Identificación mediante LSE**

No identifican todos los parámetros del modelo. Seleccionan un conjunto de coeficientes hidrodinámicos asociados a los movimientos de sway y yaw:

- $Y\_{vv}, Y\_{rr}, Y\_{uv}, Y\_{ur}, Y\_{wp}$
- $N\_{vv}, N\_{rr}, N\_{uv}, N\_{ur}, N\_{wp}$

Las gráficas *real model* y *identified model* comparan:

- Modelo original, con parámetros conocidos.
- Modelo identificado, con los parámetros estimados por LSE

No constituyen una validación experimental independiente del método.

**¿Qué modelo identifican y cómo lo validan?**

Hay un detalle importante: la identificación se concentra en la dinámica de sway-yaw. No hacen una identificación completa de los seis grados de libertad.

Para generar los datos de identificación simulan maniobras combinadas de sway y yaw. Luego comparan las respuestas del modelo original y del identificado en velocidad, posición y actitud.

También consideran ruido de medición en el planteamiento estadístico del estimador. Ruido de tipo gaussiano.

**Rescatable:**

- Desarrollo de las ecuaciones dinámicas no lineales de 6 GDL.
- Presentación de las simplificaciones y consideraciones para construir el modelo.

**Descartable para tu alcance:**

- Identificación mediante LSE, si no vas a estudiar identificación de parámetros.
- Implementación del SMC para yaw.
- Resultados de identificación como validación experimental del modelo: utilizan datos simulados.

## El del [Lolo](./9-Lolo_maribot.pdf)

Implementa **LQR y MPC sobre modelos linealizados de un AUV de 6 GDL y estudia el seguimiento de waypoints**.

El modelo de LoLo **no está completamente identificado ni validado tampoco el controlador**. Los autores reconocen que utilizan numerosas aproximaciones y parámetros supuestos.

**LoLo**

La configuración de actuadores es particular:

- Dos propulsores contrarrotantes.
- Timones.
- Elevador.
- Dos elevones.

Los elevones se incorporan al modelo dinámico, pero no a los modelos utilizados para diseñar los controladores, porque todavía no estaban implementados en el vehículo.

**Respecto a los parámetros:** no realizan una identificación completa. Estiman los coeficientes de amortiguamiento lineal excitando individualmente los grados de libertad y comparando las respuestas con datos de ensayos físicos de LoLo. Para los demás parámetros utilizan valores supuestos y simplificaciones.

**Linealización**

Desarrollan dos representaciones lineales:

**A. Vessel Parallel (VP): modelo LTI**

Utilizan un sistema de coordenadas paralelo al vehículo y realizan simplificaciones:

- Ángulos de roll y pitch pequeños.
- Velocidad de operación baja.
- Velocidad angular de yaw aproximadamente nula.
- Flotabilidad neutra.
- Centro de gravedad y centro de flotabilidad alineados en determinadas coordenadas.

Obtienen un modelo lineal invariante en el tiempo.

**B. Linealización jacobiana: modelo LTV**

Calculan las matrices $A(t)$ y $B(t)$ mediante el jacobiano de las ecuaciones no lineales, evaluándolas en el estado y entrada actuales.

Esto permite obtener un modelo lineal variante en el tiempo y considerar diferentes niveles de complejidad en la representación.&#x20;

Aunque no implementan propiamente un esquema de gain scheduling.

**Diseño de controladores**

Implementan y comparan dos estrategias:

- **LQR:** realimentación de estados con una formulación aumentada para seguimiento de referencias y eliminación del error estacionario.
- **MPC:** incorpora acción integral tanto sobre los estados como sobre las entradas, además de restricciones explícitas sobre los actuadores.

Antes del diseño estudian estabilidad, controlabilidad y observabilidad de los modelos.

**Simulaciones y resultados**

Este es probablemente el aporte más útil para tu aplicación.

Realizan simulaciones de seguimiento de waypoints en coordenadas NED.

Comparan las trayectorias obtenidas mediante LQR y MPC para alcanzar un waypoint situado en (100,100) m.

Algunas conclusiones interesantes:

- El LQR consigue un seguimiento satisfactorio.
- El MPC presenta un desempeño inferior en el escenario estudiado.
- La transformación de referencias entre coordenadas NED y BODY introduce dificultades para el MPC que en LQR no.
- La subactuación del vehículo limita las posibilidades de seguimiento.
- Evalúan el costo computacional del MPC: aproximadamente 11,5 ms por horizonte, con un período de muestreo de 200 ms

**¿Qué rescataría para tu proyecto?**

| Elemento                                     | Relevancia                                          |
| -------------------------------------------- | --------------------------------------------------- |
| Linealización VP                             | Media.                                              |
| Linealización jacobiana LTV                  | Alta.                                               |
| Análisis de controlabilidad y observabilidad | Alta.                                               |
| LQR con dinámica de error y acción integral  | Muy alta.                                           |
| Seguimiento de waypoints                     | Muy alta.                                           |
| Transformación de referencias NED-BODY       | Muy alta.                                           |

## [Prestero](./verification-of-a-six-degree-of-freedom-simulation-model-for-4n98272on0.pdf) (2001) – Verification of a Six-Degree of Freedom Simulation Model for the REMUS Autonomous Underwater Vehicle

**Vehículo:** REMUS AUV.

**Modelo y técnicas utilizadas**
- Desarrollo de un modelo dinámico no lineal de 6 grados de libertad basado en ecuaciones Newton-Euler.
- Modelado de masa añadida, fuerzas hidrostáticas, drag, sustentación y fuerzas de los actuadores.
- Estimación de coeficientes hidrodinámicos mediante formulaciones semiempíricas de bibliografía especializada (Hoerner, Nahon, Bottaccini, entre otros).
- Utilización de integración por franjas (*strip integration*) para estimar determinados efectos hidrodinámicos, como el drag de flujo cruzado.
- Ensayos experimentales en tanque de remolque (*tow tank*) para medir drag axial y lateral, y empuje de la hélice mediante ensayos de *bollard pull*.
- Integración numérica de las ecuaciones no lineales para simular el movimiento del vehículo.

**Validación**
- Comparación de las respuestas simuladas con datos experimentales obtenidos durante pruebas en el mar.
- Reproducción de las condiciones iniciales y entradas de las superficies de control de los experimentos.
- Ajuste de determinados coeficientes a partir de las discrepancias entre simulación y mediciones reales.

**Qué rescatar para el proyecto**
- Derivación física de las ecuaciones dinámicas de 6 GDL.
- Métodos semiempíricos para estimar coeficientes hidrodinámicos.
- Caracterización experimental de drag y propulsión.
- Modelado de los actuadores.
- Metodología de validación mediante comparación de respuestas transitorias reales y simuladas.


## [Harris](./harris-et-al-2023-stable-nullspace-adaptive-parameter-identification-of-6-degree-of-freedom-plant-and-actuator-models.pdf) et al. (2023) – Stable Nullspace Adaptive Parameter Identification of 6 Degree-of-Freedom Plant and Actuator Models for Underactuated Vehicles

**Vehículo:** Iver3 AUV.

**Modelo y técnicas utilizadas**

- Modelo dinámico no lineal de 6 GDL basado en ecuaciones Newton-Euler.
- Parametrización de la planta y los actuadores mediante una representación lineal respecto de los parámetros desconocidos.
- Identificación simultánea de parámetros de planta (masa, masa añadida, drag, flotabilidad) y actuadores (superficies de control y hélice).
- Desarrollo de un algoritmo de identificación adaptativa (*Adaptive Identifier*, AID).
- El algoritmo utiliza las mediciones de actitud, velocidades lineales y angulares en el marco del cuerpo, y entradas de control.
- No requiere mediciones directas de aceleraciones.
- Utiliza leyes de adaptación de estados y parámetros basadas en el error entre las velocidades medidas y las estimadas.
- Análisis de estabilidad mediante teoría de Lyapunov.
- Descomposición del espacio de parámetros en subespacios ortogonales (*nullspace decomposition*) para analizar la identificabilidad.
- Demostración de convergencia hacia el conjunto de parámetros equivalentes bajo condiciones de excitación persistente (PE).

Para el Iver3 utilizan una parametrización de 22 parámetros: 16 de planta y 6 de actuadores.

**Validación**

- Identificación utilizando datos experimentales de una inmersión.
- Validación cruzada utilizando datos de otras dos inmersiones independientes.
- Comparación de las velocidades lineales y angulares simuladas con las mediciones reales.
- Evaluación mediante errores de predicción (MAE).
- Demostración experimental de que los parámetros identificados permiten reproducir el comportamiento del vehículo en condiciones distintas de las utilizadas durante la identificación.

**Qué rescatar para el proyecto**

- Parámetros identificados experimentalmente para el Iver3.
- Estructura de parametrización del modelo dinámico y de actuadores.
- Algoritmo de identificación adaptativa AID.
- Tratamiento matemático de la no identificabilidad de los parámetros.
- Condición de excitación persistente y diseño de maniobras de identificación.
- Metodología de validación cruzada.

## [Fryxell et al.](./Control_Marius.pdf) — Navigation, Guidance and Control of AUVs: An Application to the MARIUS Vehicle

**Qué hacen**
Desarrollan una arquitectura completa de navegación, guiado y control para el AUV MARIUS, orientada al seguimiento de trayectorias.

**Técnicas utilizadas**
- **Modelo dinámico:** modelo no lineal de 6 GDL, basado en caracterización hidrodinámica experimental previa.
- **Navegación:** filtros complementarios multir tasa para estimar posición, actitud y velocidades a partir de sensores inerciales, acústicos y magnéticos.
- **Guiado:** generación de referencias de movimiento mediante leyes de guiado y funciones de tarea con acción integral.
- **Control:** controladores lineales $H_\infty$.
- **Linealización:** alrededor de distintas trayectorias de equilibrio (*trimming trajectories*).
- **Gain scheduling:** selección/interpolación de controladores según las condiciones de operación.

**Qué rescatar para mi proyecto**
- Arquitectura integrada de navegación, guiado y control.
- Estimación de estados para cerrar el lazo de control.
- Linealización del modelo no lineal alrededor de distintas condiciones de navegación.
- Diseño de controladores $H_\infty$ y uso de *gain scheduling*.
- Seguimiento de trayectorias como objetivo de control.

**Aplicabilidad y limitaciones**
La metodología de control es transferible a un AUV tipo torpedo. Sin embargo, los parámetros hidrodinámicos, las matrices del modelo y las ganancias diseñadas corresponden a MARIUS y no deben trasladarse directamente.

## otras cosas
En algunos papers vimos que los parámetros hidrodinámicos como los de masa añadida y los de drag se calculan mediante strip theory directamente a partir de la geometría del casco y tal vez las propiedades del fluido y chau. Algunas herramientas que se pueden utilizar son las siguientes.[captayne](https://github.com/cybergalactic/MSS-Capytaine?utm_source=chatgpt.com) y [HyDaMaCa](https://github.com/mseidl92/HyDaMaCa?utm_source=chatgpt.com). El segundo es CFD propiamente dicho mientras que el primero utiliza el BEM (boundary element method)

Igual no nos vamos a enfocar en nada de eso. Vamos a elgir un modelo con parámetros y vamos a utilizar ese y chau.

### Referencia del paper de HRC-AUV para despues
Es el siguiente [link](https://www.tandfonline.com/doi/epdf/10.1080/13873954.2012.717226?needAccess=true)

## Prestero

Lo siguiente es el resumen del modelo que propondría el Prestero.

### **Ecuación matricial compacta**

$$
\boxed{ M\dot{\nu}+C(\nu)\nu+D(\nu)\nu+g(\eta) = uL\nu+\tau_{\mathrm{act}} }
$$

con:

$$
\nu= \begin{bmatrix}u&v&w&p&q&r\end{bmatrix}^{T}
$$

### **1. Matriz de masa $M$**

$$
\boxed{M=M_{RB}+M_A}
$$

**Masa del cuerpo rígido:**

$$
M_{RB}= \begin{bmatrix} m&0&0&0&mz_g&0\\ 0&m&0&-mz_g&0&mx_g\\ 0&0&m&0&-mx_g&0\\ 0&-mz_g&0&I_{xx}+mz_g^2&0&-mx_gz_g\\ mz_g&0&-mx_g&0&I_{yy}+m(x_g^2+z_g^2)&0\\ 0&mx_g&0&-mx_gz_g&0&I_{zz}+mx_g^2 \end{bmatrix}
$$

**Masa añadida:**

$$
M_A= \begin{bmatrix} a_{11}&0&0&0&0&0\\ 0&a_{22}&0&0&0&a_{26}\\ 0&0&a_{22}&0&-a_{26}&0\\ 0&0&0&a_{44}&0&0\\ 0&0&-a_{26}&0&a_{55}&0\\ 0&a_{26}&0&0&0&a_{55} \end{bmatrix}
$$

Se utilizaron las aproximaciones:

$$
a_{22}=a_{33},\qquad a_{55}=a_{66},\qquad a_{26}=-a_{35}.
$$

### **2. Matriz de Coriolis $C(\nu)$**

$$
\boxed{C(\nu)=C_{RB}(\nu)+C_A(\nu)}
$$

**Coriolis del cuerpo rígido:**

$$
C_{RB}= \begin{bmatrix} 0&-S(P_{RB})\\ -S(P_{RB})&-S(H_{RB}) \end{bmatrix}
$$

donde:

$$
P_{RB}= \begin{bmatrix} m(u+z_gq)\\ m(v-z_gp+x_gr)\\ m(w-x_gq) \end{bmatrix}
$$

$$
H_{RB}= \begin{bmatrix} (I_{xx}+mz_g^2)p-mz_gv-mx_gz_gr\\ (I_{yy}+m(x_g^2+z_g^2))q+m(z_gu-x_gw)\\ (I_{zz}+mx_g^2)r+mx_gv-mx_gz_gp \end{bmatrix}
$$

**Coriolis de masa añadida:**

$$
C_A= \begin{bmatrix} 0&-S(P_A)\\ -S(P_A)&-S(H_A) \end{bmatrix}
$$

con:

$$
P_A= \begin{bmatrix} a_{11}u\\ a_{22}v+a_{26}r\\ a_{22}w-a_{26}q \end{bmatrix}, \qquad H_A= \begin{bmatrix} a_{44}p\\ -a_{26}w+a_{55}q\\ a_{26}v+a_{55}r \end{bmatrix}.
$$

La matriz antisimétrica se define como:

$$
S(x)= \begin{bmatrix} 0&-x_3&x_2\\ x_3&0&-x_1\\ -x_2&x_1&0 \end{bmatrix}.
$$

### **3. Matriz de drag $D(\nu)$**

$$
\boxed{ D(\nu)= \begin{bmatrix} -X_{u|u|}|u|&0&0&0&0&0\\ 0&-Y_{v|v|}|v|&0&0&0&-Y_{r|r|}|r|\\ 0&0&-Z_{w|w|}|w|&0&-Z_{q|q|}|q|&0\\ 0&0&0&-K_{p|p|}|p|&0&0\\ 0&0&-M_{w|w|}|w|&0&-M_{q|q|}|q|&0\\ 0&-N_{v|v|}|v|&0&0&0&-N_{r|r|}|r| \end{bmatrix} }
$$

Representa exclusivamente el drag cuadrático.

### **4. Matriz de lift $L$**

$$
\boxed{ \tau_{L,\mathrm{ext}}=uL\nu }
$$

$$
\boxed{ L= \begin{bmatrix} 0&0&0&0&0&0\\ 0&Y_{uv,l}+Y_{uv,f}&0&0&0&Y_{ur,f}\\ 0&0&Z_{uw,l}+Z_{uw,f}&0&Z_{uq,f}&0\\ 0&0&0&0&0&0\\ 0&0&M_{uw,l}+M_{uw,f}&0&M_{uq,f}&0\\ 0&N_{uv,l}+N_{uv,f}&0&0&0&N_{ur,f} \end{bmatrix} }
$$

Representa las contribuciones de lift del cuerpo y de los fins. Las contribuciones con subíndice $a$ quedan incorporadas en $C_A$.

### **5. Vector hidrostático $g(\eta)$**

$$
\boxed{g(\eta)=-\tau_{HS}(\eta)}
$$

Representa las fuerzas y momentos de restauración hidrostática.

### **6. Vector de actuadores**

$$
\boxed{ \tau_{\mathrm{act}}= \begin{bmatrix} X_{\mathrm{prop}}\\ Y_{uu\delta_r}u^2\delta_r\\ Z_{uu\delta_s}u^2\delta_s\\ K_{\mathrm{prop}}\\ M_{uu\delta_s}u^2\delta_s\\ N_{uu\delta_r}u^2\delta_r \end{bmatrix} }
$$

Representa las acciones de los propulsores y de las superficies de control.
