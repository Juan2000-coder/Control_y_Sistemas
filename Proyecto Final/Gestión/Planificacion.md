# Planificación del Proyecto — AUV Maribot LoLo

> **Objetivo:** Diseño, simulación y verificación de un sistema de control LQR + gain scheduling + EKF para el AUV Maribot LoLo.
> **Materia:** Control y Sistemas — Facultad de Ingeniería, UNCuyo
> **Autor:** Juan Manuel Borquez Perez
> **Entrega:** 17-19 Julio 2026

---

## 🗺️ Flujo de Trabajo

### 🔄 Rutina diaria

```
1. ABRIR este archivo → revisar la sección 📊 Estado del Proyecto
2. ABRIR el kanban → [[Tablero_Principal]]
   (hacé clic en el link de arriba si estás en Obsidian)
3. ELEGIR una tarea pendiente de la fase activa
4. TRABAJAR en Simulink / MATLAB / Typst
5. MARCAR la tarea como hecha en el kanban
6. Si surge una CONSULTA para el profe → ejecutar en la terminal:
        bash Proyecto\ Final/consultas.sh
   → El script te guía campo por campo (tema, contexto, pregunta)
   → Al final abre el archivo en VSCode
   → Pegás (Ctrl+V) las capturas de pantalla directamente en la tarjeta
7. CERRAR SESIÓN:
       bash git-session-commit.sh
```

### 📅 Al alcanzar un hito

```
1. Verificar que TODAS las tareas del hito estén marcadas en el kanban
2. Documentar resultados relevantes
3. Marcar el hito como ✅ en la sección 📊 Estado de este archivo
4. Actualizar las barras de progreso manuales
```

### 📊 Revisión semanal (opcional)

```
1. Abrir kanban → revisar tareas atrasadas
2. Actualizar fechas de hitos si hace falta
3. Marcar bloqueos en la sección correspondiente
```

> 💡 **Tip:** Si trabajás desde Obsidian, abrí `Gestión/Tablero_Principal.md`
> para ver el kanban interactivo donde podés:
> - Arrastrar tarjetas entre columnas
> - Marcar tareas como completadas
> - Agregar nuevas tareas

---

## 📁 Archivos de Gestión

| Archivo | Qué contiene | Cuándo usarlo |
|---------|-------------|---------------|
| `Gestión/Tablero_Principal.md` | Kanban interactivo con tareas por fase | Cada vez que avanzás una tarea |
| `Gestión/Hitos.md` | 8 hitos con fechas y dependencias + cronograma semanal | Para ver el panorama general |
| `Gestión/Plan_de_Trabajo.md` | 35 tareas detalladas con estimaciones | Cuando necesitás saber exactamente qué hacer |
| `Gestión/Progreso.md` | Dashboard Dataview (solo funciona en Obsidian) | Cuando abrís Obsidian y querés ver progreso animado |
| **`Gestión/Planificacion.md`** ← este archivo | Workflow + estado actual + links rápidos | Referencia permanente de cómo gestionar el proyecto |
| `Gestión/Consultas.md` | Registro de consultas al profesor | Cuando necesitás anotar o revisar una consulta |
| `Requerimientos.md` | 5 RF + 6 RP con criterios de aceptación y referencias | Para verificar que el sistema cumple los requisitos |

---

## 📊 Estado del Proyecto

> **Última actualización:** 3 Jun 2026
> **Semana actual:** S1 (28 May — 3 Jun) — Fundación → Modelado de Planta

### Progreso por fase

| Fase | Tareas | Progreso | % | Hito | Estado |
|------|--------|----------|---|------|--------|
| 🟢 **H0: Fundación** | — | ██████████ | 100% | ✅ 31 May | 🟢 Completado |
| 🔵 **F1: Modelado de Planta** | 0/7 | ░░░░░░░░░░ | 0% | H1 — 10 Jun | ⏳ En curso |
| 🟡 **F2: Sensores y Actuadores** | 0/7 | ░░░░░░░░░░ | 0% | H2 — 18 Jun | 📅 Pendiente |
| 🔵 **F3: Controlador y EKF** | 0/7 | ░░░░░░░░░░ | 0% | H3 — 30 Jun | 📅 Pendiente |
| 🟡 **F4: Simulación y Validación** | 0/7 | ░░░░░░░░░░ | 0% | H4 — 7 Jul | 📅 Pendiente |
| 🟣 **F5: Informe** | 0/9 | ░░░░░░░░░░ | 0% | H5 — 15 Jul | 📅 Pendiente |
| ⬜ **Buffer** | — | ░░░░░░░░░░ | — | H6 — 17-19 Jul | 📅 Pendiente |
| | | | | | |
| **Total** | **0/37** | ░░░░░░░░░░ | **0%** | | |

