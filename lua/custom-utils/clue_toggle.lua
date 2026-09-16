-- Recreates the which-key "toggle icon" (enabled/disabled indicator) for mini.clue.
-- Creates a toggle keymap and keeps its clue description prefixed with an icon
-- reflecting current state, refreshed on creation and on every toggle press.
local M = {}

M.icon = { enabled = "● ", disabled = "○ " }
-- M.icon = { enabled = "✓ ", disabled = "✗ " }
-- M.icon = { enabled = "✔ ", disabled = "✘ " }
-- M.icon = { enabled = "▣ ", disabled = "▢ " }
-- M.icon = { enabled = "⏽ ", disabled = "⭘ " }
-- M.icon = { enabled = "[x] ", disabled = "[ ] " }
-- M.icon = { enabled = "ON  ", disabled = "OFF " }

-- keyed by toggle name so the same toggle mapped to multiple keys stays in sync
local toggles = {}

local do_toggle

local function refresh(name)
    local toggle = toggles[name]
    local ok_get, enabled = pcall(toggle.get)
    local icon = (ok_get and enabled) and M.icon.enabled or M.icon.disabled
    local miniclue = require("mini.clue")
    for _, map in ipairs(toggle.maps) do
        local ok, err = pcall(miniclue.set_mapping_desc, map.mode, map.keys, icon .. map.desc)
        if not ok then
            vim.notify("clue_toggle: failed to set desc for " .. map.keys .. ": " .. tostring(err), vim.log.levels.WARN)
        end
    end
end

do_toggle = function(name)
    local toggle = toggles[name]
    local ok_get, enabled = pcall(toggle.get)
    local state = not (ok_get and enabled)
    local ok_set, err = pcall(toggle.set, state)
    if not ok_set then
        Snacks.notify.error({ "Failed to set state for `" .. name .. "`:\n", err }, { title = name, once = true })
        return
    end
    Snacks.notify((state and "Enabled" or "Disabled") .. " **" .. name .. "**", { title = name, level = state and vim.log.levels.INFO or vim.log.levels.WARN })
    refresh(name)
end

---@class clue_toggle.Map
---@field [1] string
---@field mode? string|string[]
---@field desc? string

---@class clue_toggle.Opts
---@field name string
---@field get fun():boolean
---@field set fun(state:boolean)

---@param map clue_toggle.Map
---@param opts clue_toggle.Opts
function M.toggle_map(map, opts)
    local name = opts.name
    toggles[name] = toggles[name] or { get = opts.get, set = opts.set, maps = {} }
    local toggle = toggles[name]
    toggle.get, toggle.set = opts.get, opts.set

    local keys = map[1]
    local desc = map.desc or ("Toggle " .. name)
    local modes = map.mode or "n"
    if type(modes) == "string" then
        modes = { modes }
    end

    for _, mode in ipairs(modes) do
        vim.keymap.set(mode, keys, function()
            do_toggle(name)
        end, { desc = desc })
        table.insert(toggle.maps, { mode = mode, keys = keys, desc = desc })
    end

    refresh(name)
end

return M
