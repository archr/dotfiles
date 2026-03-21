-- =============================================================================
-- init.lua — Neovim minimalista para búsqueda y navegación de código
-- Enfocado en: telescope + ripgrep + LSP ligero + treesitter
-- =============================================================================

-- INSTALACIÓN:
--   mkdir -p ~/.config/nvim && cp init.lua ~/.config/nvim/
--   Abre nvim → :Lazy (espera que instale) → listo
--
-- DEPENDENCIAS EXTERNAS (instalar primero):
--   brew install neovim ripgrep fd node
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. BOOTSTRAP: lazy.nvim (plugin manager)
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- 2. OPCIONES BÁSICAS
-- -----------------------------------------------------------------------------
vim.g.mapleader = " "           -- Space como leader key

vim.opt.number         = true   -- números de línea
vim.opt.relativenumber = true   -- números relativos (útil para saltar con 10j, etc.)
vim.opt.ignorecase     = true   -- búsqueda case-insensitive
vim.opt.smartcase      = true   -- ...a menos que uses mayúsculas
vim.opt.hlsearch       = true   -- resaltar matches de búsqueda
vim.opt.termguicolors  = true   -- colores 24-bit
vim.opt.splitright     = true   -- splits a la derecha
vim.opt.splitbelow     = true   -- splits abajo
vim.opt.scrolloff      = 8      -- siempre ver 8 líneas alrededor del cursor
vim.opt.updatetime     = 250    -- diagnósticos LSP más rápidos
vim.opt.signcolumn     = "yes"  -- columna de signos siempre visible (evita saltos)
vim.opt.clipboard = "unnamedplus"

-- Indentación de 2 espacios
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.expandtab   = true
vim.opt.smartindent = true

-- ── Indicador visual de foco ───────────────────────────────────────────────
-- Atenúa sutilmente ventanas sin foco (dentro de Neovim y cuando foco va a tmux)
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FocusGained" }, {
  callback = function()
    vim.opt_local.winhighlight = ""
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "FocusLost" }, {
  callback = function()
    vim.opt_local.winhighlight = "Normal:NormalNC"
    vim.opt_local.cursorline = false
  end,
})

-- -----------------------------------------------------------------------------
-- 3. PARSERS BUILT-IN (Neovim 0.10+, sin plugin externo)
-- -----------------------------------------------------------------------------
-- Neovim incluye treesitter nativo. Solo hay que habilitar el highlight
-- y agregar los parsers que no vienen incluidos de fábrica.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "elixir", "eelixir", "heex", "surface" },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Instala parsers de Elixir la primera vez (requiere tree-sitter CLI o gcc)
-- Si no funciona: brew install tree-sitter
local parsers = { "elixir", "heex" }
for _, lang in ipairs(parsers) do
  local ok = pcall(vim.treesitter.language.inspect, lang)
  if not ok then
    vim.cmd("silent! TSInstall " .. lang)
  end
end

