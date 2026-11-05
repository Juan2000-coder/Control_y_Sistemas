# Modelo Dinámico

Partimos de las ecuaciones de fuerza y torque que dedujimos para el [modelo dinámico](./conocimientos-previos-de-robotica.md#deducción-del-modelo) en el documento de conocimientos previos.
Ahora queremos expresar el modelo de forma matricial y de una forma apropiada según las consideraciones señaladas en el [paper de Fossen](<../Fuentes/Modelo Dinámico/Modelado utiles/1_1_Fossen_y_Fjellstad.pdf>).

Volvemos a definir las siguientes variables:
* $O$: Origen del marco de referencia del cuerpo (*body frame* $B$), el cual se traslada respecto al marco inercial $I$.
* $G$: Centro de masa del cuerpo rígido.
* $\mathbf{r}_G$: Posición de $G$ relativa a $O$. Es constante (${}^B\dot{\mathbf{r}}_G = 0$) debido a la condición de rigidez.
* $\mathbf{v}$: Velocidad de $O$ respecto a $I$.
* $\mathbf{\omega}$: Velocidad angular.
* $I_O$: tensor de inercia del cuerpo respecto a $O$
* $\tau_1$: fuerza externa neta respecto al centro de masa
* $\tau_2$: torque externo neto respecto a $O$
* $M$: es la masa del cuerpo rígido

---
*Recordemos que las ecuaciones a continuación se presentan con la notación simplificada y que las magnitudes son vectores aritméticos proyectados en el marco de referencia del Body*
* Ecuación de fuerza
$$\boxed{\tau_1 = M \left[ \dot{v} + \omega \times v + \dot{\omega} \times r_G + \omega \times (\omega \times r_G) \right]}$$
$$M \left[ \dot{v} + \dot{\omega} \times r_G + \omega \times v + \omega \times (\omega \times r_G) \right] = \tau_1
$$
$$M \dot{v} - M S(r_G)\dot{\omega} + 0_{3\times3}v- \left[M S(v) + M S(\omega)S(r_G)\right]\omega = \tau_1$$

* Ecuación de momentos
$$\boxed{\tau_2 = I_O \dot{\omega} + \omega \times (I_O \cdot \omega) + r_G \times M \left( \dot{v} + \omega \times v \right)}$$
$$M r_G \times \dot{v} + I_O \dot{\omega} +  M r_G \times (\omega \times v) + \omega \times (I_O \omega) = \tau_2$$
$$M S(r_G)\dot{v} + I_O \dot{\omega} - \left[M S(v) - M S(r_G)S(\omega)\right]v - S(I_O \omega)\omega = \tau_2$$

*Notar que en la ecuación de torque agregamos el término $ - M S(v)v \equiv 0$. Esto se hace para que la matriz de términos de Coriolis y de fuerza centrípeta sea antisimétrica. Hay múltiples otras formas de expresar esta misma matriz de modo que sea [anti-simétrica](#formas-alternativas-de-la-matriz-de-coriolis).*

Agrupamos ahora esas ecuaciones para expresarlo todo en forma matricial

$$\boxed{\begin{bmatrix} M & -M S(r_G) \\ M S(r_G) & I_O \end{bmatrix} \begin{bmatrix} \dot{v} \\ \dot{\omega} \end{bmatrix} + \begin{bmatrix} \mathbf{0}_{3 \times 3} & -M S(v) - M S(\omega)S(r_G) \\ -M S(v) + M S(r_G)S(\omega) & -S(I_O \omega) \end{bmatrix} \begin{bmatrix} v \\ \omega \end{bmatrix} = \begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix}}$$

A partir de esto definimos los elementos del modelo respecto al Body Frame. El <u>vector de estado $\nu$</u>, <u>la matriz de masa $M_{RB}$</u>, <u>la matriz de términos de Coriolis $C_{RB}(\nu)$</u> y el <u>vector de fuerzas $\tau_{RB}$</u>.
* $\nu = \begin{bmatrix} \nu_1 &\nu_2\end{bmatrix}^T = \begin{bmatrix} v &\omega\end{bmatrix}^T$

* $M_{RB} = \begin{bmatrix} M & -M S(r_G) \\ M S(r_G) & I_O \end{bmatrix}$

* $C_{RB}(\nu) = \begin{bmatrix} \mathbf{0}_{3 \times 3} & -M S(v) - M S(\omega)S(r_G) \\ -M S(v) + M S(r_G)S(\omega) & -S(I_O \omega) \end{bmatrix}$

* $\tau_{RB} = \begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix}$

Entonces el modelo se expresa de forma sintética como:
$$\boxed{M_{RB}\dot{\nu} + C_{RB}(\nu)\nu = \tau_{RB}}$$

> ## Formas alternativas de la matriz de Coriolis
> Tomamos el término $r_G \times (\omega \times v)$ de la ecuación de Momentos y lo desarrollamos utilizando la [identidad de jacobi](#identidad-de-jacobi):
> $$r_G \times (\omega \times v) = v\times(\omega\times r_G) + \omega\times(r_G\times v) = -(\omega\times r_G)\times v \, +\, (v\times r_G)\times\omega$$
> $$=-S(S(\omega)r_G)v\,+\, S(S(v)r_G)\omega$$
> Completamos con el resto de los términos de la ecuación de momento que están inolucrados en la matriz $C_{RB}$ y agrupamos
> $$= \left[M S(v) - MS(S(\omega)r_G)\right]v\,+\, \left[S(S(v)r_G) - S(I_O \omega)\right]\omega$$
> El término $M\omega \times (\omega \times r_G)$ en la ecuación de Fuerza se puede expresar como $- MS(S(\omega)r_G)\omega$. Reemplazando y considerando todos los términos de esa ecuación involucrados en Coriolis obtenemos
> $$0_{3\times3}v- \left[M S(v) + MS(S(\omega)r_G)\right]\omega$$
> Finalmente $C_{RB}$ queda de la forma
> $$C_{RB}(\nu) = \begin{bmatrix} \mathbf{0}_{3 \times 3} & -M S(v) - MS(S(\omega)r_G) \\ -M S(v) - MS(S(\omega)r_G) & S(S(v)r_G) - S(I_O \omega) \end{bmatrix}$$
> ### Identidad de Jacobi
> Partimos del doble producto vectorial de tres vectores arbitrarios $a, b, c$. Desarrollamos la identidad del doble producto y luego sumamos y restamos el término $(c \cdot b)a$. Agrupamos términos para aplicar nuevamente la identidad del doble producto vectorial a los términos agrupados.
> $$a \times (b \times c) = \overline{(a \cdot c)b} - \underline{(a \cdot b)c} + \underline{(c \cdot b)a} - \overline{(c \cdot b)a}$$
> $$a \times (b \times c) = \overline{c \times (b \times a)} + \underline{b \times (a \times c)}$$
> 
