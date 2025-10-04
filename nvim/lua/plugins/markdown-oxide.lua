return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure markdown-oxide is configured
      opts.servers = opts.servers or {}
      opts.servers.markdown_oxide = {
        -- Configuración específica para markdown-oxide
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          }
        ),

        -- Configuración del servidor
        settings = {
          markdown_oxide = {
            -- Habilitar todas las características PKM
            completion = {
              enabled = true,
            },
            references = {
              enabled = true,
            },
            hover = {
              enabled = true,
            },
            code_lens = {
              enabled = true,
            },
            diagnostics = {
              enabled = true,
            },
          },
        },

        -- Tipos de archivo soportados
        filetypes = { "markdown" },

        -- Comando para ejecutar el servidor (usando el binario de Homebrew)
        cmd = { "markdown-oxide" },

        -- Configuración del workspace
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            ".git",
            ".markdownlint.json",
            ".markdownlint.yaml",
            ".markdownlint.yml"
          )(fname) or vim.fn.getcwd()
        end,

        -- Configuración adicional para PKM
        single_file_support = true,
      }
    end,
  },

  -- Configuración adicional para mejorar la experiencia con Markdown
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
    end,
  },

  -- Keymaps específicos para markdown-oxide cuando está en archivos markdown
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Configurar keymaps específicos para archivos markdown
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          local bufnr = args.buf

          -- Keymap para abrir referencias con Telescope
          vim.keymap.set("n", "gr", function()
            require("telescope.builtin").lsp_references()
          end, { buffer = bufnr, desc = "LSP References (Telescope)" })

          -- Keymap para ir a definición
          vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
          end, { buffer = bufnr, desc = "Go to Definition" })

          -- Keymap para hover
          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
          end, { buffer = bufnr, desc = "Hover Documentation" })

          -- Keymap para code lens
          vim.keymap.set("n", "<leader>cl", function()
            vim.lsp.codelens.run()
          end, { buffer = bufnr, desc = "Run Code Lens" })

          -- Keymap para refrescar code lens
          vim.keymap.set("n", "<leader>cL", function()
            vim.lsp.codelens.refresh()
          end, { buffer = bufnr, desc = "Refresh Code Lens" })
        end,
      })
    end,
  },

  -- Habilitar code lens automáticamente para archivos markdown
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        pattern = "*.md",
        callback = function()
          vim.lsp.codelens.refresh()
        end,
      })
    end,
  },
}
