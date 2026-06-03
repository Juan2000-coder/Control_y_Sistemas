# Recursos Técnicos — AUV Maribot LoLo

Fuente: Holm (2020), Deutsch et al. (2018), Fossen (1994)

## Datos físicos (Holm 2020, Tabla 2)

| Parámetro | Símbolo | Valor | Unidad |
|-----------|---------|-------|--------|
| Eslora | L | 3.8 | m |
| Manga | b | 1.05 | m |
| Puntal | h | 0.6 | m |
| Masa (seca) | m | 300 | kg |
| Inercia roll | Ix | 37 | kg·m² |
| Inercia pitch | Iy | 370 | kg·m² |
| Inercia yaw | Iz | 389 | kg·m² |

Nota: El paper de Deutsch et al. reporta ~600 kg dry weight. Holm usa 300 kg (quizás sin lastre ni baterías). Usar 600 kg para simulación nominal y verificar.

## Coeficientes de amortiguamiento lineal (Holm 2020, Tabla 4)

| DOF | Coeficiente | Valor | Unidad |
|-----|------------|-------|--------|
| Surge | Xu | 20 | N/(m/s) |
| Sway | Yv | 2500 | N/(m/s) |
| Heave | Zw | 3000 | N/(m/s) |
| Roll | Kp | 400 | Nm/(rad/s) |
| Pitch | Mq | 600 | Nm/(rad/s) |
| Yaw | Nr | 1500 | Nm/(rad/s) |

## Actuadores

### Propulsores (2 hélices contrarrotantes, CRP)
- Empuje por hélice: T = 5.1e-5·R·|R| + 0.0026·|R| [N], R en RPM
- Datos de diseño: R = [233, 465, 698, 1628] RPM → T = [3, 11, 24, 133] N
- Rango de R: ~0-1628 RPM (crucero ~500 RPM)
- Posición en y del propulsor: lpy (distancia al centro)

### Timones (2 acoplados, tratados como 1)
- Deflexión: δr [rad]
- Fuerzas: Lr (lift), Dr (drag) → τY = Lr, τN = Lr·lyaw
- Generan momentos en roll y pitch además de yaw

### Elevador (1)
- Deflexión: δe [rad]
- Fuerzas: Le (lift), De (drag) → τZ = Le, τM = Le·lpitch

### Elevones (2, control individual)
- Deflexión: δev1, δev2
- Lift en cada uno: Lev1, Lev2
- Momentos en roll y pitch según diferencia

### Vector de entrada (4 canales)
u = [R1, R2, δr, δe]ᵀ — RPM motor 1 y 2, ángulo timón, ángulo elevador

## Ecuaciones de movimiento (Fossen 6-DOF)

η̇ = J(η)·ν

M·ν̇ + C(ν)·ν + D(ν)·ν + g(η) + g₀ = τ

Donde:
- η = [x, y, z, φ, θ, ψ]ᵀ (posición NED + ángulos Euler)
- ν = [u, v, w, p, q, r]ᵀ (velocidades lineales y angulares en BODY)
- M = MRB + MA (masa rígida + masa añadida)
- C(ν) = Coriolis y centrífugas (rígida + añadida)
- D(ν) = Dlineal + Dcuadrático (amortiguamiento hidrodinámico)
- g(η) = fuerzas de restauración (gravedad + flotabilidad)
- g₀ = VBS (flotabilidad variable)
- τ = fuerzas y momentos de actuadores

## Linealización (Vessel Parallel, Holm 2020)

Asumiendo φ,θ pequeños, velocidad baja (~1-2 m/s), flotabilidad neutra:

⌘̇p = ν
ν̇ = M⁻¹·(-D·ν - G·⌘p + B·u)

Sistema LTI de orden 12: x = [⌘p; ν] ∈ ℝ¹²

## Control propuesto
- **LQR** con gain scheduling (3+ puntos de operación según velocidad de avance)
- **EKF** para fusión sensorial: AHRS + DVL + altímetro + profundidad
- Discretización: Tustin o ZOH, Ts a determinar (~0.1-0.2 s según Holm)

## Reportes de referencia (Pibardos)
- Salazar (2025): Quadcopter agrícola, LQR + EKF, estructura de informe completa
- Escobar: AUV/ROV, modelado + control + sensores
- Dalessandro: Modelado lineal + controlador en cascada
