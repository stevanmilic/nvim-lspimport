local M = {}

---@class lsp-import.Server
---@field is_unresolved_import_error fun(diagnostic: Diagnostic): boolean
---@field is_auto_import_completion_item fun(item: any): boolean

local function pyright_server()
    -- Builds a test path from the current position in the tree.
    ---@param diagnostic Diagnostic
    ---@return boolean
    local function is_unresolved_import_error(diagnostic)
        return diagnostic.code == "reportUndefinedVariable"
    end

    --- Builds a command for running tests for the framework.
    ---@param item any
    ---@return boolean
    local function is_auto_import_completion_item(item)
        return item.menu == "Auto-import"
    end

    return {
        is_unresolved_import_error = is_unresolved_import_error,
        is_auto_import_completion_item = is_auto_import_completion_item,
    }
end

---Returns a server class.
---@param diagnostic Diagnostic
---@return lsp-import.Server|nil
function M.get_server(diagnostic)
    if diagnostic.source == "Pyright" then
        return pyright_server()
    end
end

return M
