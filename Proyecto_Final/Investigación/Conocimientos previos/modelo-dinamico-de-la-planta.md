# Modelo dinámico de la planta (AUV)

> Marcas de revisión: **Corrección** = algo estaba mal. **Agregado** = contenido que faltaba. Borrar las marcas cuando ya estén asimiladas.

---

## 0. Notación (Agregado)

**Marcos de referencia**

- $\{n\}$, **marco inercial local NED**: origen en un punto fijo de la superficie terrestre. $x_n$ apunta al Norte (North), $y_n$ al Este (East), $z_n$ hacia abajo (Down). Se lo considera inercial (se desprecia la rotación de la Tierra). **No** es el marco del cuerpo.
- $\{b\}$, **marco del cuerpo**: fijo al vehículo, con origen en un punto elegido (por ejemplo el centro de flotación). $x_b$ hacia proa, $y_b$ a estribor, $z_b$ hacia abajo.
- Superíndice: $a^n$ y $a^b$ son el mismo vector $a$ expresado con componentes de $\{n\}$ o de $\{b\}$. Sin superíndice se entiende $\{b\}$.
- $R(\Theta)$: matriz de rotación de $\{b\}$ a $\{n\}$, es decir $a^n=R\,a^b$ y $a^b=R^Ta^n$.

**Variables**

- $\eta_1=[x\ y\ z]^T$: posición del origen de $\{b\}$ en $\{n\}$. $\Theta=[\phi\ \theta\ \psi]^T$: ángulos de Euler (roll, pitch, yaw). $\eta=[\eta_1;\Theta]$.
- $\nu=[\nu_1;\nu_2]$: velocidad del cuerpo respecto de $\{n\}$, con componentes en $\{b\}$. $\nu_1=[u\ v\ w]^T$ es la lineal (surge, sway, heave); $\nu_2=[p\ q\ r]^T$ es la angular (velocidad de roll, de cabeceo y de guiñada, alrededor de $x_b$, $y_b$, $z_b$).
- $\tau=[X\ Y\ Z\ K\ M\ N]^T$: fuerzas ($X,Y,Z$) y momentos ($K,M,N$ alrededor de $x_b,y_b,z_b$) en $\{b\}$. El $M$ de momento de cabeceo no es la matriz de masa $M$; se distinguen por contexto.
- $U=\sqrt{u^2+v^2+w^2}$: rapidez del vehículo.
- $m$: masa del vehículo. $V_d$: volumen desplazado. $L$: largo del casco. $\rho$: densidad del agua. $g$: aceleración de la gravedad (no es el vector $g(\eta)$ de la sección 14).
- $S(a)$: matriz antisimétrica $3\times3$ tal que $S(a)b=a\times b$. $I_3$: identidad $3\times3$. $c_\alpha,s_\alpha,t_\alpha$ son $\cos\alpha,\sin\alpha,\tan\alpha$.
- Aviso: $\phi$ es el **potencial de velocidades** del fluido en las secciones 3 a 12 y el **ángulo de roll** en la sección 14.

**Geometría para el fluido**

- $S$: superficie del casco. $\Omega$: fluido exterior al casco. $r$: posición de un punto del casco respecto del origen de $\{b\}$. $n$: normal unitaria exterior del casco (apunta hacia el fluido; no confundir con el marco $\{n\}$).
- Los $n_i$ geométricos que aparecen más adelante se definen así:

$$n_{1:3}=n,\qquad n_{4:6}=r\times n$$

---

## 1. Por qué el cuerpo rígido no alcanza

Por un lado tenemos el modelo dinámico del cuerpo rígido (ver [modelo-dinamico-del-cuerpo-rigido.md](./modelo-dinamico-del-cuerpo-rigido.md)):

$$M_{RB}\dot\nu+C_{RB}(\nu)\nu=\tau_{ext},\qquad M_{RB}=\begin{bmatrix}mI_3&-mS(r_g)\\ mS(r_g)&I_b\end{bmatrix}$$

con $\tau_{ext}$ las fuerzas y momentos externos sobre el cuerpo (incluyen al fluido), $r_g$ la posición del centro de gravedad respecto al origen de $\{b\}$ e $I_b$ la inercia respecto a ese origen.

Este modelo no es insuficiente por estar mal, de hecho está bien. El problema es que requiere que las fuerzas y momentos de interacción con el fluido entren dentro de $\tau_{ext}$. Para obtenerlos habría que integrar sobre la superficie del casco la presión y el esfuerzo viscoso en cada punto, es decir, resolver el campo de presiones y velocidades del fluido alrededor del cuerpo (la presión tiene parte estática y parte dinámica; la dinámica depende del campo de velocidades).

Existe una forma más conveniente, basada en consideraciones energéticas. El cambio de enfoque es análogo al de obtener un modelo masa-resorte-amortiguador con Newton (balance de fuerzas) contra obtenerlo con Lagrange (energías). Ese camino alternativo es la adaptación del enfoque lagrangiano a la interacción fluido-cuerpo, y las ecuaciones resultantes se llaman **ecuaciones de Kirchhoff** (Kirchhoff, 1869).

> **Corrección:** el original decía "ecuaciones de Euler" para el enfoque newtoniano del masa-resorte-amortiguador. Es Newton (Euler es para la rotación del rígido). También: se escribe Kirchhoff, no Kirchoff.

Según este enfoque se considera un sistema único CUERPO + FLUIDO y su energía cinética conjunta, bajo ciertas hipótesis sobre el fluido (sección 3). Esa energía se introduce en las ecuaciones de movimiento y las fuerzas y momentos de interacción quedan incluidos naturalmente mediante dos matrices:

- **Matriz de masa añadida** $M_A$.
- **Matriz de Coriolis añadida** $C_A(\nu)$.

---

## 2. Los dos objetos nuevos

**Masa añadida.** Un cuerpo rígido inmerso en un fluido no puede ocupar a la vez el lugar del fluido, entonces lo desplaza. Cuando el cuerpo acelera, el fluido desplazado también debe acelerar, y eso genera fuerzas y momentos inerciales del fluido sobre el cuerpo. El efecto neto es como si el cuerpo tuviera una masa adicional. $M_A$ es una matriz $6\times6$ que da las fuerzas y momentos de reacción a partir del vector de aceleración del cuerpo:

$$\tau_{A,\text{inercial}}=-M_A\dot\nu$$

> **Agregado (precisión conceptual):** la masa añadida no es una porción fija de fluido pegada al cuerpo. Es un parámetro que resume la energía cinética de *todo* el flujo inducido: $T_f=\tfrac12\nu^TM_A\nu$ (sección 12). Depende de la dirección del movimiento. El signo menos indica que el fluido se opone a la aceleración.

**Coriolis añadida.** $C_A(\nu)$ recoge los términos de Coriolis, centrípetos y de acoplamiento que corresponden a ese agregado de inercia. Incluye el **momento de Munk** (sección 5), que existe incluso sin rotación del cuerpo.

---

## 3. Hipótesis y limitaciones

El enfoque es conveniente pero parte de hipótesis restrictivas. El fluido se considera:

- No viscoso.
- Incompresible.
- Irrotacional.
- Infinito (sin fronteras ni superficie libre).
- En reposo en el infinito (sin corriente).

Con incompresible + irrotacional el flujo es **potencial** (el que vimos en mecánica de los fluidos): $v_f=\nabla\phi$ con $\nabla\cdot v_f=0$.

> **Corrección:** flujo potencial = irrotacional + incompresible. La falta de viscosidad es una hipótesis adicional que, junto con irrotacionalidad inicial, la preserva (Kelvin).

