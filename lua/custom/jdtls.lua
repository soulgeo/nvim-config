-- ~/.config/nvim/lua/custom/jdtls.lua
local M = {}

local function mason_path(...)
  return vim.fn.stdpath("data") .. "/mason/packages/" .. table.concat({...}, "/")
end

function M.setup()
  local jdtls = require("jdtls")
  local home = os.getenv("HOME")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name

  -- find java executable/jdtls wrapper from PATH (mason will provide a 'jdtls' executable)
  local cmd = { vim.fn.exepath("jdtls") }
  if cmd[1] == "" then
    -- fallback: try launching jdtls via java + jar (only if you know path), but we prefer mason
    cmd = { "java", "-Declipse.application=org.eclipse.jdt.ls.core.id1", "-Dosgi.bundles.defaultStartLevel=4", "-Declipse.product=org.eclipse.jdt.ls.core.product" }
  end

  -- Build bundles for java-debug and java-test if mason installed them
  local bundles = {}

  -- java-debug-adapter jar (mason package path)
  local java_debug_glob = mason_path("java-debug-adapter", "extension", "server", "com.microsoft.java.debug.plugin-*.jar")
  for _, p in ipairs(vim.split(vim.fn.glob(java_debug_glob), "\n")) do
    if #p > 0 then table.insert(bundles, p) end
  end

  -- java-test (vscode-java-test) server jars (optional)
  local java_test_glob = mason_path("java-test", "server", "*.jar")
  for _, p in ipairs(vim.split(vim.fn.glob(java_test_glob), "\n")) do
    if #p > 0 then table.insert(bundles, p) end
  end

  local config = {
    cmd = cmd,
    root_dir = require('jdtls.setup').find_root({'.git','mvnw','gradlew','build.gradle','pom.xml'}),
    settings = {
      java = {
        -- project-specific java settings go here
      }
    },
    init_options = {
      bundles = bundles
    },
    -- on_attach: set keymaps and enable dap wiring
    on_attach = function(client, bufnr)
      -- Typical LSP keymaps (change or extend to your taste)
      local function bufmap(mode, lhs, rhs, desc)
        if desc then desc = "jdtls: " .. desc end
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap=true, silent=true, desc = desc })
      end

      bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto definition")
      bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto implementation")
      bufmap("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover")
      bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
      bufmap("n", "<leader>oi", "<cmd>lua require('jdtls').organize_imports()<CR>", "Organize imports")
      bufmap("n", "<leader>ev", "<cmd>lua require('jdtls').extract_variable()<CR>", "Extract variable")
      bufmap("n", "<leader>em", "<cmd>lua require('jdtls').extract_method()<CR>", "Extract method")

      -- Setup dap for Java (register adapter) if we have bundles
      if #bundles > 0 then
        -- enable the java debug adapter (register adapter)
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        -- also set up nvim-dap-ui if installed (optional)
        pcall(function()
          require("dapui").setup()
        end)
      end
    end,
  }

  return config
end

-- Auto-start/attach when opening Java files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local config = require("custom.jdtls").setup()
    local jdtls_ok, jdtls = pcall(require, "jdtls")
    if not jdtls_ok then
      vim.notify("nvim-jdtls is not installed", vim.log.levels.ERROR)
      return
    end
    jdtls.start_or_attach(config)
  end
})

return M