### Hitos y cuenta regresiva

| Hito | Fecha | Días rest | Estado | Depende de |
|------|-------|-----------|--------|-----------|
| ✅ **H0 — Fundación** | 31 May | — | 🟢 **COMPLETADO** | — |
| ⏳ **H1 — Modelo dinámico validado** | 10 Jun | **7 días** | 🟡 En curso | H0 |
| 📅 **H2 — Sensores y actuadores** | 18 Jun | 15 días | 🔵 Pendiente | H1 |
| 📅 **H3 — Controlador + EKF funcional** | 30 Jun | 27 días | 🔵 Pendiente | H2 |
| 📅 **H4 — Simulación final completa** | 7 Jul | 34 días | 🔵 Pendiente | H3 |
| 📅 **H5 — Informe listo** | 15 Jul | 42 días | 🔵 Pendiente | H4 |
| 📅 **H6 — Entrega final** | 17-19 Jul | 44-46 días | 🔵 Pendiente | H5 |

### Cronograma semanal

```
S1 (28 May — 3 Jun) ── H0 ✅ ──► H1 ⏳
S2 ( 4 Jun — 10 Jun) ── H1 ──► H2
S3 (11 Jun — 17 Jun) ── H2
S4 (18 Jun — 24 Jun) ── H2 ──► H3
S5 (25 Jun —  1 Jul) ── H3
S6 ( 2 Jul —  8 Jul) ── H3 ──► H4
S7 ( 9 Jul — 15 Jul) ── H4 ──► H5
S8 (16 Jul — 19 Jul) ── H5 ──► H6     ← Entrega
```

### ✅ Checklist de verificación de requerimientos

| # | Requisito | Estado | Evidencia |
|---|-----------|--------|-----------|
| 1 | RF1: Hovering estabilizado | ☐ | Plot posición vs. tiempo |
| 2 | RF2: Seguimiento de trayectoria | ☐ | Plot trayectoria 3D + error |
| 3 | RF3: Control con EKF | ☐ | Comparación estados reales vs. estimados |
| 4 | RF4: Rechazo a perturbaciones | ☐ | Plot con corriente inyectada |
| 5 | RF5: Controlador discretizado | ☐ | Comparación continuo vs. discreto |
| 6 | RP1: Error estacionario < 2% | ☐ | Tabla de métricas por eje |
| 7 | RP2: Settling time < 30 s | ☐ | Tabla de métricas |
| 8 | RP3: Sobrepico < 15% | ☐ | Tabla de métricas |
| 9 | RP4: Error EKF < σ sensor | ☐ | RMSE de estimación |
| 10 | RP5: Sin saturación permanente | ☐ | Plot de actuadores |
| 11 | RP6: Error bajo corriente < 5% | ☐ | Plot con perturbación |

---

## 🟢 Lo completado hasta ahora (H0 ✅)

- [x] `AGENTS.md` creado con layout, herramientas, build commands, gotchas
- [x] Obsidian configurado: app.json, plugins (Dataview, Kanban, REST API)
- [x] `Gestión/Hitos.md` — 8 hitos retroplanificados
- [x] `Gestión/Plan_de_Trabajo.md` — 5 fases con 35 tareas
- [x] `Gestión/Tablero_Principal.md` — Kanban con 6 columnas
- [x] `Gestión/Progreso.md` — Dashboard Dataview
- [x] `Plantillas/Daily.md` — Template de nota diaria
- [x] `Requerimientos.md` — 5 RF + 6 RP con criterios de aceptación y 12 referencias
- [x] `Informe/Plantilla_Informe.typ` — Template de informe que compila (212 KB)
- [x] `Informe/refs.bib` — 12 referencias en BibTeX
- [x] `Investigación/Fuentes/Parametros_LoLo.md` — Parámetros físicos consolidados
- [x] `Simulink/` — Estructura de carpetas lista (6 subcarpetas + resultados)
- [x] `git-session-commit.sh` — Script de commit

---

## 📌 Consultas al Profesor

Ver → [[Consultas]]

Para agregar una consulta nueva desde la terminal:

```bash
bash Proyecto\ Final/consultas.sh
```

