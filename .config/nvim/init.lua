-- vim: ts=2 sts=2 sw=2 et
-- NVIM v0.12.0-dev configuration

-- [[ Leader key ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.completeopt = "menu,menuone,preview,noselect"
vim.opt.cursorline = true
vim.opt.encoding = "utf8"
vim.opt.expandtab = true
vim.opt.fileencoding = "utf8"
vim.opt.formatoptions = "tcrqnb"
vim.opt.gdefault = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.lazyredraw = true -- hint
vim.opt.list = true
vim.opt.listchars = "extends:»,precedes:«,tab:→ ,trail:·,leadmultispace:╎ "
vim.opt.modeline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.shell = vim.fn.executable("fish") == 1 and "fish" or "bash"
vim.opt.shiftwidth = 2
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.spell = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.syntax = "on"
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.winborder = "bold"
vim.opt.wrap = true
vim.opt.writebackup = false

vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")

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

-- [[ Yanking, pasting, deleting ]]
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste (without yanking)" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"_d', { desc = "Delete (without yanking)" })

local yank_highlight_group = vim.api.nvim_create_augroup("YankHighlightGroup", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_highlight_group,
  pattern = "*",
})

-- [[ Package manager ]]
vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzy-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/stevearc/oil.nvim" },
})
require("fidget").setup({})
require("gitsigns").setup({})
require("lualine").setup({})
require("mason").setup({})
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "markdown", "rust", "zig" },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- [[ Telescope configuration ]]
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
require("telescope").load_extension("fzy_native")
require("telescope").load_extension("ui-select")

-- [[ File manager ]]
require("oil").setup()
vim.keymap.set("n", "-", ":Oil<CR>")

-- [[ Theme ]]
vim.cmd.colorscheme("tokyonight-night")
vim.cmd(":hi statusline guibg=NONE")

-- [[ Language Server Protocol keymap ]]
vim.keymap.set("i", "<C-space>", vim.lsp.completion.get)
vim.keymap.set("n", "<C-space>", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP Format" })

-- [[ Language Server Protocol auto completion ]]
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if client and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format { async = false, id = ev.data.client_id }
        end,
      })
    end
  end,
})

-- [[ Language Server Protocol configuration ]]
vim.lsp.enable({ "bashls", "biome", "fish_lsp", "gh_actions_ls", "graphql", "helm_ls", "lua_ls", "marksman", "regols",
  "ruff", "sourcekit", "superhtml", "ts_ls", "vale_ls", "yamlls", "ziggy" })

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
