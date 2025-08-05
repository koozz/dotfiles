-- [[ Leader key ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false

vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.completeopt = "menu,menuone,preview,noselect,noinsert"
vim.opt.cursorline = true
vim.opt.encoding = "utf8"
vim.opt.expandtab = true
vim.opt.fileencoding = "utf8"
vim.opt.formatoptions = "tcrqnb"
vim.opt.gdefault = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.lazyredraw = true -- hint
vim.opt.list = true
vim.opt.listchars = "extends:»,precedes:«,tab:→ ,trail:·"
vim.opt.modeline = true
vim.opt.scrolloff = 5
vim.opt.shell = vim.fn.executable("fish") == 1 and "fish" or "bash"
vim.opt.shiftwidth = 4
vim.opt.showcmd = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.spell = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.syntax = "on"
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.writebackup = false

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.suffixesadd:append({ ".lua", ".rs", ".ts", ".zig" })

-- [[ Show indentation guide ]]
local function IndentGuide()
  vim.opt_local.listchars = vim.o.listchars
  vim.opt_local.listchars:remove("leadmultispace")
  vim.opt_local.listchars:append({
    leadmultispace = "╎" .. string.rep(" ", (vim.bo.shiftwidth - 1)),
  })
end
local indent_guide_group = vim.api.nvim_create_augroup("IndentGuideGroup", { clear = true })
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "shiftwidth",
  group = indent_guide_group,
  callback = IndentGuide,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = indent_guide_group,
  callback = IndentGuide,
})

-- [[ Word wrap aware movement ]]
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Diagnostic settings ]]
vim.diagnostic.config({ virtual_text = true })

-- [[ Buffer movement ]]
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move half a page down (and center)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move half a page up (and center)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next (and center)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous (and center)" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (and stay)" })
vim.keymap.set("n", "<leader>x", ":bdelete<CR>")

vim.keymap.set("n", "th", "<cmd>bfirst<CR>", { desc = "First buffer" })
vim.keymap.set("n", "tj", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "tk", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "tl", "<cmd>blast<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "tq", "<cmd>bd<CR>", { desc = "Close current buffer" })

-- [[ Quickfix list - populated with <C-q> ]]
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<leader>qq", "<cmd>copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<Esc><Esc>", "<cmd>cclose<CR>", { desc = "Close quickfix" })

-- [[ Yanking, pasting, deleting ]]
vim.keymap.set("x", "<C-c>", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste (without yanking)" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete (without yanking)" })

local yank_highlight_group = vim.api.nvim_create_augroup("YankHighlightGroup", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_highlight_group,
  pattern = "*",
})

-- [[ Language Server Protocol keymap ]]
vim.keymap.set("i", "<c-space>", function()
  vim.lsp.completion.get()
end)
vim.keymap.set("n", "<c-space>", function()
  vim.lsp.buf.code_action()
end)

-- [[ Language Server Protocol auto completion ]]
-- Blink still takes over
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client and client:supports_method("textDocument/completion") then
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end,
-- })

