#!/bin/bash
# consultas.sh
# Asistente interactivo para registrar consultas al profesor.
# Uso (desde raíz del repo): bash Proyecto\ Final/consultas.sh

set -e

CONSULTAS="Gestión/Consultas.md"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="$REPO_DIR/$CONSULTAS"
ADJ_DIR="$REPO_DIR/Adjuntos"

mkdir -p "$ADJ_DIR"

# Crear archivo si no existe
if [ ! -f "$FILE" ]; then
    cat > "$FILE" << 'EOF'
# Consultas al Profesor

> Registro de consultas al profesor.
> Uso: ejecutar `bash Proyecto\ Final/consultas.sh`

---
EOF
fi

clear
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     📋 Nueva Consulta al Profesor        ║"
echo "╚══════════════════════════════════════════╝"
echo ""

read -p "📝 Tema: " TEMA
echo ""

echo "📖 Contexto (Enter en línea vacía para terminar):"
CONTEXTO=""
while IFS= read -r line; do
    [ -z "$line" ] && break
    CONTEXTO="${CONTEXTO}${line}
"
done
echo ""

echo "❓ Pregunta (Enter en línea vacía para terminar):"
PREGUNTA=""
while IFS= read -r line; do
    [ -z "$line" ] && break
    PREGUNTA="${PREGUNTA}${line}
"
done
echo ""

NEXT_NUM=1
[ -f "$FILE" ] && NEXT_NUM=$(( $(grep -c "^## 🃏" "$FILE" 2>/dev/null || true) + 1 ))

TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

read -p "¿Guardar consulta #${NEXT_NUM}? (S/n): " CONFIRMAR || true
if [[ "$CONFIRMAR" =~ ^[nN] ]]; then
    echo "Cancelado."
    exit 0
fi

ENTRY="
---
## 🃏 #${NEXT_NUM} · ${TIMESTAMP} · ${TEMA}

📖 **Contexto:** 
${CONTEXTO}

❓ **Pregunta:** 
${PREGUNTA}

💬 **Respuesta:** 
*(pendiente)*

📎 **Adjuntos:** 
<!-- Pegá acá (Ctrl+V) las capturas de pantalla relevantes -->

**Estado:** 🔴 Pendiente
---
"

echo "$ENTRY" >> "$FILE"
echo ""
echo "✅ Consulta #${NEXT_NUM} guardada."

# Abrir archivo en VSCode para pegar imágenes (Ctrl+V)
if command -v code &> /dev/null; then
    code "$FILE"
else
    echo "Abrí el archivo para pegar imágenes: $FILE"
fi