require("lazy").setup({

  -- ── Colorscheme ─────────────────────────────────────────────────────────
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,           -- works with Ghostty opacity
        italic_comments = true,
        borderless_telescope = false,
      })
      vim.cmd.colorscheme("cyberdream")
      -- Subtle colors for inactive windows
      vim.api.nvim_set_hl(0, "NormalNC", { fg = "#7b8496" })
    end,
  },

  -- ── Dressing: mejor UI para vim.ui.select y vim.ui.input ─────────────────
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      select = {
        backend = { "builtin" },  -- builtin es más limpio para menús pequeños
        builtin = {
          relative = "cursor",
          min_width = { 30, 0.2 },
        },
      },
    },
  },

  -- ── Telescope: fuzzy finder central ─────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- extensión nativa en C → mucho más rápido para proyectos grandes
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- integración con frecencia (archivos usados frecuentemente)
      "nvim-telescope/telescope-frecency.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- ripgrep como backend de grep
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number", "--column",
            "--smart-case", "--hidden",           -- incluye dotfiles
            "--glob", "!**/.git/*",               -- excluye .git
            "--glob", "!**/node_modules/*",       -- excluye node_modules
          },
          -- layout
          layout_strategy = "horizontal",
          layout_config   = { preview_width = 0.55 },
          -- keymaps dentro de telescope
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        },
        pickers = {
          find_files = {
            -- usa fd si está disponible, más rápido que find
            find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("frecency")
    end,
  },

  -- ── Árbol de archivos: neo-tree ──────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- iconos de archivos
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,   -- cierra nvim si neo-tree es la última ventana
      window = {
        width    = 35,
        position = "left",
        mappings = {
          ["<space>"] = "none",      -- libera space para leader key
          ["l"]       = "open",      -- abrir con l
          ["h"]       = "close_node",-- cerrar con h
          ["v"]       = "open_vsplit",
          ["s"]       = "open_split",
        },
      },
      filesystem = {
        hijack_netrw_behavior = "disabled",  -- don't auto-open when running nvim .
        filtered_items = {
          visible         = true,    -- muestra dotfiles pero en gris
          hide_dotfiles   = false,
          hide_gitignored = true,
        },
        follow_current_file = {
          enabled = true,            -- resalta el archivo actual automáticamente
        },
      },
    },
  },

  -- ── Árbol de símbolos (outline lateral) ─────────────────────────────────
  {
    "stevearc/aerial.nvim",
    dependencies = {},
    config = function()
      require("aerial").setup({
        layout = { width = 35 },
        attach_mode = "global",
        -- muestra funciones, clases, métodos, variables
        filter_kind = {
          "Class", "Constructor", "Enum", "Function",
          "Interface", "Method", "Module", "Struct",
        },
      })
    end,
  },

  -- Treesitter: Neovim 0.10+ lo trae integrado para highlighting.
  -- Para text objects avanzados se puede agregar después una vez que funcione el resto.

  -- ── LSP: solo lo esencial para go-to-definition y referencias ───────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim",           config = true },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "elixirls",
          "lua_ls",
          "rust_analyzer",
        },
        automatic_installation = true,
      })

      -- Add cmp capabilities to LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- keymaps LSP: se registran cuando un servidor se adjunta al buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local tb = require("telescope.builtin")
          map("gd", function()
            vim.ui.select(
              { "current window", "horizontal split", "vertical split", "new tab" },
              { prompt = "Open definition in:" },
              function(choice)
                if not choice then return end
                local cmds = {
                  ["horizontal split"] = "split",
                  ["vertical split"] = "vsplit",
                  ["new tab"] = "tab split",
                }
                if cmds[choice] then vim.cmd(cmds[choice]) end
                vim.lsp.buf.definition()
              end
            )
          end, "Go to Definition")
          map("gr",         tb.lsp_references,                "Go to References")
          map("gI",         tb.lsp_implementations,           "Go to Implementation")
          map("<leader>D",  tb.lsp_type_definitions,          "Type Definition")
          map("<leader>fs", tb.lsp_dynamic_workspace_symbols, "Find Symbol (workspace)")
          map("<leader>fd", tb.lsp_document_symbols,          "Find Symbol (archivo)")
          map("K",          vim.lsp.buf.hover,                "Hover Docs")
          map("<leader>rn", vim.lsp.buf.rename,               "Rename")
          map("[d",         vim.diagnostic.goto_prev,         "Diagnóstico anterior")
          map("]d",         vim.diagnostic.goto_next,         "Diagnóstico siguiente")
        end,
      })

      -- nueva API: vim.lsp.config en lugar de lspconfig[server].setup()
      vim.lsp.config("ts_ls",        { capabilities = capabilities })
      vim.lsp.config("elixirls",     {
        capabilities = capabilities,
        settings = {
          elixirLS = {
            dialyzerEnabled    = false,  -- desactivar dialyzer (muy lento al inicio)
            fetchDeps          = false,  -- no fetch deps automáticamente
            enableTestLenses   = true,   -- lentes para correr tests
            suggestSpecs       = true,
          }
        }
      })
      vim.lsp.config("lua_ls",       {
        capabilities = capabilities,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } }
      })
      vim.lsp.config("rust_analyzer", { capabilities = capabilities })

      vim.lsp.enable({ "ts_ls", "elixirls", "lua_ls", "rust_analyzer" })

      -- mix format al guardar archivos Elixir
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ex", "*.exs", "*.heex", "*.leex" },
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },

  -- ── Autocomplete: nvim-cmp ──────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              buffer   = "[Buf]",
              path     = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },

  -- ── Elixir: herramientas extra ───────────────────────────────────────────
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event   = { "BufReadPre", "BufNewFile" },
    ft      = { "elixir", "eelixir", "heex", "surface" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config  = function()
      local elixir     = require("elixir")
      local elixirls   = require("elixir.elixirls")

      elixir.setup({
        nextls = {
          enable = false,   -- desactivado por bug con GenLSP.ErrorResponse
        },
        elixirls = {
          enable  = true,   -- usamos elixirls como primario
          settings = elixirls.settings({
            dialyzerEnabled  = false,  -- lento al inicio, activar después
            fetchDeps        = false,
            enableTestLenses = true,
            suggestSpecs     = true,
          }),
        },
        projectionist = { enable = true },
      })
    end,
  },

  -- ── Saltar a cualquier lugar: flash.nvim ────────────────────────────────
  -- Tipo easymotion pero moderno. `s` + 2 chars y saltas donde quieras
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {},
  },

  -- ── Navegación tmux <-> vim ────────────────────────────────────────────
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>" },
    },
    cond = function()
      return vim.env.TMUX ~= nil  -- solo cargar si estamos en tmux
    end,
  },

  -- ── Navegación zellij <-> vim ────────────────────────────────────────────
  {
    "swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<C-h>", "<cmd>ZellijNavigateLeftTab<CR>",  { silent = true, desc = "navigate left or tab" } },
      { "<C-j>", "<cmd>ZellijNavigateDown<CR>",  { silent = true, desc = "navigate down" } },
      { "<C-k>", "<cmd>ZellijNavigateUp<CR>",    { silent = true, desc = "navigate up" } },
      { "<C-l>", "<cmd>ZellijNavigateRightTab<CR>", { silent = true, desc = "navigate right or tab" } },
    },
    opts = {},
    cond = function()
      return vim.env.ZELLIJ ~= nil  -- solo cargar si estamos en zellij
    end,
  },

  -- ── Git signs en el gutter ───────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add    = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
      },
    },
  },

  -- ── Statusline mínima ────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "cyberdream",
        section_separators   = "",
        component_separators = "│",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } }, -- path relativo
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── which-key: muestra keymaps disponibles al presionar leader ──────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {},
  },

  -- ── Markdown preview ────────────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
  },

}, {
  -- opciones de lazy.nvim
  ui = { border = "rounded" },
})

