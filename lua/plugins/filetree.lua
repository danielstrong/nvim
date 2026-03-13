return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      -- Keymap to toggle the NvimTree
      {
        "<leader>e",
        function()
          local view = require("nvim-tree.view")
          if view.is_visible() and view.get_winnr() == vim.api.nvim_get_current_win() then
            require("nvim-tree.api").tree.close()
          else
            require("nvim-tree.api").tree.focus()
          end
        end,
        desc = "Focus or close NvimTree",
      },
      -- Keymap to open NvimTree to the current file's location
      { "<leader>E", ":NvimTreeFindFileToggle<CR>", desc = "Toggle NvimTree on current file" },
    },
    -- actions = {
    -- open_file = {
    -- quit_on_open = true, -- Close the tree after opening a file in the current window
    -- replacing_current_buffer = true, -- Open the file in the current window/buffer
    -- You can also add other options like 'resize_window'
    -- },
    -- },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        -- Preserve all default nvim-tree keymaps
        api.config.mappings.default_on_attach(bufnr)

        -- Override <leader>c to copy relative path of selected node
        vim.keymap.set("n", "<leader>'c", function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
            local rel = vim.fn.fnamemodify(node.absolute_path, ":.")
            vim.fn.setreg("+", rel)
            vim.notify("Copied: " .. rel)
          end
        end, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy relative path" })

        -- Override <leader>C to copy absolute path of selected node
        vim.keymap.set("n", "<leader>'C", function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
            vim.fn.setreg("+", node.absolute_path)
            vim.notify("Copied: " .. node.absolute_path)
          end
        end, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy absolute path" })
      end

      require("nvim-tree").setup({ on_attach = on_attach })
    end,
  },
}
