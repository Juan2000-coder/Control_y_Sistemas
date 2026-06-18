# Control_y_Sistemas — AGENTS.md

Course repository for "Control y Sistemas" (Control Systems), Facultad de Ingeniería, UNCuyo. Student: Juan Borquez. No README exists.

## What this is

Lecture materials, practical exercises (Trabajos Prácticos), exam prep, and an **integrative final project** for a digital control systems course covering Z-transform, fixed/floating-point, DSP, FIR/IIR, Simscape modeling, PID, LQR, state estimation, and Kalman filtering.

## Layout

```
01-11 Unidad_*/      → theory (PDF) + practice (MATLAB/C/Simulink)
Parcial1_estudiacion/     → exam 1 prep (MATLAB utilities)
Paricla2_estudiacion/     → exam 2 prep (note the typo in dirname)
Proyecto_Final/           → final project: Maribot LoLo AUV
  README.md               → entry point (link to Gestión/Plan.html)
  consultas.sh            → interactive consultation logger
  Plan.sh                 → opens Plan.html in Windows browser
  Adjuntos/               → screenshots pasted from Consultas.md (Ctrl+V in VSCode)
  Gestión/
    Plan.html             → THE management file (interactive HTML dashboard)
    Consultas.md          → professor Q&A log (appended by consultas.sh)
  Informe/
    Plantilla_Informe.typ → Typst report template
    refs.bib              → 12 BibTeX references
    Etapa_1_modelado.md   → stage summary template
  Investigación/
    Anteproyecto_*.pdf    → pre-project scope
    Fuentes/
      Parametros_LoLo.md  → physical parameters (mass, inertia, damping, thrusters)
      Pibardos/           → 3 prior student reports (Salazar, Escobar, Dalessandro)
      ... (reference PDFs)
  Simulink/
    01_PlantModel/ 02_Sensors/ 03_Actuators/
    04_Controller/ 05_EKF/ 06_Scenarios/ resultados/
    → all empty placeholders, ready for implementation
```

## Final project (active)

- **Plant**: Maribot LoLo AUV (KTH SMaRC), 6-DOF, 7 actuators (2 rudders, 2 elevons, 1 elevator, 2 BLDC thrusters), VBS
- **Control**: LQR with gain scheduling (linearization at multiple operating points), EKF for sensor fusion (AHRS, DVL, Altimeter, INS)
- **Requirements**: `Proyecto_Final/Requerimientos.md` — 5 functional + 6 performance requirements with acceptance criteria
- **Management**: `Proyecto_Final/Gestión/Plan.html` — interactive HTML dashboard (open in browser or via `bash Proyecto_Final/Gestión/Plan.sh`)
- **Report templates**: See `Proyecto_Final/Investigación/Fuentes/Pibardos/` (3 prior reports in PDF)
- **Pre-project scope**: `Investigación/Anteproyecto_Control_y_Sistemas_BORQUEZ_v2.pdf`
- **Key parameters**: `Investigación/Fuentes/Parametros_LoLo.md` (mass, inertia, damping, actuator models from Holm thesis)

## Languages & tools

| Tool | Where |
|---|---|
| MATLAB/Simulink | Primary — all units, `.m`/`.mlx`/`.slx` |
| C | Units 2,3,5,6 — fixed-point, IEEE 754, FIR/IIR with MEX wrappers |
| HTML/CSS/JS (browser) | Project management in `Plan.html` |
| Bash | Toolbelt: `consultas.sh`, `Plan.sh`, `git-session-commit.sh` |
| Typst | Report authoring in `Proyecto_Final/Informe/Plantilla_Informe.typ` |

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
- `Proyecto_Final/` uses underscore, not space (was renamed from `Proyecto Final/`)
- `.obsidian/` and `Plantillas/` were removed — management is via `Plan.html` (browser), not Obsidian
- Git history is minimal, no branching convention
- Filter coefficient headers (`fdacoefs.h`) are auto-generated from MATLAB Filter Designer
- Theory PDFs follow the naming `Control_y_Sistemas___Unidad_X.pdf`
- No CI, no pre-commit hooks, no linters
- Password `etdJ2b;kk,Zgc` has been used for sudo installs (poppler-utils, typst, jq)
