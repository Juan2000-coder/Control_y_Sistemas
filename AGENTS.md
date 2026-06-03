# Control_y_Sistemas — AGENTS.md

Course repository for "Control y Sistemas" (Control Systems), Facultad de Ingeniería, UNCuyo. Student: Juan Borquez. No README exists.

## What this is

Lecture materials, practical exercises (Trabajos Prácticos), exam prep, and an **integrative final project** for a digital control systems course covering Z-transform, fixed/floating-point, DSP, FIR/IIR, Simscape modeling, PID, LQR, state estimation, and Kalman filtering.

## Layout

```
01-11 Unidad_*/      → theory (PDF) + practice (MATLAB/C/Simulink)
Parcial1_estudiacion/     → exam 1 prep (MATLAB utilities)
Paricla2_estudiacion/     → exam 2 prep (note the typo in dirname)
Proyecto Final/           → final project: Maribot LoLo AUV
  Investigación/          → reference papers, anteproyecto, example reports (Pibardos/)
  Gestión/                → project management (kanban, milestones, workflow, consultations)
    Tablero_Principal.md  → Obsidian kanban (35 tasks, 6 phases)
    Planificacion.md      → workflow + project status dashboard (THIS FILE)
    Consultas.md          → professor Q&A log
    Hitos.md              → 8 milestones with dates & dependencies
    Plan_de_Trabajo.md    → 35 detailed tasks with estimates
    Progreso.md           → Dataview dashboard (Obsidian only)
  Plantillas/             → Daily.md template (note with consultation section)
  Informe/                → report stage drafts (Typst template + BibTeX)
```

## Final project (active)

- **Plant**: Maribot LoLo AUV (KTH SMaRC), 6-DOF, 7 actuators (2 rudders, 2 elevons, 1 elevator, 2 BLDC thrusters), VBS
- **Control**: LQR with gain scheduling (linearization at multiple operating points), EKF for sensor fusion (AHRS, DVL, Altimeter, INS)
- **Requirements**: `Proyecto Final/Requerimientos.md` — 5 functional + 6 performance requirements with acceptance criteria
- **Report templates**: See `Proyecto Final/Investigación/Fuentes/Pibardos/` (3 prior reports in PDF)
- **Pre-project scope**: `Investigación/Anteproyecto_Control_y_Sistemas_BORQUEZ_v2.pdf`
- **Key parameters**: `Investigación/Fuentes/Parametros_LoLo.md` (mass, inertia, damping, actuator models from Holm thesis)

## Languages & tools

| Tool | Where |
|---|---|
| MATLAB/Simulink | Primary — all units, `.m`/`.mlx`/`.slx` |
| C | Units 2,3,5,6 — fixed-point, IEEE 754, FIR/IIR with MEX wrappers |
| Obsidian | Project management (kanban in `Gestión/Tablero_Principal.md`, dashboard at `Gestión/Progreso.md`) |
| Typst | Report authoring in `Proyecto Final/Informe/Plantilla_Informe.typ` |

## Build commands

**C code** (no Makefiles, no CMake):
- Fixed-point: `gcc -g -o <out> <src>.c`
- Floating-point: `gcc -Wall -std=c99 -O3 -lm -march=corei7 -frounding-math -fsignaling-nans <src>.c`
- MEX wrappers (needs MATLAB): `mex fir_wrapper.c fir_filter.c` / `mex iir_wrapper.c iir_filter.c`
- Exact presets in `.vscode/tasks.json` under Unidad 2 and 3

**MATLAB/Simulink**: open `.m`/`.mlx` and run; Simulink via `sim()` or UI.

## Testing

No test framework. This is a course exercise repo — "testing" is running scripts and inspecting output/plots.

## Gotchas

- `Documentos de la Asignatura/` and `Libros/` are **gitignored** (large PDFs present locally, not tracked)
- `*.exe` is gitignored (compiled C binaries)
- `Paricla2_estudiacion/` — dirname has a typo, not `Parcial2`
- Git history is minimal (5 commits), no branching convention
- Filter coefficient headers (`fdacoefs.h`) are auto-generated from MATLAB Filter Designer
- Theory PDFs follow the naming `Control_y_Sistemas___Unidad_X.pdf`
- No CI, no pre-commit hooks, no linters
