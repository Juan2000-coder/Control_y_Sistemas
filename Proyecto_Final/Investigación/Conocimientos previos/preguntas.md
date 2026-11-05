En relación a la fórmula de Rodrigues
---
* Explica por qué el filtro de Kalman en orientación (EKF/UKF) no se puede hacer con suma simple de estados: hay que trabajar en el espacio tangente (so(3)) y mapear con exp/log.
* Explica por qué los cuaterniones necesitan normalizarse constantemente (te vas "cayendo" fuera de la variedad por error numérico).
* Es la base de por qué en control de actitud (drones, satélites) usás velocidad angular ω como variable de estado en vez de derivar ángulos de Euler directamente.
* ¿Es posta una superficie plana la tangente a SO(3)? Por lo que entiendo SO(3) está embebido en R^9, pero solamente tiene 3 parámetros libres, lueog si quisiera visualizarse sería en R^4. Entonces mi intuivión me dice que la derivada estaría en R^3 y no sería un plano posta.

Lo que sigue
---
- [X] Hacer el ejercicio de escribir de forma explícita la matriz de rotación a partir de las componentes de un cuaternion.
> Hecho. Da lo mismo que en el paper de Fossen
- [X] Propiedades de la rotación del producto vectorial de vectores
- [X] Teorema del Transporte
- [ ] Modelo dinámico en sí.
