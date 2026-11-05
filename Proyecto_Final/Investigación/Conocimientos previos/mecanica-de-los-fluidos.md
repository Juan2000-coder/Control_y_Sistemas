# Repaso de matemáticas y Mecánica de los Fluidos.
> * **Laplaciano:**
> $$\nabla^2 f = \nabla \cdot (\nabla f)$$
> * **Ecuación de continuidad:** es la conservación de la masa en un cubo diferencial; se considera el flujo de masa a través del mismo
> $$\frac{\partial \rho}{\partial t} + \nabla \cdot (\rho \vec{\mathbf{v}}) = 0$$
> Que para un fluido incompresible se reduce a $\nabla \cdot \vec{\mathbf{v}} = 0$
> * **Derivada material:**  derivada total dado que las variables del fluido están parametrizadas tanto en tiempo como en posición.
> $$\frac{D\vec{\mathbf{u}}}{Dt} = \frac{\partial \vec{\mathbf{u}}}{\partial t} + (\vec{\mathbf{u}} \cdot \nabla)\vec{\mathbf{u}}$$
> * <a id="ecuaciones-de-euler"></a>**Ecuaciones de Euler**: esto es la igualdad entre la aceleración total y la fuerza por unidad de masa calculada para una masa diferencial a partir del campo de presiones local y las fuerzas por unidad de masa potencial $\chi$, lo que incluye a la aceleración de la gravedad; esto no considera las fuerzas por viscosidad
> $$\frac{\partial\vec{\mathbf{u}}}{\partial t} + (\vec{\mathbf{u}} \cdot \nabla)\vec{\mathbf{u}} = -\frac{1}{\rho}\nabla p - \nabla \chi$$
>* **Ecuación de Navier-Stokes:**  esta en realidad está incompleta porque es para un fluido con viscosidad constante y que además es incompresible.
>$$\rho \left( \frac{\partial \vec{\mathbf{u}}}{\partial t} + (\vec{\mathbf{u}} \cdot \nabla)\vec{\mathbf{u}} \right) = - \nabla p + \mu \nabla^2 \vec{\mathbf{u}} + \rho \vec{\mathbf{g}}$$
> *Nota: Acá el $\nabla^2$ implica hacer, primero, la derivada del vector de velocidad respecto a $x, y, z$, lo cual da una matriz en donde por columna están las derivadas de las componentes del vector. Segundo, la divergencia por filas de esa matriz.*
>
> * <a id= "flujo-potencial"></a>**El flujo potencial** es un modelo ideal en donde tomamos:
> $$\mu = 0$$
> $$\nabla \times \vec{\mathbf{v}} = 0$$
>
> Por la hipótesis de irrotacionalidad podemos afirmar la existencia de una función potencial $\phi$ tal que $\nabla\phi = \vec{\mathbf{v}}$.



### Teorema de circulación de Kelvin
La derivada de la circulación $\Gamma$ respecto al tiempo de un fluido ideal y barotrópico $\rho = \rho(p)$ sobre el que solamente actúan fuerzas conservativas es nula (circulación constante):
> Acá sin embargo hay que tener en cuenta que la circulación se evalúa a lo largo de una curva arbitraria material cerrada, es decir, la curva en el espacio que forma uns secuencia de elementos de fluido. Esta se deforma en el tiempo según los elementos de fluido de esa curva se van moviendo.

$$\frac{D\Gamma}{Dt} = 0 \quad \text{donde} \quad \Gamma = \oint_C \vec{\mathbf{v}} \cdot d\vec{\mathbf{r}}$$

Por lo tanto, si la circulación inicial es cero $\Gamma(0) = 0$, se mantiene nula para todo tiempo $\Gamma(t) = 0$.

> Como caso de aplicación se tiene el de un perfil alar que parte del reposo. Al ponerse en movimiento, en el borde de salida (parte posterior) se desprende un remolino de arranque con circulación $\Gamma_{\text{remolino}}$. Para cumplir con el teorema de Kelvin, la circulación total alrededor de una curva que encierre al perfil y al remolino debe seguir siendo cero:
>$$\Gamma_{\text{total}} = \Gamma_{\text{perfil}} + \Gamma_{\text{remolino}} = 0$$
>Por lo tanto, el perfil genera una circulación propia igual y opuesta a la del remolino desprendido:
>$$\Gamma_{\text{perfil}} = -\Gamma_{\text{remolino}}$$


### Ecuación de Bernoulli diferencial no permanente para flujo potencial incompresible 
* $\mu = 0$
* $\rho = \text{cte}$,
* $\nabla \times \vec{\mathbf{v}} = 0$,
* $v_{\infty} = 0$

Partimos de la [Ecuación de Euler](#ecuaciones-de-euler) para fluido incompresible. En la misma analizamos el término de aceleración convectiva:
$$(\vec{\mathbf{v}} \cdot \nabla)\vec{\mathbf{v}} = \nabla \left( \frac{1}{2} \vec{\mathbf{v}} \cdot \vec{\mathbf{v}} \right) - \vec{\mathbf{v}} \times (\nabla \times \vec{\mathbf{v}}) = \nabla \left( \frac{1}{2} v^2 \right)$$

Y además $\nabla \phi = \vec{\mathbf{v}}$ por lo que dijimos para el [flujo potencia](#flujo-potencial). Luego:
$$\nabla \frac{\partial \phi}{\partial t} + \nabla \left( \frac{1}{2} v^2 \right) + \frac{1}{\rho}\nabla p + \nabla \chi = 0$$

Acá hay que notar que en el término de la derivada parcial respecto al tiempo (término de aceleración local) el $\nabla$ originalmente va adentro de la derivada, pero puede salir dado que es lo mismo derivar primero respecto al tiempo y después respecto al espacio. Luego el operador nabla lo sacamos como "factor común":
$$\nabla \left( \frac{\partial \phi}{\partial t} + \frac{1}{2} v^2 + \frac{p}{\rho} + \chi \right) = 0$$

Se hace la integral de línea de eso desde el infinit a cualquier punto en el campo de flujo. Como es la integral de linea de un gradiente, equivale a evaluar el campo escalar en $\infty$ y en el punto y tomar la diferencia. Cuando se evalua en $\infty$ los términos de velocidad se anulan por la hipótesis de fluido en reposo en el infinito. También se anula el término $\frac{\partial \phi}{\partial t} = 0$. Tomamos también $\chi = 0$ en $\infty$. En definitiva todo eso se colapsa en el término de la constante de integración $C(t)$

$$\frac{\partial \phi}{\partial t} + \frac{1}{2} v^2 + \frac{p}{\rho} + \chi = C(t)$$
