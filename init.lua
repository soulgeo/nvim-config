vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

vim.opt.relativenumber = true

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- add this to your Neovim config
local hooks = require("ibl.hooks")

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    -- create minimal highlight groups that ibl expects
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" })
    vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#2c313c" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#3b4261", underline = true })
end)

require("ibl").setup({
    -- your ibl opts here
    indent = { char = "│", tab_char = "│" },
})

require("options")
require("autocmds")

vim.schedule(function()
    require("mappings")
end)
