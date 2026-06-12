return {
    {
        "folke/persistence.nvim",
        enabled = false,
        -- event = "BufReadPre",
        opts = {},
        keys = {
            {
                "<localleader>Zq",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<localleader>Ze",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<localleader>Zr",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<localleader>Zw",
                function()
                    require("persistence").save()
                end,
                desc = "Save Session",
            },
            {
                "<localleader>Zp",
                function()
                    require("persistence").select()
                end,
                desc = "Select Session",
            },
            {
                "<localleader>Zz",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<localleader>Zd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
    {
        "rmagatti/auto-session",
        enabled = true,
        lazy = false,
        keys = {
            { "<localleader>Zw", "<cmd>AutoSession save<CR><cmd>wqa<cr>", mode = { "n", "v" }, desc = "save quit all + save session" },
            { "<localleader>ZW", "<cmd>AutoSession save<CR><cmd>wa<cr>", mode = { "n", "v" }, desc = "save all + save session" },
            { "<localleader>Zw", "<cmd>AutoSession save<CR>", mode = { "n", "v" }, desc = "Save Session" },
            { "<localleader>ZW", ":AutoSession save ", mode = { "n", "v" }, desc = "Save Session with name" },
            {
                "<localleader>Zz",
                function()
                    local filepath = vim.api.nvim_buf_get_name(0)
                    local as = require("auto-session")
                    as.save_session()
                    vim.ui.input({ prompt = "New session name: " }, function(name)
                        if not name or name == "" then
                            return
                        end
                        vim.cmd("silent! tabonly")
                        vim.cmd("silent! only")
                        vim.cmd("silent! %bwipeout!")
                        if filepath ~= "" then
                            vim.cmd("edit " .. vim.fn.fnameescape(filepath))
                        end
                        as.save_session(name)
                    end)
                end,
                mode = { "n", "v" },
                desc = "New named session (current file only)",
            },
            { "<localleader>Zr", "<cmd>AutoSession restore<CR>", mode = { "n", "v" }, desc = "Restore Session" },
            { "<localleader>ZR", ":AutoSession restore ", mode = { "n", "v" }, desc = "Restore Session with name" },
            {
                "<localleader>Zl",
                function()
                    local as = require("auto-session")
                    local cur = vim.v.this_session
                    if cur == nil or cur == "" then
                        vim.notify("No active session to reload", vim.log.levels.WARN)
                        return
                    end
                    as.restore_session_file(cur, { show_message = true })
                end,
                mode = { "n", "v" },
                desc = "Reload current session",
            },
            { "<localleader>Ze", "<cmd>AutoSession search<CR>", mode = { "n", "v" }, desc = "Search Session" },
            { "<localleader>Zd", "<cmd>AutoSession deletePicker<CR>", mode = { "n", "v" }, desc = "Delete Session Picker" },
            { "<localleader>Zf", "<cmd>AutoSession delete<CR>", mode = { "n", "v" }, desc = "Delete Session" },
            { "<localleader>ZF", ":AutoSession delete ", mode = { "n", "v" }, desc = "Delete Session with name" },
            { "<localleader>ZD", "<cmd>AutoSession purgeOrphaned<CR>", mode = { "n", "v" }, desc = "Purge Orphaned Session" },
            {
                "<localleader>ZH",
                function()
                    local cur = vim.v.this_session
                    if cur == nil or cur == "" then
                        vim.notify("No active session", vim.log.levels.INFO)
                        return
                    end
                    local name = vim.fn.fnamemodify(cur, ":t:r")
                    name = name:gsub("%%(%x%x)", function(hex)
                        return string.char(tonumber(hex, 16))
                    end)
                    vim.notify("Session: " .. name, vim.log.levels.INFO)
                end,
                mode = { "n", "v" },
                desc = "Show current session name",
            },
            { "<localleader>Zt", "<cmd>AutoSession enable<CR>", mode = { "n", "v" }, desc = "Enable Autosave Session" },
            { "<localleader>ZT", "<cmd>AutoSession disable<CR>", mode = { "n", "v" }, desc = "Disable Autosave Session" },
        },
        config = function()
            require("auto-session").setup({
                -- log_level = 'debug',
                -- Saving / restoring
                enabled = true, -- Enables/disables auto creating, saving and restoring
                auto_save = true, -- Enables/disables auto saving session on exit
                auto_restore = true, -- Enables/disables auto restoring session on start
                auto_create = true, -- Enables/disables auto creating new session files. Can be a function that returns true if a new session file should be allowed
                auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
                cwd_change_handling = false, -- Automatically save/restore sessions when changing directories
                single_session_mode = false, -- Enable single session mode to keep all work in one session regardless of cwd changes. When enabled, prevents creation of separate sessions for different directories and maintains one unified session. Does not work with cwd_change_handling

                -- Filtering
                suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" }, -- Suppress session restore/create in certain directories
                allowed_dirs = nil, -- Allow session restore/create in certain directories
                bypass_save_filetypes = nil, -- List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
                close_filetypes_on_save = { "checkhealth" }, -- Buffers with matching filetypes will be closed before saving
                close_unsupported_windows = true, -- Close windows that aren't backed by normal file before autosaving a session
                preserve_buffer_on_restore = nil, -- Function that returns true if a buffer should be preserved when restoring a session

                -- Git / Session naming
                git_use_branch_name = false, -- Include git branch name in session name, can also be a function that takes an optional path and returns the name of the branch
                git_auto_restore_on_branch_change = false, -- Should we auto-restore the session when the git branch changes. Requires git_use_branch_name
                custom_session_tag = nil, -- Function that can return a string to be used as part of the session name

                -- Deleting
                auto_delete_empty_sessions = true, -- Enables/disables deleting the session if there are only unnamed/empty buffers when auto-saving
                purge_after_minutes = nil, -- Sessions older than purge_after_minutes will be deleted asynchronously on startup, e.g. set to 14400 to delete sessions that haven't been accessed for more than 10 days, defaults to off (no purging), requires >= nvim 0.10

                -- Saving extra data
                save_extra_data = nil, -- Function that returns extra data that should be saved with the session. Will be passed to restore_extra_data on restore
                restore_extra_data = nil, -- Function called when there's extra data saved for a session

                -- Argument handling
                args_allow_single_directory = true, -- Follow normal session save/load logic if launched with a single directory as the only argument
                args_allow_files_auto_save = false, -- Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. Can be true or a function that returns true when saving is allowed. See documentation for more detail

                -- Misc
                log_level = "error", -- Sets the log level of the plugin (debug, info, warn, error).
                root_dir = vim.fn.stdpath("data") .. "/sessions/", -- Root dir where sessions will be stored
                show_auto_restore_notif = false, -- Whether to show a notification when auto-restoring
                restore_error_handler = nil, -- Function called when there's an error restoring. By default, it ignores fold errors otherwise it displays the error and returns false to disable auto_save
                continue_restore_on_error = true, -- Keep loading the session even if there's an error
                lsp_stop_on_restore = false, -- Should language servers be stopped when restoring a session. Can also be a function that will be called if set. Not called on autorestore from startup
                lazy_support = true, -- Automatically detect if Lazy.nvim is being used and wait until Lazy is done to make sure session is restored correctly. Does nothing if Lazy isn't being used
                legacy_cmds = true, -- Define legacy commands: Session*, Autosession (lowercase s), currently true. Set to false to prevent defining them

                ---@type SessionLens
                session_lens = {
                    picker = nil, -- "telescope"|"snacks"|"fzf"|"select"|nil Pickers are detected automatically but you can also set one manually. Falls back to vim.ui.select
                    load_on_setup = true, -- Only used for telescope, registers the telescope extension at startup so you can use :Telescope session-lens
                    picker_opts = nil, -- Table passed to Telescope / Snacks / Fzf-Lua to configure the picker. See below for more information

                    ---@type SessionLensMappings
                    mappings = {
                        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                        delete_session = { "i", "<C-d>" }, -- mode and key for deleting a session from the picker
                        alternate_session = { "i", "<C-s>" }, -- mode and key for swapping to alternate session from the picker
                        copy_session = { "i", "<C-y>" }, -- mode and key for copying a session from the picker
                    },

                    ---@type SessionControl
                    session_control = {
                        control_dir = vim.fn.stdpath("data") .. "/auto_session/", -- Auto session control dir, for control files, like alternating between two sessions with session-lens
                        control_filename = "session_control.json", -- File name of the session control file
                    },
                },
            })
        end,
    },
}