-- -----------------------------------------------------------------------------
-- 4. KEYMAPS — organizados por categoría
-- -----------------------------------------------------------------------------

local map = vim.keymap.set
local tb  = require("telescope.builtin")

-- ── Búsqueda de archivos ─────────────────────────────────────────────────────
map("n", "<leader>ff", tb.find_files,                        { desc = "Buscar archivos" })
map("n", "<leader>fr", "<cmd>Telescope frecency<CR>",        { desc = "Archivos recientes (frecency)" })
map("n", "<leader>fb", tb.buffers,                           { desc = "Buffers abiertos" })
map("n", "<leader>fo", tb.oldfiles,                          { desc = "Archivos recientes" })

-- ── Búsqueda de texto ────────────────────────────────────────────────────────
map("n", "<leader>fg", tb.live_grep,                         { desc = "Live grep (todo el proyecto)" })
map("n", "<leader>fw", tb.grep_string,                       { desc = "Buscar palabra bajo cursor" })
map("n", "<leader>f/", tb.current_buffer_fuzzy_find,         { desc = "Buscar en archivo actual" })

-- ── Navegación de símbolos / LSP ─────────────────────────────────────────────
-- (los keymaps de LSP se definen en on_attach, arriba)
map("n", "<leader>e",  "<cmd>Neotree toggle<CR>",            { desc = "Toggle árbol de archivos" })
map("n", "<leader>a",  "<cmd>AerialToggle<CR>",              { desc = "Toggle outline (aerial)" })

-- ── Git ──────────────────────────────────────────────────────────────────────
map("n", "<leader>gc", tb.git_commits,                       { desc = "Git commits" })
map("n", "<leader>gb", tb.git_branches,                      { desc = "Git branches" })
map("n", "<leader>gs", tb.git_status,                        { desc = "Git status" })

-- ── Diagnósticos ─────────────────────────────────────────────────────────────
map("n", "<leader>xx", tb.diagnostics,                       { desc = "Todos los diagnósticos" })

