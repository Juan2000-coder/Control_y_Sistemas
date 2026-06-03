# Revisión Semanal — {{date:YYYY-ww}}

**Semana:** {{date:YYYY-MM-dd}} al {{date:+6days:YYYY-MM-dd}}

## 📊 Progreso esta semana

```dataviewjs
// Cuenta tareas completadas esta semana
const kanban = dv.page("Gestión/Tablero_Principal");
if (kanban) {
  const lines = kanban.content.split("\n");
  let done = 0, total = 0;
  for (const line of lines) {
    if (line.match(/^- \[ \]/)) total++;
    else if (line.match(/^- \[x\]/)) { total++; done++; }
  }
  dv.paragraph(`Progreso: ${done}/${total} (${Math.round(done/total*100)}%)`);
}
```

## ✅ Logros de la semana
- 

## ⚠️ Bloqueos / Riesgos
- 

## 🎯 Plan para próxima semana
- [ ] 

---
**Tags:** #weekly
