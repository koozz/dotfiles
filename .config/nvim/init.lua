-- vim: ts=2 sts=2 sw=2 et
-- NVIM v0.12.0-dev configuration

-- [[ Leader key ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
vim.opt.autoindent = true
vim.opt.autoread = true
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
vim.keymap.set("n", "<ESC><ESC>", "<CMD>cclose<CR>")

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

-- [[ Buffer freshness ]]
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- [[ Language Server Protocol keymap ]]
vim.keymap.set("i", "<C-space>", vim.lsp.completion.get)
vim.keymap.set("n", "<C-space>", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP Format" })

-- [[ Language Server Protocol auto completion and formatting ]]
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- [[ Language Server Protocol inline completion ]]
vim.lsp.inline_completion.enable()
vim.keymap.set("i", "<Tab>", function()
  if not vim.lsp.inline_completion.get() then
    return "<Tab>"
  end
  if vim.fn.pumvisible() == 1 then
    return vim.keycode("<C-e>")
  end
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Get the current inline completion",
})

-- [[ Language Server Protocol configuration ]]
vim.lsp.enable({
  "bashls",
  "biome",
  "clangd",
  "copilot",
  "fish_lsp",
  "gh_actions_ls",
  "graphql",
  "helm_ls",
  "lua_ls",
  "marksman",
  "ruff",
  -- "sourcekit",
  "tsgo",
  "vale_ls",
  "yamlls",
  "zls",
})

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

-- [[ Package manager ]]
vim.pack.add({
  -- Look and feel
  { src = "https://github.com/catppuccin/nvim", version = "v1.11.0" },
  { src = "https://github.com/j-hui/fidget.nvim", version = "v1.6.1" },
  { src = "https://github.com/lewis6991/gitsigns.nvim", version = "v1.0.2" },
  -- LSP related
  { src = "https://github.com/mason-org/mason.nvim", version = "v2.0.1" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim", version = "v2.1.0" },
  { src = "https://github.com/neovim/nvim-lspconfig", version = "v2.5.0" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "v0.10.0" },
  -- Utilities
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "v0.1.4" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
  { src = "https://github.com/nvim-telescope/telescope-fzy-native.nvim", version = "master" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim", version = "master" },
  { src = "https://github.com/stevearc/oil.nvim", version = "v2.15.0" },
  { src = "https://github.com/stevearc/conform.nvim", version = "v9.1.0" },
})

-- [[ Package configuration: catppuccin ]]
vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd(":hi statusline guibg=NONE")

-- [[ Package configurations ]]
require("fidget").setup({})
require("gitsigns").setup({})
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "lua_ls", "rust_analyzer" },
})

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

-- [[ Package configuration: telescope ]]
require("telescope").setup()
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<CR><CR>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader><leader>", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<backspace><backspace>", builtin.diagnostics, { desc = "Telescope diagnostics" })
require("telescope").load_extension("fzy_native")
require("telescope").load_extension("ui-select")

-- [[ File manager ]]
require("oil").setup({
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, bufnr)
      return name:match("^.git$")
    end,
  },
})
vim.keymap.set("n", "-", ":Oil<CR>")

-- [[ Package configuration: conform ]]
require("conform").setup({
  formatters_by_ft = {
    javascript = { "biome" },
    markdown = { "mdsf" },
    lua = { "stylua" },
    rust = { "rustfmt" },
    typescript = { "biome" },
    zig = { "zigfmt" },
  },
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
