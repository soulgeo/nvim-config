return {
    "L3MON4D3/LuaSnip",
    config = function()
        local ok, ls = pcall(require, "luasnip")
        if not ok then
            vim.notify("LuaSnip not found", vim.log.levels.WARN)
            return
        end

        ls.config.set_config({
            history = true,
            region_check_events = "InsertEnter",
            delete_check_events = "TextChanged,InsertLeave",
        })
    end,
}
