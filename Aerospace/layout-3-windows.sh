#!/bin/bash

# Script para organizar 3+ ventanas en AeroSpace
# Layout: 1 ventana grande a la izquierda, 2+ ventanas apiladas a la derecha

# Obtener el workspace actual
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

# Contar ventanas en el workspace actual
WINDOW_COUNT=$(aerospace list-windows --workspace "$CURRENT_WORKSPACE" | wc -l | tr -d ' ')

echo "Workspace actual: $CURRENT_WORKSPACE"
echo "Número de ventanas: $WINDOW_COUNT"

if [ "$WINDOW_COUNT" -lt 3 ]; then
    echo "Se necesitan al menos 3 ventanas para este layout"
    osascript -e 'display notification "Se necesitan al menos 3 ventanas" with title "AeroSpace Layout"'
    exit 1
fi

# Flatten todo para empezar desde cero
aerospace flatten-workspace-tree --workspace "$CURRENT_WORKSPACE"
sleep 0.15

# Obtener lista de IDs de ventanas en orden
WINDOW_IDS=($(aerospace list-windows --workspace "$CURRENT_WORKSPACE" --format "%{window-id}"))

# Verificar que tenemos al menos 3 ventanas
if [ ${#WINDOW_IDS[@]} -lt 3 ]; then
    echo "Error: No se pudieron obtener las ventanas"
    exit 1
fi

# Enfocar la primera ventana (será la ventana grande de la izquierda)
aerospace focus --window-id "${WINDOW_IDS[0]}"
sleep 0.1

# Enfocar la segunda ventana
aerospace focus --window-id "${WINDOW_IDS[1]}"
sleep 0.1

# Enfocar la tercera ventana y unirla con la segunda (hacia arriba)
aerospace focus --window-id "${WINDOW_IDS[2]}"
sleep 0.1
aerospace join-with up
sleep 0.1

# Si hay más de 3 ventanas, unir las restantes en la columna derecha
for ((i=3; i<${#WINDOW_IDS[@]}; i++)); do
    aerospace focus --window-id "${WINDOW_IDS[$i]}"
    sleep 0.1
    aerospace join-with up
    sleep 0.1
done

# Enfocar de nuevo la primera ventana (la grande de la izquierda)
aerospace focus --window-id "${WINDOW_IDS[0]}"
sleep 0.1

# Balancear los tamaños
aerospace balance-sizes

echo "✓ Layout aplicado exitosamente"
echo "  - 1 ventana grande a la izquierda"
echo "  - $((WINDOW_COUNT - 1)) ventana(s) apiladas a la derecha"

osascript -e 'display notification "Layout aplicado: 1 izq + '"$((WINDOW_COUNT - 1))"' der" with title "AeroSpace Layout"'
