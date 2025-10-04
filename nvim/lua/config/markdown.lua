-- Configuración específica para Markdown y PKM con markdown-oxide
local M = {}

-- Configuración de autocomandos para archivos Markdown
function M.setup()
  local augroup = vim.api.nvim_create_augroup("MarkdownConfig", { clear = true })

  -- Configuración específica para archivos Markdown
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      local opts = { buffer = bufnr, silent = true }

      -- Configuraciones de buffer específicas para Markdown
      vim.bo[bufnr].textwidth = 80
      vim.bo[bufnr].wrap = true
      vim.bo[bufnr].linebreak = true
      vim.bo[bufnr].conceallevel = 2
      vim.wo.spell = true
      vim.wo.spelllang = "en,es"

      -- Keymaps específicos para PKM con markdown-oxide

      -- Navegación de enlaces y referencias
      vim.keymap.set("n", "<leader>ml", function()
        require("telescope.builtin").lsp_references()
      end, vim.tbl_extend("force", opts, { desc = "Find Markdown Links & References" }))

      -- Búsqueda de símbolos en el documento
      vim.keymap.set("n", "<leader>ms", function()
        require("telescope.builtin").lsp_document_symbols()
      end, vim.tbl_extend("force", opts, { desc = "Markdown Document Symbols" }))

      -- Búsqueda de símbolos en el workspace
      vim.keymap.set("n", "<leader>mS", function()
        require("telescope.builtin").lsp_workspace_symbols()
      end, vim.tbl_extend("force", opts, { desc = "Markdown Workspace Symbols" }))

      -- Ir a definición (para enlaces internos)
      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
      end, vim.tbl_extend("force", opts, { desc = "Go to Definition/Link" }))

      -- Hover para mostrar información de enlaces
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
      end, vim.tbl_extend("force", opts, { desc = "Show Link/Reference Info" }))

      -- Code lens para mostrar contadores de referencias
      vim.keymap.set("n", "<leader>mc", function()
        vim.lsp.codelens.run()
      end, vim.tbl_extend("force", opts, { desc = "Run Markdown Code Lens" }))

      -- Refrescar code lens
      vim.keymap.set("n", "<leader>mC", function()
        vim.lsp.codelens.refresh()
      end, vim.tbl_extend("force", opts, { desc = "Refresh Code Lens" }))

      -- Completado de enlaces y referencias
      vim.keymap.set("i", "[[", function()
        -- Activar completado manual para enlaces wiki-style
        vim.schedule(function()
          vim.lsp.buf.completion()
        end)
        return "[["
      end, vim.tbl_extend("force", opts, { desc = "Wiki Link Completion", expr = true }))

      -- Formatear documento
      vim.keymap.set("n", "<leader>mf", function()
        vim.lsp.buf.format({ async = true })
      end, vim.tbl_extend("force", opts, { desc = "Format Markdown Document" }))

      -- Acciones de código (para refactoring de enlaces)
      vim.keymap.set("n", "<leader>ma", function()
        vim.lsp.buf.code_action()
      end, vim.tbl_extend("force", opts, { desc = "Markdown Code Actions" }))

      -- Rename (para renombrar archivos y actualizar referencias)
      vim.keymap.set("n", "<leader>mr", function()
        vim.lsp.buf.rename()
      end, vim.tbl_extend("force", opts, { desc = "Rename File/Update References" }))

      -- Búsqueda de texto en archivos markdown del workspace
      vim.keymap.set("n", "<leader>mt", function()
        require("telescope.builtin").live_grep({
          type_filter = "markdown",
          additional_args = { "--type", "md" }
        })
      end, vim.tbl_extend("force", opts, { desc = "Search Text in Markdown Files" }))

      -- Navegación rápida de archivos markdown
      vim.keymap.set("n", "<leader>mF", function()
        require("telescope.builtin").find_files({
          find_command = { "rg", "--files", "--type", "md" }
        })
      end, vim.tbl_extend("force", opts, { desc = "Find Markdown Files" }))
    end,
  })

  -- Auto-refresh code lens para archivos markdown
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    pattern = "*.md",
    group = augroup,
    callback = function()
      -- Solo refrescar si hay un client LSP activo
      local clients = vim.lsp.get_active_clients({ name = "markdown_oxide" })
      if #clients > 0 then
        vim.lsp.codelens.refresh()
      end
    end,
  })

  -- Configurar folding para markdown
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = augroup,
    callback = function()
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
      vim.wo.foldenable = false -- Empezar con todo desplegado
    end,
  })

  -- Configuración para crear notas diarias automáticamente
  vim.api.nvim_create_user_command("MarkdownDailyNote", function()
    local date = os.date("%Y-%m-%d")
    local filename = string.format("daily-%s.md", date)
    local notes_dir = vim.fn.expand("~/Documents/Notes") -- Ajustar según tu estructura

    -- Crear directorio si no existe
    vim.fn.mkdir(notes_dir, "p")

    local filepath = string.format("%s/%s", notes_dir, filename)

    -- Abrir o crear la nota diaria
    vim.cmd(string.format("edit %s", filepath))

    -- Si es un archivo nuevo, agregar template básico
    if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      local template = {
        string.format("# Daily Note - %s", date),
        "",
        "## Tasks",
        "",
        "- [ ] ",
        "",
        "## Notes",
        "",
        "",
        "",
        "## Links",
        "",
        ""
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
      vim.cmd("normal! 5G$") -- Ir al primer task
    end
  end, { desc = "Create or open daily note" })

  -- Comando para crear nueva nota con template
  vim.api.nvim_create_user_command("MarkdownNewNote", function(args)
    local title = args.args
    if title == "" then
      title = vim.fn.input("Note title: ")
    end

    if title == "" then
      return
    end

    local filename = title:lower():gsub(" ", "-") .. ".md"
    local notes_dir = vim.fn.expand("~/Documents/Notes") -- Ajustar según tu estructura

    -- Crear directorio si no existe
    vim.fn.mkdir(notes_dir, "p")

    local filepath = string.format("%s/%s", notes_dir, filename)

    -- Abrir archivo
    vim.cmd(string.format("edit %s", filepath))

    -- Agregar template básico
    if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      local template = {
        string.format("# %s", title),
        "",
        string.format("Created: %s", os.date("%Y-%m-%d %H:%M")),
        "",
        "## Overview",
        "",
        "",
        "",
        "## Details",
        "",
        "",
        "",
        "## Related",
        "",
        ""
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
      vim.cmd("normal! 7G$") -- Ir a la sección Overview
    end
  end, {
    desc = "Create new markdown note with template",
    nargs = "?",
    complete = function() return {} end
  })
end

return M
