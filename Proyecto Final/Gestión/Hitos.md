# Hitos del Proyecto

**Objetivo:** Diseño, simulación y análisis de un sistema de control para el AUV Maribot LoLo con seguimiento de trayectorias 6-DOF.

**Entrega final:** 17-19 Julio 2026 (~50 días desde 28 Mayo)

| # | Hito | Fecha límite | Días | Dependencias | Entregable |
|---|------|-------------|------|-------------|------------|
| H0 | Fundación: AGENTS.md, Obsidian, Typst | 31 May | 3 | — | Repo configurado, herramientas listas |
| H1 | Modelo dinámico del AUV en Simulink validado | 10 Jun | 10 | H0 | Modelo en lazo abierto verificado |
| H2 | Modelos de sensores, actuadores, ruido completos | 18 Jun | 8 | H1 | Planta completa con sensores/actuadores |
| H3 | Controlador LQR + gain scheduling + EKF | 30 Jun | 12 | H2 | Sistema en lazo cerrado funcional |
| H4 | Discretización + simulación final con perturbaciones | 7 Jul | 7 | H3 | Resultados de simulación completos |
| H5 | Informe final en Typst | 15 Jul | 8 | H4 | PDF listo para revisión |
| H6 | Buffer + entrega final | 17-19 Jul | 2-4 | H5 | PDF + archivos fuente entregados |

## Seguimiento semana a semana

| Semana | Fechas | Hito | Tareas clave |
|--------|--------|------|-------------|
| S1 | 28 May - 3 Jun | H0→H1 | Setup, lectura de referencias, modelo dinámico |
| S2 | 4 Jun - 10 Jun | H1 | Implementación Simulink, validación lazo abierto |
| S3 | 11 Jun - 17 Jun | H1→H2 | Sensores, actuadores, ruido, VBS |
| S4 | 18 Jun - 24 Jun | H2→H3 | Linealización, LQR, EKF |
| S5 | 25 Jun - 1 Jul | H3 | Gain scheduling, pruebas en lazo cerrado |
| S6 | 2 Jul - 8 Jul | H3→H4 | Discretización, perturbaciones, sintonía fina |
| S7 | 9 Jul - 15 Jul | H4→H5 | Informe completo en Typst |
| S8 | 16 Jul - 19 Jul | H5→H6 | Revisión, buffer, entrega |