-- ── Flash: saltar a cualquier parte ──────────────────────────────────────────
map({ "n", "x", "o" }, "s", function() require("flash").jump() end,              { desc = "Flash Jump" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end,        { desc = "Flash Treesitter" })

-- ── Navegación de ventanas ────────────────────────────────────────────────────
-- Manejado por vim-tmux-navigator (C-h/j/k/l navega entre vim splits y tmux panes)

-- ── Misc ─────────────────────────────────────────────────────────────────────
map("n", "<leader>q",  "<cmd>bd<CR>",    { desc = "Cerrar buffer" })
map("n", "<Esc>",      "<cmd>noh<CR>",   { desc = "Limpiar highlight de búsqueda" })

-- ── Elixir ───────────────────────────────────────────────────────────────────
-- mix test del archivo actual
map("n", "<leader>mt", function()
  local file = vim.fn.expand("%:p")
  vim.cmd("split | terminal mix test " .. file)
end, { desc = "mix test (archivo actual)" })

-- mix test de la línea actual
map("n", "<leader>ml", function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  vim.cmd("split | terminal mix test " .. file .. ":" .. line)
end, { desc = "mix test (línea actual)" })

-- mix test completo del proyecto
map("n", "<leader>ma", function()
  vim.cmd("split | terminal mix test")
end, { desc = "mix test (todo el proyecto)" })

-- format manual (aunque ya se hace al guardar)
map("n", "<leader>mf", function()
  vim.lsp.buf.format({ async = false })
end, { desc = "mix format" })

-- ── Markdown ───────────────────────────────────────────────────────────────
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })

-- ── Yank (copiar paths y código con contexto) ──────────────────────────────
-- Absolute file path
map("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("Copied: " .. path)
end, { desc = "Yank absolute path" })

-- Relative file path
map("n", "<leader>yr", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  print("Copied: " .. path)
end, { desc = "Yank relative path" })

-- Selected text with file:line context
map("v", "<leader>yc", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Get selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local code = table.concat(lines, "\n")

  -- Build context string
  local path = vim.fn.expand("%:.")
  local line_range = start_line == end_line
    and tostring(start_line)
    or (start_line .. "-" .. end_line)
  local result = path .. ":" .. line_range .. "\n\n" .. code

  vim.fn.setreg("+", result)

  -- Flash highlight animation
  vim.highlight.range(
    0,
    vim.api.nvim_create_namespace("yank_highlight"),
    "IncSearch",
    { start_line - 1, 0 },
    { end_line - 1, vim.fn.col("$") - 1 }
  )
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace("yank_highlight"), 0, -1)
  end, 150)

  -- Exit visual mode and show confirmation
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  print("Copied: " .. path .. ":" .. line_range)
end, { desc = "Yank selection with context" })

-- =============================================================================
-- REFERENCIA RÁPIDA DE KEYMAPS
-- =============================================================================
-- BÚSQUEDA
--   <leader>ff  → fuzzy find archivos del proyecto
--   <leader>fr  → archivos frecuentes/recientes
--   <leader>fg  → grep en vivo en todo el proyecto  ← el más usado
--   <leader>fw  → buscar la palabra bajo el cursor
--   <leader>f/  → buscar dentro del archivo actual
--   <leader>fb  → cambiar de buffer
--
-- SÍMBOLOS / LSP
--   <leader>fs  → buscar símbolo en workspace (funciones, clases...)
--   <leader>fd  → buscar símbolo en archivo actual
--   <leader>a   → toggle outline lateral (aerial)
--   gd          → go to definition
--   gr          → ver referencias
--   gI          → go to implementation
--   K           → hover docs
--   [d / ]d     → diagnóstico anterior/siguiente
--
-- SALTAR
--   s + 2chars  → flash jump (cualquier parte de pantalla)
--   S           → flash treesitter (selección semántica)
--   ]f / [f     → siguiente/anterior función
--   ]c / [c     → siguiente/anterior clase
--   <C-o>       → saltar atrás en jumplist
--   <C-i>       → saltar adelante en jumplist
--
-- GIT
--   <leader>gs  → git status
--   <leader>gc  → git commits
--   <leader>gb  → git branches
--
-- YANK (copiar)
--   <leader>yp  → copiar ruta absoluta
--   <leader>yr  → copiar ruta relativa
--   <leader>yc  → (visual) copiar código con file:line contexto
--
-- MARKDOWN
--   <leader>mp  → toggle markdown preview in browser
-- =============================================================================
