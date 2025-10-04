# Markdown-Oxide PKM Guide for Neovim

Esta guía explica cómo usar las características de PKM (Personal Knowledge Management) con markdown-oxide en tu configuración de Neovim.

## ¿Qué es markdown-oxide?

Markdown-oxide es un Language Server Protocol (LSP) especialmente diseñado para PKM que proporciona características avanzadas para la gestión de conocimiento personal en archivos Markdown, incluyendo:

- **Referencias cruzadas**: Enlaces bidireccionales entre archivos
- **Autocompletado inteligente**: Completado de enlaces y referencias
- **Navegación**: Saltar entre archivos y secciones
- **Contadores de referencias**: Ver cuántas veces se referencia un archivo o sección
- **Refactoring**: Renombrar archivos y actualizar todas las referencias automáticamente

## Configuración

La configuración ya está instalada y lista para usar. Markdown-oxide se activará automáticamente cuando abras archivos `.md`.

## Keymaps Principales

### Navegación y Referencias

| Keymap | Modo | Descripción |
|--------|------|-------------|
| `<leader>ml` | Normal | Buscar enlaces y referencias con Telescope |
| `<leader>ms` | Normal | Símbolos del documento actual |
| `<leader>mS` | Normal | Símbolos del workspace completo |
| `gd` | Normal | Ir a definición/enlace |
| `gr` | Normal | Mostrar referencias |
| `K` | Normal | Mostrar información del enlace/referencia |

### Code Lens y Contadores

| Keymap | Modo | Descripción |
|--------|------|-------------|
| `<leader>mc` | Normal | Ejecutar Code Lens (mostrar contadores) |
| `<leader>mC` | Normal | Refrescar Code Lens |

### Edición y Refactoring

| Keymap | Modo | Descripción |
|--------|------|-------------|
| `<leader>ma` | Normal | Acciones de código |
| `<leader>mr` | Normal | Renombrar archivo/actualizar referencias |
| `<leader>mf` | Normal | Formatear documento |
| `[[` | Insert | Autocompletar enlaces wiki-style |

### Búsqueda y Archivos

| Keymap | Modo | Descripción |
|--------|------|-------------|
| `<leader>mt` | Normal | Buscar texto en archivos Markdown |
| `<leader>mF` | Normal | Buscar archivos Markdown |

### Comandos de Notas

| Comando | Descripción |
|---------|-------------|
| `:MarkdownDailyNote` | Crear o abrir nota diaria |
| `:MarkdownNewNote [título]` | Crear nueva nota con template |

## Características PKM

### 1. Enlaces Wiki-Style

Puedes crear enlaces usando la sintaxis `[[nombre-del-archivo]]` o `[[nombre-del-archivo|texto-del-enlace]]`:

```markdown
Esto es un enlace a [[mi-otra-nota]]
Esto es un enlace con texto personalizado [[mi-otra-nota|Mi Otra Nota]]
```

### 2. Referencias Automáticas

Markdown-oxide detecta automáticamente:
- Enlaces entre archivos
- Referencias a encabezados
- Tags y menciones
- Bloques de código referenciados

### 3. Code Lens (Contadores)

Los Code Lens muestran cuántas veces se referencia un archivo o sección:
- Aparecen como texto gris encima de los encabezados
- Se actualizan automáticamente
- Puedes hacer clic en ellos para ver todas las referencias

### 4. Autocompletado Inteligente

Al escribir `[[`, se activa el autocompletado que sugiere:
- Nombres de archivos existentes
- Encabezados de otros archivos
- Tags y referencias

### 5. Navegación Bidireccional

- `gd` te lleva al archivo/sección referenciada
- `gr` muestra todas las referencias a la ubicación actual
- Las referencias incluyen tanto enlaces directos como menciones indirectas

## Flujo de Trabajo PKM Recomendado

### 1. Estructura de Directorios

Organiza tus notas en una estructura clara:

```
~/Documents/Notes/
├── daily/          # Notas diarias
├── projects/       # Notas de proyectos
├── concepts/       # Conceptos y definiciones
├── resources/      # Recursos y referencias
└── archive/        # Notas archivadas
```

### 2. Convenciones de Nomenclatura

- **Archivos**: `kebab-case.md`
- **Enlaces**: `[[archivo-nombre]]`
- **Tags**: `#tag-nombre`

### 3. Templates de Notas

#### Nota Diaria
```markdown
# Daily Note - 2024-01-15

## Tasks
- [ ] Revisar [[proyecto-importante]]
- [ ] Actualizar [[notas-reunión]]

## Notes
Hoy aprendí sobre [[concepto-nuevo]]

## Links
- [[proyecto-importante]]
- [[conceptos/aprendizaje]]
```

#### Nota de Proyecto
```markdown
# Proyecto: Nombre del Proyecto

Created: 2024-01-15 10:30

## Overview
Descripción breve del proyecto

## Details
Detalles técnicos y consideraciones

## Related
- [[recurso-relevante]]
- [[otra-nota-proyecto]]
```

### 4. Uso de Code Lens

Los Code Lens te ayudan a:
- Ver qué tan popular es una nota (cuántas referencias tiene)
- Identificar notas huérfanas (sin referencias)
- Encontrar conceptos centrales en tu PKM

### 5. Refactoring Seguro

Usa `<leader>mr` para renombrar archivos. Markdown-oxide:
- Actualiza automáticamente todas las referencias
- Mantiene la integridad de los enlaces
- Preserva el texto de los enlaces personalizados

## Consejos y Trucos

### 1. Búsqueda Eficiente
- Usa `<leader>mt` para buscar conceptos específicos
- Usa `<leader>ms` para navegar rápidamente por un documento largo
- Combina con Telescope para búsquedas fuzzy

### 2. Organización
- Revisa regularmente las notas sin referencias (huérfanas)
- Usa Code Lens para identificar conceptos centrales
- Mantén consistencia en la nomenclatura

### 3. Integración con Git
- Versiona tus notas con Git
- Usa branches para experimentos de organización
- Los cambios de refactoring son seguros de commitear

## Solución de Problemas

### LSP no se inicia
1. Verifica que markdown-oxide esté instalado: `which markdown-oxide`
2. Reinicia Neovim: `:LspRestart`
3. Verifica logs: `:LspLog`

### Code Lens no aparece
1. Activa manualmente: `<leader>mc`
2. Refrescar: `<leader>mC`
3. Verifica que esté habilitado en tu configuración

### Autocompletado no funciona
1. Verifica que nvim-cmp esté instalado
2. En modo Insert, usa `<C-Space>` para activar manualmente
3. Asegúrate de que el LSP esté activo: `:LspInfo`

## Recursos Adicionales

- [Documentación oficial de markdown-oxide](https://oxide.md)
- [PKM Best Practices](https://oxide.md/docs/getting-started)
- [Configuración avanzada](https://oxide.md/docs/configuration)

---

¡Disfruta de tu nuevo sistema PKM con markdown-oxide! 🚀