Consecuencias que hay que tener claras:

- **No hay arrastre.** Un cuerpo que se mueve a velocidad constante y sin rotar en flujo potencial ilimitado no recibe fuerza neta (paradoja de d'Alembert): la presión es simétrica proa-popa y se cancela. No contradice la masa añadida: la fuerza inercial $-M_A\dot\nu$ existe solo si hay aceleración, y los términos de $C_A$ dan fuerza solo si hay rotación (en traslación pura dan únicamente un momento, el de Munk). Todo el arrastre real es viscoso: fricción de superficie y presión por separación de flujo (la separación impide que la presión se recupere en la popa).
- **No hay sustentación.** La sustentación es una diferencia de presión entre las caras del perfil, pero esa diferencia requiere circulación $\Gamma$ alrededor del perfil ($L=\rho U\Gamma$ por unidad de envergadura). El potencial puro no determina $\Gamma$: la fija la condición de Kutta (el flujo sale suavemente por el borde de fuga), que es consecuencia de la viscosidad. Dado $\Gamma$, la sustentación se calcula con teoría no viscosa (perfil delgado, línea sustentadora). Cascos a ángulo de ataque y aletas generan sustentación así, y el potencial sin circulación no la captura.
- **No hay corriente, ni estela, ni vorticidad, ni VIV.**
- **No hay efecto de superficie libre ni de paredes** (ver sección 5).

Todo eso se agrega aparte, dentro de $D(\nu)$, de las fuerzas de actuadores/sustentación y de $\tau_{pert}$ del modelo completo.

Para las fuerzas viscosas hay tres caminos:

1. Ensayos (túnel de remolque, PMM, caída libre) o identificación de parámetros.
2. CFD.
3. Matrices de coeficientes de arrastre válidas en rangos de velocidad (dependen de Reynolds), eventualmente con gain scheduling: la matriz de coeficientes como función de la velocidad, evaluada en las velocidades de operación.

---

## 4. Cómo se obtiene $M_A$: problema de Neumann

Hay que resolver la ecuación de Laplace que surge de combinar continuidad con potencialidad, con la condición de frontera de no penetrabilidad:

$$\nabla^2\phi=0\ \text{ en }\Omega,\qquad \frac{\partial\phi}{\partial n}=(\nu_1+\nu_2\times r)\cdot n=\sum_{i=1}^6\nu_i\,n_i\ \text{ en }S,\qquad |\nabla\phi|\to0\ \text{ en }\infty$$

Laplace + condición sobre la derivada normal = **problema de Neumann** (exterior).

> **Corrección:** el original decía "Newman" y "derivada de la función de flujo igual a una función f". Es Neumann, la función es el potencial de velocidades, y $f=v_{cuerpo}\cdot n$ (velocidad del punto del casco proyectada sobre la normal).

Para geometrías simples se resuelve analíticamente. Para geometrías complejas, numéricamente o combinando geometrías simples.

**Existencia.** El problema de Neumann exterior tiene solución si el flujo neto a través de la frontera es nulo. Se cumple porque el casco es cerrado y rígido:

$$\oint_S\frac{\partial\phi}{\partial n}\,dS=\nu_1\cdot\oint_S n\,dS+\nu_2\cdot\oint_S r\times n\,dS=0$$

(ambas integrales son cero por el teorema de la divergencia). No alcanza con tener la derivada normal definida en el casco: eso no define el potencial en el resto del campo, de ahí que haga falta el teorema de existencia.

**Unicidad (salvo constante aditiva, irrelevante porque solo importa $\nabla\phi$).** Se suponen dos soluciones $\phi_1,\phi_2$ y se toma $\psi=\phi_1-\phi_2$. Entonces $\nabla\cdot(\psi\nabla\psi)=|\nabla\psi|^2+\psi\nabla^2\psi=|\nabla\psi|^2$ (el laplaciano es nulo). Integrando en $\Omega$ y usando Gauss:

$$\int_\Omega|\nabla\psi|^2dV=\oint_S\psi\frac{\partial\psi}{\partial n}dS+\oint_{S_\infty}\psi\frac{\partial\psi}{\partial n}dS=0$$

El término en $S$ es nulo porque $\partial\psi/\partial n=0$ (ambas cumplen la misma condición de no penetrabilidad). El término en $S_\infty$ (superficie esférica de radio tendiendo a infinito) es nulo por el decaimiento. Entonces $\nabla\psi=0$ y $\psi$ es constante.

> **Corrección:** el original concluía "la diferencia es nula". Es constante. Además faltaba el término en el infinito. La frase "flujo neto a través de la superficie del AUV" corresponde a $\partial\psi/\partial n=0$ en $S$.

---

## 5. Discusión sobre la masa añadida

- Masa efectiva (inercia que ve el movimiento) = masa del cuerpo + masa añadida: $m_{ef}=m+m_a$.

> **Corrección:** el original decía "masa real del fluido + masa añadida". Es masa del *cuerpo*.

- Esfera: $m_a=\tfrac23\pi r^3\rho_f$, la mitad de la masa de fluido desplazada (coeficiente $k=1/2$).
- Para geometrías generales no basta un número: hay que calcular el tensor completo $M_A$.
- Unidades de los bloques de $M_A$ (igual que $M_{RB}$): $[m]$ (fuerza/aceleración lineal), $[mL]$ (acoplamientos fuerza-aceleración angular y momento-aceleración lineal), $[mL^2]$ (momento/aceleración angular).
- $M_A=M_A^T$, y es definida positiva para un cuerpo 3D en fluido ilimitado.
- En coordenadas del cuerpo $M_A$ es constante (fluido ilimitado, lejos de fronteras).
- $M_A$ depende del origen elegido para $\{b\}$ (los términos cruzados cambian con el origen).

**Momento de Munk.** Aparece cuando la masa añadida axial y la transversal son distintas ($m_{11}\ne m_{22}$). Importa sobre todo en cuerpos esbeltos. En el plano horizontal las ecuaciones de Kirchhoff para el fluido (con $m_{22},m_{11}$ ya incluidos en $M$) tienen:

$$m_{11}\dot u-m_{22}vr=X,\qquad m_{22}\dot v+m_{11}ur=Y,\qquad m_{66}\dot r+(m_{22}-m_{11})uv=N$$

Sea $\alpha$ el ángulo entre el vector velocidad y el eje $x_b$: $u=U\cos\alpha$, $v=U\sin\alpha$, entonces $uv=U^2\sin\alpha\cos\alpha$ (igualdad exacta). Momento que el fluido ejerce sobre el cuerpo: guiñada $N=-(m_{22}-m_{11})uv$; cabeceo $M=(m_{33}-m_{11})uw$ (acá $M$ es el momento de cabeceo, no la matriz de masa), con $\alpha=\mathrm{atan2}(w,u)$. Solo aparece cuando hay a la vez componente axial y transversal de la velocidad: es cero con $\alpha=0$ (avance recto, equilibrio inestable) y con $\alpha=90^\circ$ (de costado, equilibrio estable) y es máximo a $45^\circ$. Es **desestabilizante** cerca de $\alpha=0$: tiende a girar el cuerpo hasta ponerlo transversal al flujo. Para un torpedo ($m_{22}\gg m_{11}$) el casco desnudo es inestable en guiñada y cabeceo, y la estabilidad de rumbo la aportan las aletas y la hidrodinámica viscosa. Está dentro de $C_A(\nu)\nu$: sale solo del modelo, no se agrega a mano.

**Dependencia de la densidad.** Lo que importa es $\rho_{fluido}/\rho_{cuerpo}$. En agua con un AUV de flotabilidad neutra ($\rho_{cuerpo}\approx\rho_{fluido}$), la masa añadida es del mismo orden que la masa del vehículo. En aire ($\rho_f/\rho_c\sim10^{-3}$) se desprecia (excepto en dirigibles).

> **Corrección:** el original decía que para un barco la masa añadida llega al 40% del peso. Ese dato no lo pude verificar y depende fuertemente del grado de libertad (axial vs transversal). Para un AUV esbelto: axial ~ 5–10% de la masa desplazada, transversal ~ 85–95% (valores de la sección 7).

**Dependencia de fronteras.** La masa añadida depende de la distancia a una frontera (superficie libre, pared, fondo, otro cuerpo). Por eso es muy distinto un objeto flotando en superficie de uno totalmente sumergido. Cerca de la superficie libre además depende de la frecuencia de movimiento (radiación de olas, memoria). Esto importa para **ensayos en pileta o tanque**, para operación cerca del fondo o en docking: el $M_A$ de aguas profundas ya no vale. Qué se usa entonces: BEM con superficie libre y/o fondo (Capytaine, Nemoh, WAMIT admiten superficie libre y profundidad finita y dan $A(\omega)$ y amortiguamiento de radiación $B(\omega)$); método de imágenes (cuerpo espejo) para pared plana; CFD; o ensayo. Para control se suele mantener el $M_A$ profundo y tratar la desviación como incertidumbre en el ensayo de robustez, o programarlo según profundidad / altura sobre el fondo. Orden de magnitud (no verificado): el efecto de la superficie libre es pequeño a varios diámetros de profundidad (≳3–5 D). Chequearlo con el BEM.

---

## 6. Solución por separación de variables

En esta sección $r$ es la distancia radial, $\theta$ el ángulo polar esférico (medido desde $x_b$) y $\varphi$ el ángulo azimutal; no son la guiñada, el cabeceo ni el roll. $\phi$ es el potencial. Se expresa Laplace en coordenadas esféricas con el eje polar a lo largo del eje longitudinal del cuerpo y simetría axial (independiente del azimut):

$$\frac1{r^2}\frac{\partial}{\partial r}\!\left(r^2\frac{\partial\phi}{\partial r}\right)+\frac1{r^2\sin\theta}\frac{\partial}{\partial\theta}\!\left(\sin\theta\frac{\partial\phi}{\partial\theta}\right)=0$$

Se propone $\phi=R(r)H(\theta)$ y se iguala cada parte a la constante $n(n+1)$, $n$ entero:

- Radial: $r^2R''+2rR'-n(n+1)R=0\Rightarrow R=A_nr^n+B_nr^{-(n+1)}$.
- Angular: ecuación de Legendre, $H=P_n(\cos\theta)$, con $P_n$ el polinomio de Legendre de grado $n$.

Los $A_n$ se anulan por el decaimiento en el infinito. La solución general es la suma:

$$\phi(r,\theta)=\sum_{n=0}^{\infty}B_n\,r^{-(n+1)}P_n(\cos\theta)$$

Los $P_n$ son ortogonales en $[-1,1]$ respecto de $x=\cos\theta$: $\int_{-1}^1P_nP_m\,dx=\tfrac{2}{2n+1}\delta_{nm}$.

> **Corrección (importante):** el original decía que, sea cual sea la geometría con simetría azimutal, la solución *tiene que* tener esta forma. Tres precisiones:
> 1. **Solo vale para movimiento axisimétrico**, es decir surge (y roll, que es cero para sección circular). Para sway, heave, pitch y yaw el potencial *no* es axisimétrico: depende del azimut $\varphi$ como $\cos\varphi$, y las funciones angulares son los Legendre asociados: $\phi\propto\sum B_nr^{-(n+1)}P_n^1(\cos\theta)\cos\varphi$, con $P_n^1$ la función de Legendre asociada de orden 1.
> 2. La serie converge fuera de la esfera que circunscribe al cuerpo. Aplicar la condición de frontera *sobre el casco* (que está dentro de esa esfera para cuerpos no esféricos) supone que la serie sigue valiendo ahí (hipótesis de Rayleigh). En cuerpos esbeltos converge mal.
> 3. Para la esfera es exacto con un solo término. Para un torpedo esbelto conviene coordenadas esferoidales o un método numérico.

La condición de frontera determina los $B_n$: se iguala $\partial\phi/\partial n$ (con $\phi$ dada por la serie) a $\sum\nu_in_i$, con los $n_i$ definidos por la geometría del casco.

Verificación con la esfera, surge $U$: solo $n=1$, $\phi=B_1\cos\theta/r^2$, $\partial_r\phi|_{r=a}=-2B_1\cos\theta/a^3=U\cos\theta\Rightarrow B_1=-Ua^3/2$.

---

## 7. Cómo se determinan los coeficientes (métodos)

Hay que determinar los $B_n$ (o directamente $M_A$) de alguna manera. Hay métodos analíticos y numéricos.

**Analíticos**

- **Proyección (Galerkin):** multiplicar la condición de frontera por un polinomio de prueba e integrar sobre el casco. Convierte el problema en un sistema lineal que se trunca.
- **Coordenadas esferoidales prolatas:** separables exactamente para elipsoides. Es la fuente de las fórmulas cerradas de abajo.

**Numéricos**

- **BEM (método de elementos de contorno):** el casco se divide en paneles y se coloca una solución elemental (fuente/sumidero) en cada uno; se resuelve el sistema lineal para las intensidades. Se justifica porque:
  - Laplace es lineal y cada fuente satisface Laplace, entonces cualquier combinación también.
  - La representación integral de Green dice que una función armónica en el exterior de un cuerpo se representa con una distribución de fuentes (y dipolos) sobre la frontera. Para el problema de Neumann exterior alcanza con fuentes.
  - Analogía: fuentes/sumideros equivalen a cargas eléctricas; cualquier campo se arma combinando cargas.
  - Herramientas: Capytaine (Python; verificar que se use la configuración sin superficie libre / fluido ilimitado), Nemoh, WAMIT (comercial). Lo mencionado como "pySBT" no pude verificar que exista con ese nombre.
  - **Estudio de convergencia de malla:** se calcula $M_A$ con una malla, luego con una más fina (más paneles) y luego con otra aún más fina. Si $M_A$ casi no cambia entre mallas (por ejemplo menos de 1–2%), la malla alcanza. Si cambia, el resultado depende de la malla y no es confiable.
- **SBT (slender body theory) / strip theory:** se corta el casco transversalmente en rebanadas 2D y se integra a lo largo del eje. Para cuerpo esbelto se distribuyen fuentes (movimiento axial) o dipolos (movimiento transversal) sobre el eje.

> **Corrección:** el original decía que BEM es "básicamente FEM pero para una superficie". Se parece solo en que discretiza, pero BEM se basa en una ecuación integral de frontera con función de Green: no hay malla de volumen y la matriz resultante es densa.

**Fórmulas prácticas para el proyecto (Agregado)**

*Esferoide prolato* (semieje largo $a$, corto $b$; $e$ es la excentricidad, $\alpha_0,\beta_0$ son funciones auxiliares de $e$, y $k_1,k_2,k'$ son los coeficientes de masa añadida axial, transversal y de rotación, relativos al fluido desplazado; es la aproximación habitual para torpedos):

$$e=\sqrt{1-b^2/a^2},\quad \alpha_0=\frac{2(1-e^2)}{e^3}\!\left(\tfrac12\ln\tfrac{1+e}{1-e}-e\right),\quad \beta_0=\frac1{e^2}-\frac{1-e^2}{2e^3}\ln\frac{1+e}{1-e}$$

$$k_1=\frac{\alpha_0}{2-\alpha_0},\quad k_2=\frac{\beta_0}{2-\beta_0},\quad k'=\frac{e^4(\beta_0-\alpha_0)}{(2-e^2)\left[2e^2-(2-e^2)(\beta_0-\alpha_0)\right]}$$

$$m_{11}=k_1m_f,\quad m_{22}=m_{33}=k_2m_f,\quad m_{55}=m_{66}=k'I_f,\quad m_f=\tfrac43\pi\rho ab^2,\quad I_f=\tfrac{m_f}{5}(a^2+b^2)$$

$m_{44}=0$ (roll, sección circular). Origen en el centro del esferoide. Chequeos de límite: esfera $k_1=k_2=0.5,\ k'=0$; esbelto $k_1\to0,\ k_2\to1,\ k'\to1$. Ejemplo $L/D=4$: $k_1\approx0.08,\ k_2\approx0.86,\ k'\approx0.61$.

*Strip theory* (cuerpo de revolución de radio local $a(x)$). Masa añadida 2D transversal por unidad de largo: $m_a(x)=\rho\pi a(x)^2$. Se obtiene de la energía cinética de cada rebanada, $\tfrac12m_a(v+xr)^2$ en el plano horizontal y $\tfrac12m_a(w-xq)^2$ en el vertical:

$$m_{22}=m_{33}=\int_Lm_a\,dx,\quad m_{26}=\int_Lx\,m_a\,dx,\quad m_{35}=-\int_Lx\,m_a\,dx,\quad m_{55}=m_{66}=\int_Lx^2m_a\,dx$$

No da $m_{11}$ (hay que usar la fórmula del esferoide o un método 3D). Es razonable para $L/D$ grande, peor en los extremos.

*Vehículos de base plana / open-frame (Agregado).* Open-frame = bastidor abierto de tubos o perfiles, sin carenado continuo, con propulsores, cajas estancas y sensores montados sobre la estructura (típico de ROV y de AUV de hovering). No son axisimétricos, así que la serie de la sección 6 no aplica. $M_A$ puede tener acoplamientos y se calcula con BEM o ensayo. Además el flujo se separa: el arrastre de presión domina y el potencial no sirve para $D$. Para este tipo de vehículo $M_A$ es una estimación razonable y $D$ debe venir de CFD o ensayo.

---

## 8. Linealidad: potenciales componentes

La condición de frontera es lineal en $\nu_i$ y Laplace también. Entonces la solución es una combinación lineal de potenciales componentes $\phi_i$ que multiplican a las velocidades generalizadas:

$$\phi=\sum_{i=1}^6\nu_i\,\phi_i$$

Se reemplaza en Laplace: $\nabla^2\phi=\sum\nu_i\nabla^2\phi_i=0$. Como los $\nu_i$ son independientes (arbitrarios), cada $\nabla^2\phi_i=0$. Se toma la derivada normal: $\sum\nu_i\,\partial\phi_i/\partial n=\sum\nu_in_i$. Igualando coeficientes:

$$\nabla^2\phi_i=0,\qquad \frac{\partial\phi_i}{\partial n}=n_i\ \text{ en }S,\qquad i=1,\dots,6$$

Cada $\phi_i$ resuelve por separado un problema de Neumann (existencia y unicidad por la sección 4), y depende **solo de la geometría** (no de $\nu$).

---

## 9. Por qué trabajar en coordenadas del cuerpo

Si el problema se expresa en $\{b\}$, el casco está quieto en esas coordenadas, entonces los $\phi_i$ y las integrales que siguen no dependen de la orientación: **$M_A$ es constante**. Además la condición de frontera toma la misma forma que en el marco inercial, y también la solución y la combinación lineal de la sección 8.

---

## 10. Presión (Bernoulli no estacionaria) y definición de $m_{ij}$

La presión sobre el casco sale de Bernoulli no estacionaria, evaluada en un punto fijo del marco inercial ($h$ hacia arriba):

$$p-p_\infty=-\rho\left.\frac{\partial\phi}{\partial t}\right|_{I}-\tfrac12\rho|\nabla\phi|^2-\rho g\,h$$

Los $\phi_i$ están definidos en $\{b\}$ pero Bernoulli se evalúa en el marco inercial. Hay que pasar por la matriz de rotación $R$, y la derivada temporal en un punto inercial fijo queda:

$$\left.\frac{\partial\phi}{\partial t}\right|_I=\sum_j\dot\nu_j\phi_j-(\nu_1+\nu_2\times r)\cdot\nabla\phi$$

El primer término es combinación lineal de las **aceleraciones** (da la inercia, masa añadida). El segundo es el término aparte que genera la rotación del marco (da Coriolis).

Fuerza y momento sobre el casco: $\tau_i=-\oint_Sp\,n_i\,dS$, $i=1,\dots,6$ ($n_{1:3}$ para fuerzas, $n_{4:6}$ para momentos). Término por término:

- $p_\infty$: se anula (superficie cerrada).
- $-\rho g h$: **empuje** (presión estática), $\rho gV_d$ hacia arriba aplicado en el centro de flotación.
- Aceleraciones: $\tau_i=\rho\sum_j\dot\nu_j\oint_S\phi_jn_i\,dS=-\sum_jm_{ij}\dot\nu_j$, con

$$\boxed{m_{ij}=-\rho\oint_S\phi_j\,\frac{\partial\phi_i}{\partial n}\,dS=-\rho\oint_S\phi_j\,n_i\,dS}$$

Este es el coeficiente de masa añadida: pondera la acción de un movimiento acelerado en la dirección $j$ sobre el grado de libertad $i$. Depende solo de la geometría, y en $\{b\}$ es constante. Para momentos ($i=4,5,6$) es la misma expresión con $n_4,n_5,n_6$, y $j$ recorre $1,\dots,6$.

> **Corrección (signo):** el original omitía $-\rho$. Con la normal saliente del cuerpo, $m_{ij}$ así definido resulta positivo (esfera: $m_{11}=-\rho\oint\phi_1n_1dS=\tfrac23\pi\rho a^3$ con $\phi_1=-\tfrac a2\cos\theta$ en $r=a$).

- Términos cuadráticos ($\tfrac12\rho|\nabla\phi|^2$ y el segundo término de la derivada): integrados, dan las fuerzas y momentos de Coriolis/centrípetos y el momento de Munk, o sea $-C_A(\nu)\nu$.

> **Corrección (importante):** el original agrupaba los términos cuadráticos en la velocidad como "arrastre". En flujo potencial **no hay arrastre** (d'Alembert): esos términos dan fuerza neta nula en traslación estacionaria y sí dan momento (Munk) y acoplamientos de Coriolis. El arrastre cuadrático del modelo final es de origen **viscoso**, no sale de Bernoulli potencial.

---

## 11. Simetría de $M_A$

Sean $f_{ij}=\phi_i\nabla\phi_j$ y $f_{ji}=\phi_j\nabla\phi_i$. Entonces $\nabla\cdot f_{ij}-\nabla\cdot f_{ji}=\phi_i\nabla^2\phi_j-\phi_j\nabla^2\phi_i=0$. Integrando en $\Omega$ y usando Gauss (segunda identidad de Green):

$$\oint_S\left(\phi_i\frac{\partial\phi_j}{\partial n}-\phi_j\frac{\partial\phi_i}{\partial n}\right)dS=0\ \Rightarrow\ m_{ij}=m_{ji}$$

(el término en el infinito se anula: $\phi\sim r^{-2}$, $\nabla\phi\sim r^{-3}$ y la superficie crece como $r^2$).

Hasta acá todo sirvió para determinar $M_A$: constante en $\{b\}$, simétrica, que depende solo de la geometría.

---

## 12. Energía cinética del fluido

$$T_f=\tfrac12\rho\int_\Omega|\nabla\phi|^2dV$$

Como $\nabla\cdot(\phi\nabla\phi)=|\nabla\phi|^2+\phi\nabla^2\phi=|\nabla\phi|^2$, por Gauss ($S_\infty$ aporta cero):

$$T_f=-\tfrac12\rho\oint_S\phi\frac{\partial\phi}{\partial n}dS$$

(el signo menos viene de que la normal exterior del *fluido* en el casco es $-n$). Se expanden $\phi=\sum\nu_i\phi_i$ y $\partial\phi/\partial n=\sum\nu_jn_j$. Las sumatorias quedan afuera y adentro quedan los $m_{ij}$:

$$T_f=-\tfrac12\rho\sum_{i,j}\nu_i\nu_j\oint_S\phi_in_j\,dS=\tfrac12\sum_{i,j}m_{ij}\nu_i\nu_j=\tfrac12\nu^TM_A\nu$$

La energía del cuerpo es otra forma cuadrática en las mismas velocidades: $T_b=\tfrac12\nu^TM_{RB}\nu$. La energía total es una forma cuadrática con la suma de matrices:

$$T=\tfrac12\nu^TM\nu,\qquad M=M_{RB}+M_A$$

---

## 13. Ecuaciones de Kirchhoff

Escribimos $M$ en bloques $3\times3$, $M=\begin{bmatrix}M_{11}&M_{12}\\M_{21}&M_{22}\end{bmatrix}$. Definimos el impulso (momento) lineal $P$ y angular $\Pi$ del sistema cuerpo + fluido a partir de la energía:

$$P=\frac{\partial T}{\partial\nu_1}=M_{11}\nu_1+M_{12}\nu_2,\qquad \Pi=\frac{\partial T}{\partial\nu_2}=M_{21}\nu_1+M_{22}\nu_2$$

Como $T$ es forma cuadrática con matriz simétrica constante (en $\{b\}$), derivar es solo "quitar el vector traspuesto" y quedarse con $M\nu$. Eso se mantiene en coordenadas del cuerpo.

**Justificación de $P=\partial T/\partial\nu_1$** (el paso que en el original quedaba como "algo del teorema de Euler"): si el sistema parte del reposo y se aplica un impulso $dP$, el incremento de energía es $dT=\nu_1\cdot dP$ (velocidad por impulso). Con $T=\tfrac12\nu^TM\nu$ eso solo es consistente con $P=\partial T/\partial\nu_1$ (igual para $\Pi$). Esa es la identificación de Lamb.

> **Corrección:** del balance de potencia $\dot T=F\cdot\nu_1+\tau\cdot\nu_2$ **no** se pueden igualar los vectores: es una sola ecuación escalar. El teorema de Euler para funciones homogéneas ($\nu\cdot\partial T/\partial\nu=2T$) es cierto pero no es lo que cierra la deducción. Lo que cierra es el argumento de impulso de arriba más Newton en el marco inercial.

Newton para el impulso del sistema, en el marco inercial $\{n\}$ (el subíndice $I$ indica componentes en $\{n\}$) (el momento angular se toma respecto al origen móvil del cuerpo, de ahí el término $\nu_1\times P$):

$$\dot P_I=F_I,\qquad \dot\Pi_I+\nu_{1,I}\times P_I=\tau_I$$

Con $P_I=RP$ y el teorema del transporte, $\dot P_I=R(\dot P+\nu_2\times P)$. Las ecuaciones en $\{b\}$ son:

$$\dot P+\nu_2\times P=F,\qquad \dot\Pi+\nu_2\times\Pi+\nu_1\times P=\tau$$

Derivando ($M$ constante) y pasando a forma matricial:

$$\boxed{M\dot\nu+C(\nu)\nu=\tau_{ext}},\qquad C(\nu)=\begin{bmatrix}0&-S(M_{11}\nu_1+M_{12}\nu_2)\\-S(M_{11}\nu_1+M_{12}\nu_2)&-S(M_{21}\nu_1+M_{22}\nu_2)\end{bmatrix}$$

Esa fórmula vale para cualquier $M$ simétrica constante: con $M_{RB}$ da $C_{RB}$, con $M_A$ da $C_A$, y con $M$ da $C$ total. Por eso no hay que integrar el resto de las presiones: Kirchhoff mete cuerpo y fluido en una sola energía, las interacciones quedan "escondidas" pero todas dentro del modelo.

Propiedades (relevantes para control):

- $C(\nu)$ es antisimétrica, entonces $\nu^TC(\nu)\nu=0$: los términos de Coriolis no hacen trabajo. Se verifica con la energía: $\dot T=\nu^TM\dot\nu=\nu^T\tau_{ext}$.
- $C$ no es única (hay otras factorizaciones de $C(\nu)\nu$); la antisimétrica es la estándar.
- Es lo mismo que Lagrange en cuasi-coordenadas (Boltzmann-Hamel). Aplicar Lagrange directo en $\eta$ también sirve, con $M(\eta)=J^{-T}MJ^{-1}$, pero se complica. Por eso se usa Newton sobre el sistema agrandado.

Esto es el modelo **sin** viscosidad, corriente ni gravedad.

---

## 14. Modelo completo

**Cinemática.** Falta reemplazar $\nu_2$ por las variables que representan la orientación. Con ángulos de Euler:

$$\dot\eta=J(\eta)\nu=\begin{bmatrix}R(\Theta)&0\\0&T(\Theta)\end{bmatrix}\nu,\qquad T(\Theta)=\begin{bmatrix}1&s_\phi t_\theta&c_\phi t_\theta\\0&c_\phi&-s_\phi\\0&s_\phi/c_\theta&c_\phi/c_\theta\end{bmatrix}$$

$R=R_z(\psi)R_y(\theta)R_x(\phi)$, con $R_x,R_y,R_z$ las rotaciones elementales alrededor de cada eje. $T$ es singular en $\theta=\pm90^\circ$. Alternativa sin singularidad: cuaternión unitario $q=[w;\,\epsilon]$ ($w$ escalar, $\epsilon\in\mathbb R^3$; $q$ y $-q$ son la misma orientación):

$$\dot\eta_1=R(q)\nu_1,\qquad \dot q=\tfrac12\begin{bmatrix}-\epsilon^T\\ wI_3+S(\epsilon)\end{bmatrix}\nu_2,\qquad R(q)=I_3+2wS(\epsilon)+2S(\epsilon)^2,\quad \|q\|=1$$

La ecuación dinámica en $\nu$ no cambia. Lo que cambia: (i) la cinemática de arriba (7 variables de pose con la restricción $\|q\|=1$, que hay que renormalizar al integrar); (ii) $R(q)$ reemplaza a $R(\Theta)$ en $g=-\left[R^T(f_g+f_b);\ r_g\times R^Tf_g+r_b\times R^Tf_b\right]$, con $f_g=[0,0,W]^T$ y $f_b=[0,0,-B]^T$ las fuerzas de peso y de empuje en $\{n\}$; (iii) el error de orientación para control: sea $q_d=[w_d;\epsilon_d]$ el cuaternión de orientación **deseada** (la referencia, equivalente a los $\phi_d,\theta_d,\psi_d$ que se quieren). El error es $\tilde q=q_d^{-1}\otimes q=[\tilde w;\tilde\epsilon]$, donde $q_d^{-1}=[w_d;-\epsilon_d]$ es el inverso (conjugado) y $\otimes$ el producto de cuaterniones, $a\otimes b=[a_wb_w-a_\epsilon\cdot b_\epsilon;\ a_wb_\epsilon+b_wa_\epsilon+a_\epsilon\times b_\epsilon]$. Si $q=q_d$ entonces $\tilde q=[1;0]$, así que $\tilde\epsilon$ (3 componentes) es el error: vale 0 cuando la orientación coincide con la deseada. Como $q$ y $-q$ son la misma orientación, se elige el signo de $\tilde q$ tal que $\tilde w\ge0$; (iv) las referencias en Euler se convierten a cuaternión.

> **Corrección de terminología (a mi corrección anterior, que estaba mal):** en robótica el jacobiano analítico es $\partial x/\partial q$ de una función de pose, y el geométrico relaciona $\dot q$ con el twist $(v,\omega)$, que no es derivada de ninguna variable de orientación. $J(\eta)$ no es ninguno de los dos (no hay velocidades articulares). Es la **matriz de transformación cinemática**: cambio de representación del twist del cuerpo $\nu$ (cuasi-velocidades en $\{b\}$) a $\dot\eta$. $R$ cambia la base del vector de velocidad lineal; $T(\Theta)$ pasa $\omega_b$ a tasas de Euler (es la matriz que en robótica conecta el jacobiano geométrico con el analítico). No es una proyección (no es idempotente): es una transformación invertible dependiente del estado, salvo en las singularidades de $T$.

**Gravedad y empuje.** Con peso $W=mg$, empuje $B=\rho gV_d$, centro de gravedad $r_g=[x_g,y_g,z_g]$ y de flotación $r_b=[x_b,y_b,z_b]$ (NED):

$$g(\eta)=\begin{bmatrix}(W-B)s_\theta\\-(W-B)c_\theta s_\phi\\-(W-B)c_\theta c_\phi\\-(y_gW-y_bB)c_\theta c_\phi+(z_gW-z_bB)c_\theta s_\phi\\(z_gW-z_bB)s_\theta+(x_gW-x_bB)c_\theta c_\phi\\-(x_gW-x_bB)c_\theta s_\phi-(y_gW-y_bB)s_\theta\end{bmatrix}$$

Caso típico, $W=B$, $x_g=x_b$, $y_g=y_b$: solo quedan $g_4=W\,BG_z\,c_\theta s_\phi$ y $g_5=W\,BG_z\,s_\theta$, con $BG_z=z_g-z_b>0$ si G está debajo de B. Entonces **roll y pitch tienen estabilidad pasiva** (rigidez $W\,BG_z$), y surge, sway, heave y yaw no tienen restitución.

**Amortiguamiento.** $D(\nu)=D_{lin}+D_{quad}(\nu)$:

$$D_{lin}=-\mathrm{diag}\{X_u,Y_v,Z_w,K_p,M_q,N_r\},\qquad D_{quad}=-\mathrm{diag}\{X_{u|u|}|u|,\,Y_{v|v|}|v|,\,Z_{w|w|}|w|,\,K_{p|p|}|p|,\,M_{q|q|}|q|,\,N_{r|r|}|r|\}$$

La parte lineal es la tradicional del masa-resorte-amortiguador (fricción a baja velocidad); la cuadrática es el arrastre de presión, $F=-\tfrac12\rho C_DA|u|u$ en la dirección del movimiento, con $C_D$ el coeficiente de arrastre (adimensional) y $A$ el área de referencia (frontal).

**Arrastre transversal (cross-flow).** Un casco esbelto que se mueve de costado o rota se trata por rebanadas, como un cilindro 2D en flujo transversal. Cada rebanada, en la posición $x$ a lo largo de $x_b$, ve una velocidad transversal con dos componentes:

$$v_c(x)=v+x\,r\ \ (\text{dirección }y_b),\qquad w_c(x)=w-x\,q\ \ (\text{dirección }z_b)$$

Salen de $\nu_1+\nu_2\times(x,0,0)$. $r$ es la velocidad de **guiñada** (alrededor de $z_b$), no de roll: un giro de guiñada produce velocidad en $y_b$ proporcional al brazo $x$. Igual, el cabeceo $q$ (alrededor de $y_b$) produce velocidad en $z_b$ ($-xq$). El roll $p$ no aparece porque los puntos del eje están sobre el eje de roll. Heave sí está incluido ($w$): la rebanada ve ambas componentes y el arrastre actúa en la dirección de la velocidad resultante:

$$f_y(x)=-\tfrac12\rho\,C_D^{2D}\,d(x)\,\sqrt{v_c^2+w_c^2}\;v_c,\qquad f_z(x)=-\tfrac12\rho\,C_D^{2D}\,d(x)\,\sqrt{v_c^2+w_c^2}\;w_c$$

con $\rho$ densidad del agua, $d(x)$ diámetro local (ancho que ve el flujo transversal) y $C_D^{2D}$ coeficiente de arrastre de la sección en flujo transversal (del orden de 1 para un cilindro circular; tomarlo de tablas o CFD). Integrando sobre el largo $L$:

$$Y=\int_Lf_y\,dx,\quad Z=\int_Lf_z\,dx,\quad N=\int_Lx\,f_y\,dx,\quad M=-\int_Lx\,f_z\,dx$$

Con movimiento solo de sway: $Y=-\tfrac12\rho C_DA_p\,v|v|$, con $A_p=\int_L d\,dx$ el área lateral proyectada (la fórmula usual de arrastre). El acople sway-yaw sale de que $v_c$ depende de $v$ y $r$ a la vez: un yaw puro produce fuerza lateral neta si el casco no es simétrico proa-popa, y $v$ produce momento de guiñada. Sway y heave se acoplan por la raíz $\sqrt{v_c^2+w_c^2}$. Por las no linealidades no entra como diagonal en $D$. La diagonal es una primera aproximación; con aletas aparecen además términos cruzados y sustentación.

**Derivadas hidrodinámicas** (notación SNAME). Caracterizan el efecto en una dirección de aceleraciones o velocidades en la misma u otra dirección. Para los términos inerciales son lo mismo que los coeficientes de masa añadida: $M_{A,ij}=-\partial\tau_i/\partial\dot\nu_j$, por ejemplo $m_{11}=-X_{\dot u}$ (con $X_{\dot u}<0$). Para el amortiguamiento, $X_u,\ X_{u|u|},\dots$ son las derivadas respecto a la velocidad.

**Corriente.** Sea $v_c^n$ la velocidad de la corriente respecto de la Tierra, expresada en el marco inercial (el superíndice indica el marco en que se expresa el vector; típicamente constante). $R$ pasa de $\{b\}$ a $\{n\}$, entonces $R^T$ pasa de $\{n\}$ a $\{b\}$ y la corriente vista en el cuerpo es $\nu_c=[R^Tv_c^n;\,0]$ (sin parte angular: corriente uniforme e irrotacional). La velocidad **relativa al agua** es $\nu_r=\nu-\nu_c$.

Por qué sirve: las hipótesis del potencial pedían fluido en reposo en el infinito. Si la corriente es uniforme y constante, un marco que se mueve con el agua es inercial y en él el fluido sí está en reposo, entonces las ecuaciones de Kirchhoff valen con velocidad relativa:

$$M\dot\nu_r+C(\nu_r)\nu_r+D(\nu_r)\nu_r+g(\eta)=\tau+\tau_{pert}$$

con $\dot\nu_r=\dot\nu-\dot\nu_c$ y $\dot\nu_c=[-S(\nu_2)\nu_{c,1};\,0]$ (no nula si el vehículo rota, porque $\nu_c$ en $\{b\}$ cambia con la orientación). Muchos textos desprecian $\dot\nu_c$. La cinemática usa la velocidad absoluta, $\dot\eta=J(\eta)\nu$ (la posición se mide respecto de la Tierra). Efecto práctico: la corriente entra por la velocidad relativa (cambian arrastre y sustentación); para seguir posición respecto de la Tierra hace falta acción integral o compensación. Corrientes no uniformes o variables violan la deducción y se tratan como perturbación en $\tau_{pert}$.

**Modelo final** (sin corriente):

$$\boxed{M\dot\nu+C(\nu)\nu+D(\nu)\nu+g(\eta)=\tau_{control}+\tau_{pert},\qquad \dot\eta=J(\eta)\nu}$$

- $M=M_{RB}+M_A$ (constante, simétrica, definida positiva).
- $C=C_{RB}+C_A$ (antisimétrica).
- $D$: lineal + cuadrática (viscosa).
- $g(\eta)$: gravedad y empuje.
- $\tau_{control}$: fuerzas y momentos que generan los actuadores.
- $\tau_{pert}$: fuerzas y momentos de perturbación no modelados (olas, cable, cargas).

**Actuadores (Agregado).** $\tau_{control}=B_a(\nu)\,u_c$, donde $u_c$ es el vector de entradas de control (por ejemplo velocidad de giro de la hélice, deflexión del timón, deflexión de las aletas de profundidad) y $B_a(\nu)$ es la matriz que dice qué fuerzas y momentos produce cada entrada (depende de $\nu$ por el efecto de $U^2$).

- Propulsor: $F_T\approx k_T\,n_p|n_p|$, con $F_T$ el empuje, $n_p$ la velocidad de giro de la hélice y $k_T$ una constante de empuje (de ensayo o de la curva de la hélice). No lineal, con saturación, dinámica de motor y zona muerta a baja velocidad.
- Aleta: $F_L=\tfrac12\rho A_f\,C_{L\alpha}\,\alpha\,U^2$ es la fuerza de sustentación de una aleta, perpendicular al flujo. $A_f$: área en planta de la aleta. $U$: velocidad del flujo que llega a la aleta (≈ rapidez del vehículo, mayor si está en la estela de la hélice). $\alpha$: ángulo de ataque, entre el flujo y la cuerda de la aleta (≈ deflexión $\delta$ de la aleta más el ángulo que induce el movimiento del vehículo en ese punto). $C_{L\alpha}=\partial C_L/\partial\alpha$: pendiente de la curva de sustentación, en 1/rad (2π en 2D, menor en aletas cortas, del orden de 1–3; sacarlo de datos del perfil o CFD). Es lineal solo con $\alpha$ pequeño: a ángulos grandes (del orden de 15–20°) hay pérdida (stall). El momento sobre el vehículo es $F_L$ por el brazo $x_f$ (posición de la aleta a lo largo de $x_b$ respecto del origen). La **autoridad de control de las aletas crece con $U^2$**: a baja velocidad un torpedo pierde control de profundidad y rumbo.
- Sin $U$ no hay efectividad de aletas. Un vehículo con propulsores en todos los ejes (base plana / ROV-AUV) no tiene ese problema.

---

## 15. Lo que el modelo no incluye

- **VIV (vibraciones inducidas por vórtices).** Vienen del desprendimiento de vórtices (efecto viscoso, separación de flujo), no de la "no rotacionalidad" como decía el original.
- **Resistencia viscosa.** Va en $D$ (sección 14).
- **Superficies de control.** Generan fuerzas de sustentación y arrastre que dependen de la deflexión y de $U^2$. Se modelan como entrada en $\tau_{control}$.

> **Corrección:** el original decía que las superficies de control modifican la ubicación del centro de masa. No es así: las aletas casi no mueven el CG. Lo que sí mueve CG o flotabilidad son lastres móviles, tanques de lastre o cambio de carga útil.

- **Corriente.** Hace que $D$ y $C_A$ usen velocidad relativa (arriba).
- **Efectos de memoria (historia).** Fuerzas que dependen de la historia del movimiento y no solo del estado actual. Con las hipótesis del potencial en fluido ilimitado el fluido responde instantáneamente (incompresible) y $M_A$ constante es exacto a cualquier frecuencia. La memoria aparece cuando esas hipótesis fallan: (1) superficie libre (las olas radiadas devuelven efecto después: $M_A$ y el amortiguamiento de radiación dependen de la frecuencia y la fuerza es una convolución, ecuación de Cummins); (2) estela y vorticidad viscosa (separación no estacionaria); (3) sustentación no estacionaria de aletas. No tienen que ver con que el fluido sea newtoniano (el agua lo es). Se comparan con el tiempo característico del fluido $L/U$: si el movimiento es lento respecto de él ($\omega L/U\ll1$) vale el modelo cuasi-estacionario. AUV profundo con maniobras suaves: se desprecia.
- **Sustentación del casco** a ángulo de ataque (circulación viscosa).
- **Efectos de frontera:** superficie libre, fondo, paredes.
- Para los coeficientes de $D$: gain scheduling por velocidad, o forma funcional de los coeficientes de arrastre según Reynolds.

---

## 16. Estructura de $M_A$ según simetría y valores de referencia (Agregado)

- Cuerpo con tres planos de simetría (elipsoide, caja simétrica): $M_A$ diagonal.
- Torpedo de revolución con simetría proa-popa y origen en el centro: $M_A=\mathrm{diag}\{m_{11},m_{22},m_{22},0,m_{55},m_{55}\}$.
- Torpedo real (proa y popa distintas) o vehículo asimétrico: aparecen $m_{26}$ y $m_{35}$ (acoplamiento sway-yaw y heave-pitch). Elegir el origen cerca del centro de flotación reduce los términos cruzados pero no siempre los anula.
- Cada apéndice (aletas, propulsores, carga útil externa) modifica $M_A$ y $D$. Un vehículo open-frame tiene $M_A$ sensiblemente distinto al del casco desnudo.

Para validar el código de simulación: el vehículo REMUS 100 tiene tablas completas de parámetros publicadas (Prestero, MIT/WHOI, 2001). Útil para comparar contra una implementación propia.

---

## 17. Síntesis para modelado y control

**Qué es el modelo.**

$$\dot\eta=J(\eta)\nu,\qquad (M_{RB}+M_A)\dot\nu+C(\nu)\nu+D(\nu)\nu+g(\eta)=B_a(\nu)u_c+\tau_{pert}$$

**Qué es cada término y de dónde sale.**

| Término | Origen | Cómo se obtiene |
|---|---|---|
| $M_{RB}$ | cuerpo rígido | $m$, $r_g$, $I_b$ (CAD o medición) |
| $M_A$ | potencial, geometría | esferoide (fórmulas), strip theory, BEM; constante en $\{b\}$, simétrica, $>0$ |
| $C(\nu)$ | Kirchhoff | fórmula cerrada a partir de $M$; no se identifica |
| $D(\nu)$ | viscosidad | ensayo, CFD o identificación; es la parte más incierta |
| $g(\eta)$ | peso y empuje | $W$, $B$, $r_g$, $r_b$ |
| $B_a(\nu)u_c$ | actuadores | propulsor $\propto n_p^2$ (con signo), aletas $\propto U^2$ |

**Ideas clave.**

1. La masa añadida es un parámetro de la energía del fluido, no una masa pegada. Para AUV en agua es del orden de la masa del vehículo (transversal) o 5–10% (axial).
2. Potencial **no** da arrastre ni sustentación (d'Alembert, sin circulación). Esos van en $D$ y en actuadores.
3. $m_{11}\ne m_{22}$ produce el momento de Munk, desestabilizante. El casco desnudo de un torpedo es inestable en guiñada y cabeceo.
4. $C(\nu)$ se obtiene de $M$ con una fórmula y es antisimétrica ($\nu^TC\nu=0$).
5. $M_A$ vale lejos de superficie, fondo y paredes. En ensayos en pileta o cerca del fondo hay que desconfiar de ese valor.
6. Roll y pitch están estabilizados pasivamente por la separación vertical $BG_z$; surge, sway, heave y yaw no.
7. La autoridad de las aletas depende de $U^2$.

**Implicancias para el diseño del controlador.**

- **Tipo de vehículo.** Torpedo: subactuado (empuje + timón + aletas de profundidad, no hay actuación directa en sway, heave, roll) y con efectividad dependiente de la velocidad. Base plana con propulsores en varios ejes: actuación completa en varios grados de libertad. El esquema de control cambia según el caso.
- **Linealización.** Se linealiza alrededor de la condición de operación (por ejemplo, avance a $U_0$ constante), con modelo dependiente de $U_0$. Con simetría, el modelo se desacopla en canales: surge; heave-pitch (plano vertical); sway-yaw-roll (plano horizontal). Es el punto de partida habitual para PID/LQR por canal con gain scheduling en $U_0$.
- **Control no lineal y diseño con Lyapunov.** Idea: elegir una función escalar $V$ que mida el "tamaño" del error (positiva salvo cuando el error es cero, tipo energía) y diseñar la ley de control para que $V$ decrezca siempre ($\dot V<0$). Si eso pasa, el error tiende a cero, y eso prueba estabilidad del sistema no lineal sin linealizar ni resolver las ecuaciones.

  Ejemplo con este modelo, válido solo con **actuación completa** (se puede comandar cualquier $\tau\in\mathbb R^6$). Definiciones:
  - $\eta_d(t)$: trayectoria de pose deseada (dato). $\tilde\eta=\eta-\eta_d$: error de pose.
  - $\Lambda$: matriz diagonal $6\times6$ de ganancias positivas (la elige el diseñador).
  - $\nu_{ref}=J^{-1}(\eta)\,(\dot\eta_d-\Lambda\tilde\eta)$: velocidad que el cuerpo debería tener para que el error de pose decaiga como $\dot{\tilde\eta}=-\Lambda\tilde\eta$.
  - $s=\nu-\nu_{ref}$: diferencia entre la velocidad real y la de referencia. Si $s=0$ entonces $\dot{\tilde\eta}=-\Lambda\tilde\eta$ y el error de pose tiende a cero.
  - $K_d$: matriz $6\times6$ simétrica definida positiva de ganancias.
  - **Ley de control** (qué $\tau$ comandar):

$$\tau=M\dot\nu_{ref}+C(\nu)\nu_{ref}+D(\nu)\nu_{ref}+g(\eta)-K_d\,s$$

  Es el modelo evaluado en la velocidad de referencia (cancela la dinámica conocida) más un término $-K_ds$ que corrige la desviación. Reemplazada en el modelo da la dinámica de $s$: $M\dot s+\big(C(\nu)+D(\nu)+K_d\big)s=0$.
  - $V=\tfrac12 s^TMs$: energía cinética asociada a $s$ (positiva porque $M>0$). Con $M$ constante, $\dot V=s^TM\dot s=-s^T(C+D+K_d)s=-s^T(D+K_d)s<0$ para $s\ne0$, porque $s^TC(\nu)s=0$ (antisimetría). Entonces $s\to0$ y $\tilde\eta\to0$.

  Es exacto solo si el modelo es exacto; con incertidumbre se agregan términos robustos o adaptativos (también diseñados con Lyapunov).

  **¿Sirve para un torpedo o un glider?** Esa ley, tal cual, no: exige comandar las 6 componentes de $\tau$. Un torpedo tiene ~3 entradas (empuje, timón de dirección, aletas de profundidad) y un glider menos (motor de flotabilidad, masa interna móvil). El **método** sí sirve, aplicado a un modelo reducido de lo que se controla: velocidad de avance, rumbo y profundidad. Ejemplo de un canal, rumbo de un torpedo, con modelo simplificado (sin acoplamientos; roll y pitch chicos, entonces $\dot\psi\approx r$):

$$I_{ef}\,\dot r+d\,r=b\,\delta_r$$

  con $\delta_r$ la deflexión del timón, $I_{ef}$ la inercia efectiva en guiñada (rígido + añadida), $d$ el coeficiente de amortiguamiento en guiñada y $b$ la efectividad del timón ($b\propto U^2$). Se define $\tilde\psi=\psi-\psi_d$ (con $\psi_d$ el rumbo deseado), $r_{ref}=\dot\psi_d-\lambda\tilde\psi$ ($\lambda>0$), $s=r-r_{ref}$, la ley $\delta_r=\tfrac1b\big(I_{ef}\dot r_{ref}+d\,r_{ref}-k\,s\big)$ ($k>0$) y $V=\tfrac12I_{ef}s^2$. Resulta $\dot V=-(d+k)s^2$. Como $b\propto U^2$, la ley falla a baja velocidad. Además, un torpedo no puede seguir una trayectoria 3D arbitraria con velocidad prescrita (no actúa en sway ni heave): se hace seguimiento de camino (path following) guiando rumbo y profundidad.

  Otras opciones: modo deslizante, backstepping, linealización por realimentación. $M>0$ constante, $C$ antisimétrica, $D>0$ y $g$ acotada son lo que habilita todo esto, y la estructura del modelo sirve como feedforward.
- **Singularidad de Euler.** Si el vehículo puede acercarse a $\theta=\pm90^\circ$, usar cuaterniones.
- **Prueba de robustez (lo que ya planteabas, con más contenido).** Una vez armado el modelo, variar los parámetros inciertos en un rango razonable y evaluar el controlador (Monte Carlo o barrido):
  - Coeficientes de arrastre $D$ (los más inciertos).
  - $M_A$ (según el método usado, error moderado en esferoide, mayor en vehículos asimétricos o con apéndices).
  - $r_g$, $r_b$, $W-B$ (cambios de carga útil, lastre).
  - Corriente $\nu_c$ y perturbaciones $\tau_{pert}$.
  - Saturación y dinámica de actuadores, zona muerta, ruido y retardo de sensores.
  - Rango de velocidades $U_0$ (la linealización cambia con $U_0$).

  Los rangos concretos de variación los define el proyecto; no existe un valor universal. Para cada caso, medir estabilidad, error en régimen y esfuerzo de control.
- **Chequeos del modelo antes de controlar.** $M$ simétrica y definida positiva; $\nu^TC\nu=0$ numéricamente; sin actuación, la energía total (cinética + potencial por peso y empuje) solo decrece (por $D$); respuesta estática de roll/pitch según $BG_z$; comparar contra un vehículo con parámetros publicados (REMUS 100).

**Referencias para seguir.** Fossen, *Handbook of Marine Craft Hydrodynamics and Motion Control* (2011); Lamb, *Hydrodynamics*; Newman, *Marine Hydrodynamics*; Brennen, *A Review of Added Mass and Fluid Inertial Forces* (1982); Prestero (2001) para REMUS; apuntes del curso MIT 2.154 (maniobra y control de vehículos sumergibles). Verificar ediciones y ecuaciones contra el texto original antes de citarlas en el informe.
