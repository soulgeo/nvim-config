---@type Base46Table
local M = {}

-- UI palette (base_30) — these keys are expected by base46
M.base_30 = {
    white = "#b4b4b4",
    black = "#121212",
    darker_black = "#121212",
    black2 = "#191919",
    one_bg = "#212121",
    one_bg2 = "#535353",
    one_bg3 = "#949494",
    grey = "#535353",
    grey_fg = "#949494",
    grey_fg2 = "#a7a7a7",
    light_grey = "#b4b4b4",
    red = "#B14242",
    baby_pink = "#B14242",
    pink = "#B14242",
    line = "#191919",
    green = "#DF6464",
    vibrant_green = "#DF6464",
    nord_blue = "#4A8B8B",
    blue = "#4A8B8B",
    seablue = "#4A8B8B",
    yellow = "#E49A44",
    sun = "#E49A44",
    purple = "#B14242",
    dark_purple = "#B14242",
    teal = "#D87C4A",
    orange = "#b4b4b4",
    cyan = "#D87C4A",
    statusline_bg = "#191919",
    lightbg = "#212121",
    pmenu_bg = "#E49A44",
    folder_bg = "#DF6464",
}

-- base16 (syntax) — map the user's base16 values here
M.base_16 = {
    base00 = "#121212",
    base01 = "#191919",
    base02 = "#212121",
    base03 = "#535353",
    base04 = "#b4b4b4",
    base05 = "#949494",
    base06 = "#C4693D",
    base07 = "#d5d5d5",
    base08 = "#a7a7a7", -- red_ember
    base09 = "#4A8B8B", -- blue
    base0A = "#D87C4A", -- orange_blaze
    base0B = "#DF6464", -- red_glowing
    base0C = "#89492a", -- orange_smolder
    base0D = "#B14242", -- orange_glow
    base0E = "#B14242", -- red_ember (same as base08)
    base0F = "#E49A44", -- brown
}

-- OPTIONAL: polish_hl — fine-grained overrides for specific highlight groups or integrations.
-- Keep this small to start; you can expand later.
M.polish_hl = {
    -- default highlights
    defaults = {
        Comment = { fg = M.base_30.grey_fg, italic = true },
    },

    -- treesitter / highlight groups
    treesitter = {
        ["@variable"] = { fg = M.base_30.white },
        ["@function"] = { fg = M.base_30.orange, bold = true },
    },
}

-- theme type
M.type = "dark"

-- let base46 apply any user overrides defined in chadrc
M = require("base46").override_theme(M, "ashen")

return M
