# 📊 Dashboard de Progreso

```dataviewjs
const phaseColors = {
  "Fase 1": "#3B82F6",
  "Fase 2": "#F59E0B",
  "Fase 3": "#3B82F6",
  "Fase 4": "#F59E0B",
  "Fase 5": "#8B5CF6"
};

const phases = [
  { name: "Fase 1: Modelado de Planta", tag: "fase1", hitos: "H1 — 10 Jun", color: "#3B82F6" },
  { name: "Fase 2: Sensores y Actuadores", tag: "fase2", hitos: "H2 — 18 Jun", color: "#F59E0B" },
  { name: "Fase 3: Controlador y EKF", tag: "fase3", hitos: "H3 — 30 Jun", color: "#3B82F6" },
  { name: "Fase 4: Simulación y Validación", tag: "fase4", hitos: "H4 — 7 Jul", color: "#F59E0B" },
  { name: "Fase 5: Informe", tag: "fase5", hitos: "H5 — 15 Jul", color: "#8B5CF6" },
];

const kanbanFile = dv.page("Gestión/Tablero_Principal");
const content = kanbanFile ? kanbanFile.content : "";

if (!content) {
  dv.paragraph("❌ No se pudo leer el kanban. Verificá que exista Gestión/Tablero_Principal.md");
} else {
  const lines = content.split("\n");
  let currentPhase = "";
  const taskCounts = {};
  phases.forEach(p => { taskCounts[p.name] = { total: 0, done: 0 }; });

  for (const line of lines) {
    const phaseMatch = line.match(/^## .*Fase (\d)/);
    if (phaseMatch) {
      const idx = parseInt(phaseMatch[1]) - 1;
      if (phases[idx]) currentPhase = phases[idx].name;
      continue;
    }
    if (currentPhase && taskCounts[currentPhase]) {
      if (line.match(/^- \[ \]/)) taskCounts[currentPhase].total++;
      else if (line.match(/^- \[x\]/)) { taskCounts[currentPhase].total++; taskCounts[currentPhase].done++; }
    }
  }

  let globalTotal = 0, globalDone = 0;
  let tableRows = [];

  for (const phase of phases) {
    const c = taskCounts[phase.name] || { total: 0, done: 0 };
    globalTotal += c.total; globalDone += c.done;
    const pct = c.total > 0 ? Math.round(c.done / c.total * 100) : 0;
    const bar = "█".repeat(Math.floor(pct / 10)) + "░".repeat(10 - Math.ceil(pct / 10));
    tableRows.push([phase.name, `${bar}`, `${c.done}/${c.total}`, `${pct}%`, phase.hitos]);
  }

  dv.header(2, "📈 Progreso General");
  const totalPct = globalTotal > 0 ? Math.round(globalDone / globalTotal * 100) : 0;
  const bar = "█".repeat(Math.floor(totalPct / 10)) + "░".repeat(10 - Math.ceil(totalPct / 10));
  dv.paragraph(`**Total:** ${bar} ${globalDone}/${globalTotal} (${totalPct}%)`);

  dv.table(["Fase", "Progreso", "Hechas", "%", "Hito"], tableRows);

  dv.header(3, "⏰ Hitos próximos");
  const today = new Date();
  const milestones = [
    { name: "H1 — Modelo dinámico validado", date: "2026-06-10", done: globalDone >= 7 },
    { name: "H2 — Sensores y actuadores completos", date: "2026-06-18" },
    { name: "H3 — Controlador + EKF funcional", date: "2026-06-30" },
    { name: "H4 — Simulación final completa", date: "2026-07-07" },
    { name: "H5 — Informe listo", date: "2026-07-15" },
    { name: "H6 — Entrega final", date: "2026-07-17" },
  ];

  for (const m of milestones) {
    const mDate = new Date(m.date);
    const diff = Math.ceil((mDate - today) / (1000 * 60 * 60 * 24));
    const status = m.done ? "✅" : diff < 0 ? "❌" : diff <= 7 ? "⚠️" : "📅";
    const label = m.done ? `${status} ${m.name} — COMPLETADO` :
      diff < 0 ? `${status} ${m.name} — VENCIDO hace ${-diff} días` :
      diff === 0 ? `${status} ${m.name} — VENCE HOY` :
      `${status} ${m.name} — ${diff} días`;
    dv.paragraph(label);
  }
}
```

## ✅ Checklist rápido de estado

- [ ] ¿Arranqué hoy mi daily note?
- [ ] ¿Avancé al menos una tarea?
- [ ] ¿Actualicé el kanban?
- [ ] ¿Guardé y commiteé al finalizar?

---

*Última actualización: {{date:YYYY-MM-DD HH:mm}}*