-- [[ Lazy package manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Lazy managed plugins ]]
require("lazy").setup({
  {
    "fatih/vim-go",
    ft = { "go", "gomod" },
    init = function()
      vim.lsp.enable("gopls")
      vim.g.go_fmt_command = "goimports"
      vim.g.go_fmt_fail_silently = 1
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },
  {
    "laytan/cloak.nvim",
    opts = {
      enabled = true,
      cloak_character = "*",
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = {
            ".env*",
          },
          cloak_pattern = "=.+",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      if vim.fn.executable("bash-language-server") == 1 then
        vim.lsp.enable("bashls")
      end

      if vim.fn.executable("biome") == 1 then
        vim.lsp.enable("biome")
      end

      if vim.fn.executable("gh-actions-language-server") == 1 then
        vim.lsp.enable("gh_actions_ls")
      end

      -- if vim.fn.executable("harper-ls") == 1 then
      --   vim.lsp.enable("harper_ls")
      -- end

      if vim.fn.executable("helm_ls") == 1 then
        vim.lsp.enable("helm_ls")
      end

      if vim.fn.executable("lua-language-server") == 1 then
        vim.lsp.config("lua_ls", {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_markers = { ".git" },
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
            },
          },
        })
        vim.lsp.enable("lua_ls")
      end

      if vim.fn.executable("marksman") == 1 then
        vim.lsp.enable("marksman")
      end

      if vim.fn.executable("regols") == 1 then
        vim.lsp.enable("regols")
      end

      if vim.fn.executable("ruff") == 1 then
        vim.lsp.enable("ruff")
      end

      if vim.fn.executable("sourcekit-lsp") == 1 then
        vim.lsp.enable("sourcekit")
      end

      if vim.fn.executable("superhtml") == 1 then
        vim.lsp.enable("superhtml")
      end

      if vim.fn.executable("typescript-language-server") == 1 then
        vim.lsp.enable("ts_ls")
      end

      if vim.fn.executable("vale-ls") == 1 then
        vim.lsp.enable("vale_ls")
      end

      if vim.fn.executable("yaml-language-server") == 1 then
        vim.lsp.enable("yamlls")
      end

      if vim.fn.executable("ziggy") == 1 then
        vim.lsp.enable("ziggy")
      end
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "buffers" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "natecraddock/telescope-zf-native.nvim",
    },
    config = function()
      -- require("telescope").load_extension("fzf")
      require("telescope").load_extension("zf-native")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
      vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<backspace><backspace>", builtin.buffers, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })

      vim.keymap.set("n", "g/", builtin.live_grep, { desc = "Global search" })

      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>gb", builtin.git_bcommits, { desc = "Git Buffer commits" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })

      vim.keymap.set("n", "<leader>q", builtin.quickfix, { desc = "Quickfix" })
      vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "Diagnostics" })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "editorconfig",
        "fish",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "hcl",
        "helm",
        "html",
        "jinja",
        "json",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "nginx",
        "nix",
        "regex",
        "rego",
        "rust",
        "scss",
        "sql",
        "superhtml",
        "swift",
        "tmux",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "zig",
        "ziggy",
        "ziggy_schema",
      },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      indent = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          clear_on_cursor_move = true,
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = "gnd",
            list_definitions = "gnD",
            list_definitions_toc = "gO",
            goto_next_usage = "<a-*>",
            goto_previous_usage = "<a-#>",
          },
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "grn",
          },
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = true,
        },
      },
      modules = {},
    },
  },
  {
    "rust-lang/rust.vim",
    ft = { "rust" },
    init = function()
      vim.lsp.enable("rust_analyzer")
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      -- "giuxtaposition/blink-cmp-copilot",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
        -- preset = "default",
      },
      sources = {
        -- default = { "lsp", "path", "buffer", "copilot" },
        default = { "lsp", "path", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
  -- {
  --   "giuxtaposition/blink-cmp-copilot",
  --   dependencies = {
  --     "zbirenbaum/copilot.lua",
  --   },
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --   },
  -- },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters = {
        lua = { "stylua" },
      },
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    },
    lazy = false,
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
  {
    "ziglang/zig.vim",
    ft = { "zig" },
    init = function()
      if vim.fn.executable("zls") == 1 then
        vim.lsp.config("zls", {
          cmd = { "zls" },
          filetypes = { "zig" },
          root_markers = { "build.zig", ".git" },
          settings = {
            zls = {
              checkOnSave = {
                enable = true,
              },
              enable_build_on_save = true,
            },
          },
        })
        vim.lsp.enable("zls")
        vim.g.zig_fmt_autosave = 1
        vim.g.zig_fmt_parse_errors = 0
      end
    end,
  },
})
-- vim: ts=2 sts=2 sw=2 et
