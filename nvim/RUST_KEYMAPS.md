# Guía de Atajos de Teclado para Rust en Neovim

Esta guía contiene todos los atajos de teclado (keymaps) configurados para trabajar con Rust en tu Neovim.

## 📋 Tabla de Contenidos
- [Acciones de Código](#acciones-de-código)
- [Ejecutar y Depurar](#ejecutar-y-depurar)
- [Navegación](#navegación)
- [Gestión de Dependencias (Cargo.toml)](#gestión-de-dependencias-cargotoml)
- [Atajos LSP Estándar](#atajos-lsp-estándar)

---

## 🔧 Acciones de Código

| Atajo | Descripción |
|-------|-------------|
| `<leader>cR` | Abrir menú de acciones de código específicas de Rust |
| `<leader>re` | Explicar error de Rust (muestra información detallada) |
| `K` | Mostrar documentación y acciones disponibles (hover) |

> **Nota:** `<leader>` por defecto es la tecla `Espacio`

---

## 🚀 Ejecutar y Depurar

| Atajo | Descripción |
|-------|-------------|
| `<leader>rr` | Mostrar ejecutables disponibles (runnables) |
| `<leader>rt` | Ejecutar tests disponibles (testables) |
| `<leader>dr` | Abrir depurador (debuggables) |

### Ejemplo de uso:
1. Presiona `<Space>rr` para ver todos los ejecutables
2. Selecciona el que quieras ejecutar
3. El código se compilará y ejecutará

---

## 🧭 Navegación

| Atajo | Descripción |
|-------|-------------|
| `<leader>rc` | Abrir Cargo.toml |
| `<leader>rp` | Ir al módulo padre |
| `gd` | Ir a definición |
| `gr` | Ver referencias |
| `gi` | Ir a implementación |
| `gy` | Ir a definición de tipo |

---

## 📦 Gestión de Dependencias (Cargo.toml)

Estos atajos funcionan cuando estás editando un archivo `Cargo.toml`:

| Atajo | Descripción |
|-------|-------------|
| `<leader>rcu` | Actualizar crate actual (bajo el cursor) |
| `<leader>rca` | Actualizar todos los crates |
| `<leader>rcU` | Hacer upgrade del crate actual |
| `<leader>rcA` | Hacer upgrade de todos los crates |
| `<leader>rcH` | Abrir homepage del crate |
| `<leader>rcD` | Abrir documentación del crate |
| `<leader>rcR` | Abrir repositorio del crate |

### Ejemplo de uso en Cargo.toml:
1. Coloca el cursor sobre una dependencia (ej: `serde = "1.0"`)
2. Presiona `<Space>rcu` para actualizar a la última versión compatible
3. O presiona `<Space>rcU` para hacer upgrade a la última versión disponible

---

## 🔍 Atajos LSP Estándar

Estos son atajos estándar de LazyVim que también funcionan con Rust:

| Atajo | Descripción |
|-------|-------------|
| `<leader>ca` | Acciones de código (code actions) |
| `<leader>rn` | Renombrar símbolo |
| `<leader>cf` | Formatear código |
| `[d` | Ir al diagnóstico anterior |
| `]d` | Ir al siguiente diagnóstico |
| `<leader>cd` | Ver diagnósticos en ventana flotante |
| `<leader>cl` | Ver información de la línea |

---

## 💡 Características Especiales

### Inlay Hints
Rust-analyzer muestra hints en línea para:
- Tipos inferidos
- Nombres de parámetros
- Lifetimes (cuando no son triviales)

### Clippy
El proyecto está configurado para usar Clippy automáticamente, que te dará:
- Sugerencias de mejora de código
- Detección de patrones no idiomáticos
- Advertencias de rendimiento

### Autocompletado en Cargo.toml
Al editar `Cargo.toml`, obtendrás:
- Autocompletado de nombres de crates
- Sugerencias de versiones
- Información de dependencias al hacer hover

---

## 📚 Recursos Adicionales

### Comandos útiles en la terminal
```bash
# Compilar el proyecto
cargo build

# Compilar y ejecutar
cargo run

# Ejecutar tests
cargo test

# Verificar código sin compilar
cargo check

# Ejecutar clippy
cargo clippy

# Formatear código
cargo fmt
```

### Aprende Rust
- [El Libro de Rust (Español)](https://github.com/RustLangES/rust-book-es)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
- [Rustlings - Ejercicios interactivos](https://github.com/rust-lang/rustlings)

---

## 🎯 Flujo de Trabajo Recomendado

1. **Crear proyecto nuevo:**
   ```bash
   cargo new mi_proyecto
   cd mi_proyecto
   nvim .
   ```

2. **Editar código:**
   - Usa `K` para ver documentación
   - Usa `<leader>ca` para ver acciones disponibles
   - Los errores aparecerán automáticamente

3. **Ejecutar código:**
   - Presiona `<leader>rr` para ver opciones de ejecución
   - Selecciona lo que quieras ejecutar

4. **Depurar:**
   - Presiona `<leader>dr` para abrir el depurador
   - Configura breakpoints con `<leader>db`

5. **Tests:**
   - Presiona `<leader>rt` para ejecutar tests
   - Los resultados aparecerán en una ventana

---

## ⚡ Tips Rápidos

- **Autocompletado:** Simplemente empieza a escribir y presiona `Tab` o `Ctrl+Space`
- **Ver errores:** Los errores aparecen automáticamente. Usa `[d` y `]d` para navegar entre ellos
- **Formateo automático:** El código se formatea automáticamente al guardar
- **Documentación inline:** Coloca el cursor sobre cualquier función y presiona `K`

---

¡Disfruta programando en Rust! 🦀