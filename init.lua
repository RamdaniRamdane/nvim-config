-- author : Ramdani Ramdane 
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars:append("tab:> ")
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = false

--plugins
vim.cmd([[packadd packer.nvim]]) --using packer as package manager
require("packer").startup(function(use)
  use("wbthomason/packer.nvim")
  --gruvbox theme
  use("morhetz/gruvbox")
  vim.cmd([[
    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
    " Personnaliser les couleurs pour le background
    hi Normal guibg=#000000
    hi LineNr guibg=#000000
    hi CursorLine guibg=#121212
    hi CursorLineNr guibg=#121212
    hi SignColumn guibg=#000000
    hi StatusLine guibg=#1c1c1c
  ]])
  -- end gruvbox theme

  -- use treesitter for lang highlight

  use("nvim-treesitter/nvim-treesitter")
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
    highlight = {
      enable = true,
    },
  })
  --end treeseter

  -- lua line
  use("nvim-lualine/lualine.nvim")
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  })
  --end lualine

  --brgin fzf (finding files quickly )
  use("junegunn/fzf")
  use("junegunn/fzf.vim")

  --end fzf
  -- nvim tree
  -- file explorer
  use("nvim-tree/nvim-tree.lua")
  -- vs-code like icons
  use("nvim-tree/nvim-web-devicons")
  require("nvim-tree").setup({})
  -- end nvim tree

  -- vim-cmp
  use("hrsh7th/nvim-cmp") -- The completion plugin
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("saadparwaiz1/cmp_luasnip") -- snippet completions
  use("hrsh7th/cmp-nvim-lsp")
  -- snippets
  use("L3MON4D3/LuaSnip") --snippet engine
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- LSP
  use("neovim/nvim-lspconfig") -- enable LSP
  use("williamboman/mason.nvim") -- simple to use language server installer
  use("williamboman/mason-lspconfig.nvim") -- simple to use language server installer
  use("jose-elias-alvarez/null-ls.nvim") -- LSP diagnostics and code actions
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "tsserver", "html", "cssls", "eslint", "jsonls", "bashls", "dockerls", "yamlls" },
  })

  -- vscode like snipets LSP

  require("luasnip.loaders.from_vscode").lazy_load()
  local kind_icons = {
    Text = "󰊄",
    Method = "m",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "󰫧",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "󰌆",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "󰉺",
  }
  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = "luasnip" }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = "buffer" },
    }),
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  --Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]
  --

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })

  -- Set up lspconfig.
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local servers = { "pyright", "tsserver", "html", "cssls", "eslint", "jsonls", "bashls", "dockerls", "yamlls" }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      capabilities = capabilities,
    })
  end

  -- end vim-cmp snippets
  --  teminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("toggleterm").setup({
        shell = "/bin/bash",
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "#000000",
          },
        },
      })
    end,
  })
  -- end terminal
  -- bufferline
  use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" })
  vim.opt.termguicolors = true
  require("bufferline").setup({
    options = {
      numbers = "ordinal",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,
      indicator_icon = "▎",
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 18,
      max_prefix_length = 15,
      tab_size = 18,
      diagnostics = false,
      custom_filter = function(buf_number)
        -- Func to filter out unwanted buffer types
        return true
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          padding = 1,
        },
      },
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      separator_style = "slant",
      enforce_regular_tabs = true,
      always_show_bufferline = true,
      sort_by = "id",
    },
  })
  --end bufferline
  --autopairs ()[] ..
  use("windwp/nvim-autopairs")
  --setup autopairs
  local status_ok, npairs = pcall(require, "nvim-autopairs")
  if not status_ok then
    return
  end

  npairs.setup({
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
  --end autopairs
end)

-- Map global leader from \ to space
vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<leader>fr", ":History<CR>", { noremap = true })
vim.keymap.set("n", "<leader>a", ":NvimTreeFindFileToggle<cr>", { silent = true })
vim.keymap.set("n", "<leader>z", ":NvimTreeFocus<cr>", { silent = true })
vim.keymap.set("n", "<leader><right>", ":BufferLineCycleNext<cr>", { silent = true })
vim.keymap.set("n", "<leader><left>", ":BufferLineCyclePrev<cr>", { silent = true })
