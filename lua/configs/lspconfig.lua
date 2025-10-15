local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- local lspconfig = require("lspconfig")

-- list of all servers configured.

-- list of servers configured with default config.
local default_servers = {
    "pyright",
    "ts_ls",
    "eslint",
}

-- lsps with default config
vim.lsp.enable(default_servers)
-- for _, lsp in ipairs(default_servers) do
--     lspconfig[lsp].setup({
--         on_attach = on_attach,
--         on_init = on_init,
--         capabilities = capabilities,
--     })
-- end

vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("gopls", {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gotmpl", "gowork" },
    -- root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
        },
    },
})
vim.lsp.enable("gopls")

-- === Explicit OmniSharp setup (use Mason-installed OmniSharp) ===
local pid = tostring(vim.fn.getpid())
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/omnisharp"
local omnisharp_bin = mason_path .. "/OmniSharp" -- Mason's executable (capital O)
local omnisharp_dll = mason_path .. "/libexec/OmniSharp.dll" -- alternative: run with dotnet

-- helper to build common options
local omnisharp_opts = {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    -- root_dir = util.root_pattern("*.sln", ".csproj", ".git"),
    -- optionally disable omnisharp formatting if you use another formatter:
    -- handlers or server_capabilities can be adjusted in on_attach
}

if vim.fn.executable(omnisharp_bin) == 1 then
    -- use the OmniSharp executable installed by Mason
    omnisharp_opts.cmd = { omnisharp_bin, "--languageserver", "--hostPID", pid, "--encoding", "utf-8" }
    vim.lsp.config("omnisharp", omnisharp_opts)
    vim.lsp.enable("omnisharp")
elseif vim.fn.executable("dotnet") == 1 and vim.fn.filereadable(omnisharp_dll) == 1 then
    -- fallback: use dotnet to run OmniSharp.dll
    omnisharp_opts.cmd = { "dotnet", omnisharp_dll, "--languageserver", "--hostPID", pid }
    vim.lsp.config("omnisharp", omnisharp_opts)
    vim.lsp.enable("omnisharp")
else
    vim.notify(
        "OmniSharp not found in mason packages. Check ~/.local/share/nvim/mason/packages/omnisharp",
        vim.log.levels.WARN
    )
end