El asistente te pide tema, contexto y pregunta. Luego abre el archivo en VSCode donde podés pegar (Ctrl+V) capturas de pantalla directamente en la tarjeta.

---

## 🔗 Links Rápidos

| Documento | Ruta relativa |
|-----------|---------------|
| 📋 Requerimientos | `Requerimientos.md` |
| 📋 Hitos | `Gestión/Hitos.md` |
| 📋 Plan de Trabajo | `Gestión/Plan_de_Trabajo.md` |
| 📋 Kanban | `Gestión/Tablero_Principal.md` |
| 📊 Dashboard (Obsidian) | `Gestión/Progreso.md` |
| 💬 Consultas al profesor | `Gestión/Consultas.md` |
| 📄 Plantilla de Informe | `Informe/Plantilla_Informe.typ` |
| 📚 Referencias BibTeX | `Informe/refs.bib` |
| ⚙️ Parámetros LoLo | `Investigación/Fuentes/Parametros_LoLo.md` |
| 📁 Simulink — Planta | `Simulink/01_PlantModel/` |
| 📁 Simulink — Sensores | `Simulink/02_Sensors/` |
| 📁 Simulink — Actuadores | `Simulink/03_Actuators/` |
| 📁 Simulink — Controlador | `Simulink/04_Controller/` |
| 📁 Simulink — EKF | `Simulink/05_EKF/` |
| 📁 Simulink — Escenarios | `Simulink/06_Scenarios/` |
| 📁 Anteproyecto | `Investigación/Anteproyecto_Control_y_Sistemas_BORQUEZ_v2.pdf` |
| 🚀 Script de commit | `git-session-commit.sh` |
| 💬 Script de consultas | `consultas.sh` |
| 🤖 Instrucciones para IA | `AGENTS.md` |

---

## 📐 Templates Disponibles

| Template | Ruta | Descripción |
|----------|------|-------------|
| 📝 Daily.md | `Plantillas/Daily.md` | Template para nota diaria (con sección de consultas al profesor) |

---

> ⚠️ **Nota:** Este archivo se actualiza manualmente. Cuando completés una tarea o un hito,
> actualizá los contadores de la sección 📊 Estado del Proyecto.

---

<!-- ============================================================ -->
<!-- BLOQUE DATAVIEW (solo funciona en Obsidian)                   -->
<!-- Descomentar las líneas de abajo si se usa dentro de Obsidian  -->
<!-- ============================================================ -->
<!--

```dataviewjs
const phases = [
  { name: "H0: Fundación",     fases: [],                  hitos: "✅ 31 May", color: "#22C55E" },
  { name: "F1: Modelado Planta", fases: ["fase1"],         hitos: "H1 — 10 Jun", color: "#3B82F6" },
  { name: "F2: Sensores y Act.", fases: ["fase2"],         hitos: "H2 — 18 Jun", color: "#F59E0B" },
  { name: "F3: Controlador EKF", fases: ["fase3"],         hitos: "H3 — 30 Jun", color: "#3B82F6" },
  { name: "F4: Simulación",      fases: ["fase4"],         hitos: "H4 — 7 Jul",  color: "#F59E0B" },
  { name: "F5: Informe",         fases: ["fase5"],         hitos: "H5 — 15 Jul", color: "#8B5CF6" },
];

const kanban = dv.page("Gestión/Tablero_Principal");
const content = kanban ? kanban.content : "";
let currentPhase = "";
const taskCounts = {};
phases.forEach(p => { taskCounts[p.name] = { total: 0, done: 0 }; });

for (const line of (content || "").split("\n")) {
  const m = line.match(/^## .*Fase (\d)/);
  if (m) {
    const idx = parseInt(m[1]) - 1;
    if (phases[idx + 1]) currentPhase = phases[idx + 1].name;
    continue;
  }
  if (currentPhase && taskCounts[currentPhase]) {
    if (line.match(/^- \[ \]/)) taskCounts[currentPhase].total++;
    else if (line.match(/^- \[x\]/)) { taskCounts[currentPhase].total++; taskCounts[currentPhase].done++; }
  }
}

let rows = [];
for (const p of phases) {
  const c = taskCounts[p.name] || { total: 0, done: 0 };
  const pct = c.total > 0 ? Math.round(c.done / c.total * 100) : (p.name === "H0: Fundación" ? 100 : 0);
  rows.push([p.name, `${c.done}/${c.total}`, `${pct}%`, p.hitos]);
}
dv.table(["Fase", "Tareas", "%", "Hito"], rows);
```

-->
