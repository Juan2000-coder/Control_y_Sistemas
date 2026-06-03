---

kanban-plugin: board

---

## 🔷 Fase 1: Modelado de Planta (H1 — 10 Jun)

- [ ] Leer referencias AUV (Lolo paper, Fossen, Holm tesis)
- [ ] Derivar modelo matemático 6-DOF
- [ ] Obtener/estimar coeficientes hidrodinámicos
- [ ] Implementar dinámica no-lineal en Simulink
- [ ] Pruebas lazo abierto
- [ ] Modelar VBS
- [ ] Documentar modelo

## 🔶 Fase 2: Sensores y Actuadores (H2 — 18 Jun)

- [ ] Modelar BLDC + hélices CRP
- [ ] Modelar superficies de control (rudders, elevator)
- [ ] Modelar AHRS (acel + giro + mag)
- [ ] Modelar DVL + altímetro + profundidad
- [ ] Modelar ruido (proceso + medición)
- [ ] Integrar subsistemas en Simulink
- [ ] Pruebas de consistencia

## 🔷 Fase 3: Controlador y EKF (H3 — 30 Jun)

- [ ] Elegir puntos de operación para linealización
- [ ] Linealización Jacobiana (symbolic/numeric)
- [ ] Verificar controlabilidad y observabilidad
- [ ] Diseñar LQR base
- [ ] Implementar gain scheduling
- [ ] Diseñar EKF
- [ ] Integrar controlador + EKF en lazo cerrado

## 🔶 Fase 4: Simulación y Validación (H4 — 7 Jul)

- [ ] Prueba hovering
- [ ] Seguimiento trayectoria exploración
- [ ] Simulación con ruido sensorial
- [ ] Perturbaciones ambientales (corriente)
- [ ] Discretización del controlador
- [ ] Simulación final completa
- [ ] Métricas de desempeño

## 🔷 Fase 5: Informe (H5 — 15 Jul)

- [ ] Portada + Resumen
- [ ] Introducción + Objetivos
- [ ] Modelo de la Planta
- [ ] Sensores y Actuadores
- [ ] Estrategia de Control
- [ ] Estimación de Estados
- [ ] Resultados (plots + métricas)
- [ ] Conclusiones
- [ ] Referencias + Apéndices

## ⬜ Buffer / Imprevistos




%% kanban:settings
```
{"kanban-plugin":"board","list-collapse":[false,false,false,false,false,false],"move-tags":true,"show-checkboxes":true}
```
%%
