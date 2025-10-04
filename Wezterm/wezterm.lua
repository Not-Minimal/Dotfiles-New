-- ~/.wezterm.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Entrada y composición: Option compone, sin dead keys
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.use_dead_keys = false

-- Render y rendimiento
-- WebGPU suele mejorar latencia/uso de CPU en macOS; si ves glitches, prueba "OpenGL"
config.front_end = "WebGpu"
-- Evita reflow agresivo en cada carácter; mejora estabilidad visual en panes múltiples
config.adjust_window_size_when_changing_font_size = false
-- Suaviza scroll sin saturar CPU
config.scrollback_lines = 5000
config.max_fps = 120 -- deja a 60 si prefieres menos consumo

-- Fuente con fallback y cache
config.font = wezterm.font_with_fallback({
	{ family = "Google Sans Code", weight = "Medium" },
	{ family = "MesloLGL Nerd Font" },
})
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font_size = 12.0
config.line_height = 1.10
config.cell_width = 1.10

-- Tema por apariencia del sistema con overrides seguros
local function apply_theme_by_appearance()
	local appearance = wezterm.gui.get_appearance()
	local is_dark = appearance and appearance:find("Dark")

	-- Nota: blur alto con opacidad baja puede degradar performance,
	-- ajusta valores conservadores
	if is_dark then
		config.color_scheme = "Nightfox"
		config.window_background_opacity = 0.75
		config.macos_window_background_blur = 22
		config.colors = config.colors or {}
		-- Cursor visible con buen contraste en fondo oscuro
		config.colors.cursor_bg = "#7aa2f7"
		config.colors.cursor_border = "#7aa2f7"
		config.colors.foreground = "#D8DEE9"
		config.colors.selection_bg = "#3b4252"
		config.colors.selection_fg = "#ECEFF4"
	else
		config.color_scheme = "Terafox"
		config.window_background_opacity = 0.90
		config.macos_window_background_blur = 10
		config.colors = config.colors or {}
		-- Mantén contraste de selección en tema claro
		config.colors.selection_bg = "#d8dee9"
		config.colors.selection_fg = "#2e3440"
		-- cursor azulado para visibilidad en claro
		config.colors.cursor_bg = "#1D4ED8"
		config.colors.cursor_border = "#1D4ED8"
	end
end

config.bold_brightens_ansi_colors = true
apply_theme_by_appearance()

-- Decoraciones y padding: top grande puede afectar maximizar; usa padding adaptativo
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.enable_tab_bar = false
config.window_padding = { left = 24, right = 24, top = 64, bottom = 18 }

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 700
config.animation_fps = 60
config.cursor_thickness = 2
config.hide_mouse_cursor_when_typing = true

-- Arrancar en pantalla completa del monitor activo
-- Usa geometry: screen para compatibilidad multi-monitor y espacios en macOS
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	local screen = wezterm.gui.screens().active
	local guiwin = window:gui_window()
	guiwin:set_position(screen.x, screen.y)
	guiwin:set_inner_size(screen.width, screen.height)
end)

-- Helpers para navegación por palabras consistente
-- En muchas shells, ALT+Backspace envía ESC DEL; en terminal, enviar WORD ERASE es más estable
-- Pero no todas apps interpretan lo mismo; mantenemos send_key + mods para compatibilidad
local keys = {
	-- Tilde rápida con Option+n si tu layout no la produce
	{ key = "n", mods = "OPT", action = act.SendString("~") },

	-- Alt/Option + Arrow: enviar la tecla con el modificador
	{ key = "UpArrow", mods = "ALT", action = act.SendKey({ key = "UpArrow", mods = "ALT" }) },
	{ key = "DownArrow", mods = "ALT", action = act.SendKey({ key = "DownArrow", mods = "ALT" }) },
	{ key = "LeftArrow", mods = "ALT", action = act.SendKey({ key = "LeftArrow", mods = "ALT" }) },
	{ key = "RightArrow", mods = "ALT", action = act.SendKey({ key = "RightArrow", mods = "ALT" }) },

	-- Opción/Alt + Backspace: borrar palabra hacia atrás
	{ key = "Backspace", mods = "ALT", action = act.SendKey({ key = "Backspace", mods = "ALT" }) },
	-- Opción/Alt + Delete: borrar palabra hacia adelante (útil en zsh con bindkey)
	{ key = "Delete", mods = "ALT", action = act.SendKey({ key = "Delete", mods = "ALT" }) },

	-- Navegación inicio/fin de línea con CMD + flechas
	{ key = "LeftArrow", mods = "CMD", action = act.SendKey({ key = "Home" }) },
	{ key = "RightArrow", mods = "CMD", action = act.SendKey({ key = "End" }) },

	-- Split panes
	{ key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Clear scrollback + viewport
	{ key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },

	-- Cerrar pane/tab (sin confirmación)
	{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "w", mods = "CMD|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },

	-- Activar Command Palette
	{ key = "p", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },

	-- Copiar/Pegar natural en macOS
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },

	-- Navegar panes con Option + hjkl (estilo vim) y CMD+[/] para tabs
	{ key = "h", mods = "CTRL|ALT|CMD|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL|ALT|CMD|SHIFT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL|ALT|CMD|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL|ALT|CMD|SHIFT", action = act.ActivatePaneDirection("Right") },
	{ key = "[", mods = "CTRL|ALT|CMD|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "CTRL|ALT|CMD|SHIFT", action = act.ActivateTabRelative(1) },

	-- Resize panes con ALT+SHIFT + hjkl
	{ key = "h", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "j", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 3 }) },
	{ key = "k", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 3 }) },
	{ key = "l", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },

	-- Buscar en scrollback
	{ key = "f", mods = "CMD", action = act.Search({ CaseSensitiveString = "" }) },

	-- Abrir config en editor: intenta zed, si falla usa open con $EDITOR o TextEdit
	{
		key = ",",
		mods = "CMD",
		action = act.Multiple({
			act.SpawnCommandInNewTab({
				cwd = wezterm.home_dir,
				args = {
					"bash",
					"-lc",
					[[command -v zed >/dev/null 2>&1 && zed "$WEZTERM_CONFIG_FILE" || \
          { if [ -n "$EDITOR" ]; then "$EDITOR" "$WEZTERM_CONFIG_FILE"; else open -a TextEdit "$WEZTERM_CONFIG_FILE"; fi; }]],
				},
			}),
		}),
	},
}

config.keys = keys

-- Opcional: status bar minimalista con nombre de host y cwd
config.status_update_interval = 1000
wezterm.on("update-status", function(window, pane)
	local cwd = pane:get_current_working_dir()
	local cwd_path = ""
	if cwd then
		cwd_path = cwd.file_path or ""
		-- Abrevia $HOME por ~
		local home = wezterm.home_dir
		if home and cwd_path:find(home, 1, true) == 1 then
			cwd_path = "~" .. cwd_path:sub(#home + 1)
		end
	end
	local hostname = wezterm.hostname()
	window:set_right_status(wezterm.format({
		{ Text = " " .. hostname .. " " },
		{ Foreground = { Color = "#7aa2f7" } },
		{ Text = cwd_path .. " " },
	}))
end)

return config
