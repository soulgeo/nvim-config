local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        -- css = { "prettier" },
        -- html = { "prettier" },
        javascript = { "prettierd" },
        go = { "gofumpt", "golines" }, --removed goimports-reviser
    },

    formatters = {
        -- Python
        black = {
            prepend_args = {
                "--fast",
                "--line-length",
                "80",
            },
        },
        isort = {
            prepend_args = {
                "--profile",
                "black",
            },
        },
        -- Go
        ["goimports-reviser"] = {
            prepend_args = { "-rm-unused" },
        },
        golines = {
            prepend_args = { "--max-len=80" },
        },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 5000,
        lsp_fallback = true,
    },
}

return options
