return {
  -- Configuración para rustaceanvim
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          -- Keymaps específicos para Rust
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })

          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })

          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd.RustLsp("runnables")
          end, { desc = "Rust Runnables", buffer = bufnr })

          vim.keymap.set("n", "<leader>rt", function()
            vim.cmd.RustLsp("testables")
          end, { desc = "Rust Testables", buffer = bufnr })

          vim.keymap.set("n", "<leader>re", function()
            vim.cmd.RustLsp("explainError")
          end, { desc = "Explain Error", buffer = bufnr })

          vim.keymap.set("n", "<leader>rc", function()
            vim.cmd.RustLsp("openCargo")
          end, { desc = "Open Cargo.toml", buffer = bufnr })

          vim.keymap.set("n", "<leader>rp", function()
            vim.cmd.RustLsp("parentModule")
          end, { desc = "Parent Module", buffer = bufnr })

          vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, { desc = "Hover Actions", buffer = bufnr })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              enable = true,
              command = "clippy", -- Usar clippy para mejores diagnósticos
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            inlayHints = {
              lifetimeElisionHints = {
                enable = "skip_trivial",
                useParameterNames = true,
              },
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
              watcher = "client",
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- Configuración para crates.nvim (ayuda con Cargo.toml)
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)

      -- Keymaps para crates.nvim
      vim.keymap.set("n", "<leader>rcu", function()
        crates.update_crate()
      end, { desc = "Update Crate" })

      vim.keymap.set("n", "<leader>rca", function()
        crates.update_all_crates()
      end, { desc = "Update All Crates" })

      vim.keymap.set("n", "<leader>rcU", function()
        crates.upgrade_crate()
      end, { desc = "Upgrade Crate" })

      vim.keymap.set("n", "<leader>rcA", function()
        crates.upgrade_all_crates()
      end, { desc = "Upgrade All Crates" })

      vim.keymap.set("n", "<leader>rcH", function()
        crates.open_homepage()
      end, { desc = "Open Homepage" })

      vim.keymap.set("n", "<leader>rcD", function()
        crates.open_documentation()
      end, { desc = "Open Documentation" })

      vim.keymap.set("n", "<leader>rcR", function()
        crates.open_repository()
      end, { desc = "Open Repository" })
    end,
  },

  -- Asegurar que treesitter tenga soporte para Rust
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust", "ron", "toml" })
      end
    end,
  },

  -- Asegurar que Mason instale las herramientas necesarias
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "codelldb", "rust-analyzer" })
      end
    end,
  },
}
