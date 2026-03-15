-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = "|"
vim.g.maplocalleader = "\\"

vim.g.snacks_animate = false
-- vim.g.lazyvim_ui_statuscolumn = false
vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_mini_snippets_in_completion = false
vim.g.deprecation_warnings = true
vim.g.lazyvim_prettier_needs_config = true
-- vim.opt_local.spell = true

local opt = vim.opt

opt.autowrite = false
opt.autoread = false
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
-- opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}
opt.foldlevel = 99
opt.backup = false
opt.writebackup = false
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatexpr = "v:lua.LazyVim.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" --nosplit -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 1 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = false
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.swapfile = false
opt.relativenumber = true -- Relative line numbers
opt.ruler = true -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos", "help", "globals", "skiprtp", "folds", "localoptions" }
--vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos", "terminal", "localoptions" }
opt.shortmess:append({ S = false, W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4 -- Number of spaces tabs count for
opt.shiftwidth = 4 -- Size of an indent
opt.shiftround = true -- Round indent
opt.breakindent = true -- default for lazyvim was false
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.filetype.add({
    extension = {
        env = "sh",
        apex = "apexcode",
        cls = "apexcode",
        trigger = "apexcode",
        page = "visualforce",
        component = "visualforce",
    },
    filename = {
        [".env"] = "sh",
    },
    pattern = {
        ["%.env%.[%w_.-]+"] = "sh",
        ["%.cls"] = "apexcode",
    },
})

vim.g.mode_colors = {
    n = "StatusLineSection",
    v = "StatusLineSectionV",
    ["^V"] = "StatusLineSectionV", -- ^V (visual block)
    i = "StatusLineSectionI",
    c = "StatusLineSectionC",
    r = "StatusLineSectionR",
}

vim.g.statusline_left = "[%n]%#StatusLine# %<%f%r%h%m%w"
vim.g.statusline_extra_right = ""

function StatusLineRenderer()
    local m = vim.fn.mode():lower()
    local hl = "%#" .. (vim.g.mode_colors[m] or vim.g.mode_colors.n) .. "#"
    return hl .. vim.g.statusline_left .. " %=" .. vim.g.statusline_extra_right .. " %y %-14.(%l,%c%V%)%P "
end

-- only set default statusline once on initial startup
if vim.fn.has("vim_starting") == 1 then
    vim.o.statusline = vim.g.statusline_left
end

local statusline_group = vim.api.nvim_create_augroup("statusline_update", { clear = true })

-- show focussed buffer statusline
vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = statusline_group,
    callback = function()
        vim.wo.statusline = "%!v:lua.StatusLineRenderer()"
    end,
})

-- show blurred buffer statusline
vim.api.nvim_create_autocmd({ "FocusLost", "VimLeave", "WinLeave" }, {
    group = statusline_group,
    callback = function()
        vim.wo.statusline = ""
    end,
})

-- Toggle laststatus between 1 and 2
local function toggle_laststatus()
    if vim.o.laststatus == 2 then
        vim.o.laststatus = 1
    else
        vim.o.laststatus = 2
    end
end

vim.keymap.set("n", "<F9>", toggle_laststatus, { silent = true })
vim.keymap.set("v", "<F9>", toggle_laststatus, { silent = true })
vim.keymap.set("i", "<F9>", toggle_laststatus, { silent = true })
