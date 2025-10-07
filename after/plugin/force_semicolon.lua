-- ~/.config/nvim/after/plugin/force_semicolon.lua
-- Loaded after all plugins/configs, so this can override/re-delete earlier mappings.
vim.schedule(function()
    -- try to delete any mapping left behind
    pcall(vim.keymap.del, "n", ";")

    -- Remap ; in normal mode to call the builtin repeat-find safely
    vim.keymap.set("n", ";", function()
        -- use normal! to call the builtin (non-recursive)
        vim.cmd("normal! ;")
    end, { noremap = true, silent = true })
end)
