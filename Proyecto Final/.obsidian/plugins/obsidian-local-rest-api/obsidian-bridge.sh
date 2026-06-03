#!/bin/bash
# obsidian-bridge.sh — Interactúa con el vault Obsidian vía Local REST API
# Uso: ./obsidian-bridge.sh <comando> [args]
# Comandos: list, read, write, search, template

VAULT_PATH="/mnt/c/Users/juan/Documents/UNCUYO/Control_y_Sistemas/Proyecto Final"
API_PORT=27124
API_KEY="7f0c2475f1ff8834b14bc7261fbf8390f11cbcf96048a2d2c1a530487b199eaa"
API_BASE="https://localhost:$API_PORT"

case "$1" in
  list)
    curl -sk -H "Authorization: Bearer $API_KEY" "$API_BASE/vault/" | jq .
    ;;
  read)
    curl -sk -H "Authorization: Bearer $API_KEY" "$API_BASE/vault/$2" | jq .
    ;;
  search)
    curl -sk -H "Authorization: Bearer $API_KEY" "$API_BASE/search/simple?query=$2" | jq .
    ;;
  template)
    curl -sk -X POST -H "Authorization: Bearer $API_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"template\": \"$2\", \"folder\": \"${3:-Diario}\"}" \
      "$API_BASE/note/from-template" | jq .
    ;;
  status)
    curl -sk -H "Authorization: Bearer $API_KEY" "$API_BASE/" | jq .
    ;;
  *)
    echo "Uso: $0 {list|read <path>|search <q>|template <name> [folder]|status}"
    echo ""
    echo "  list         — Lista todos los archivos del vault"
    echo "  read <path>  — Lee el contenido de un archivo"
    echo "  search <q>   — Busca texto en el vault"
    echo "  template <n> — Crea nota desde plantilla (ej: Daily.md)"
    echo "  status       — Verifica conexión con el API"
    exit 1
    ;;
esac
