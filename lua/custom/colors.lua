-- lua/custom/colors.lua
local function make_transparent()
    local groups = {
        "Normal",
        "NormalFloat",
        "NonText",
        "SignColumn",
        "LineNr",
        "DiagnosticVirtualTextError",
        "DiagnosticVirtualTextWarn",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopeResultsBorder",
        "TelescopePreviewBorder",
    }
    for _, g in ipairs(groups) do
        pcall(vim.api.nvim_set_hl, 0, g, { bg = "NONE" })
    end
end

-- run once now (if colorscheme already set)
make_transparent()

-- reapply whenever a colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = make_transparent,
})
