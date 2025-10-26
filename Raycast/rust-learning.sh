#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Rust Learning
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🦀
# @raycast.packageName Learning
# @raycast.author NotMinimal
# Ruta de tu vault de Obsidian
VAULT_PATH="$HOME//Library/Mobile Documents/iCloud~md~obsidian/Documents/Computer-Science"
FILE="$VAULT_PATH/Rust/RustLearning.md"

# Pide input al usuario (AppleScript nativo)
ENTRY=$(osascript -e 'display dialog "Nuevo aprendizaje Rust:" default answer "Ej: Entendí cómo funcionan los lifetimes" with title "Rust Learning" buttons {"OK"} default button 1' -e 'text returned of result')

# Verifica que haya algo escrito
if [ -z "$ENTRY" ]; then
  osascript -e 'display notification "Entrada vacía. Nada guardado." with title "Rust Log"'
  exit 0
fi

# Fecha y hora actual
DATE=$(date "+%Y-%m-%d %H:%M")

# Agrega la entrada al archivo
echo "- [$DATE] $ENTRY" >> "$FILE"

# Notificación final
osascript -e 'display notification "Aprendizaje guardado en Obsidian ✅" with title "Rust Log"'
