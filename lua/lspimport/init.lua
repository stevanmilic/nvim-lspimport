local ms = require("vim.lsp.protocol").Methods
local servers = require("lspimport.servers")

local LspImport = {}

---@return Diagnostic[]
local get_unresolved_import_errors = function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if vim.tbl_isempty(diagnostics) then
        return {}
    end
    ---@param diagnostic Diagnostic
    return vim.tbl_filter(function(diagnostic)
        local server = servers.get_server(diagnostic)
        if server == nil then
            return false
        end
        return server.is_unresolved_import_error(diagnostic)
    end, diagnostics)
end

---@param server lspimport.Server
---@param result lsp.CompletionList|lsp.CompletionItem[] Result of `textDocument/completion`
---@param unresolved_import string
---@return table[]
local get_auto_import_complete_items = function(server, result, unresolved_import)
    -- TODO: use vim.lsp.util.text_document_completion_list_to_complete_items
    -- once stabilized on nvim API.
    local items = require("vim.lsp._completion")._lsp_to_complete_items(result, unresolved_import)
    if vim.tbl_isempty(items) then
        return {}
    end
    return vim.tbl_filter(function(item)
        return item.word == unresolved_import
            and item.user_data
            and item.user_data.nvim
            and item.user_data.nvim.lsp.completion_item
            and item.user_data.nvim.lsp.completion_item.labelDetails
            and item.user_data.nvim.lsp.completion_item.labelDetails.description
            and server.is_auto_import_completion_item(item)
    end, items)
end

---@param item any|nil
local resolve_import = function(item)
    if item == nil then
        return
    end
    vim.lsp.util.apply_text_edits(item.user_data.nvim.lsp.completion_item.additionalTextEdits, 0, "utf-8")
end

---@param item any
local format_import = function(item)
    return item.abbr .. " " .. item.kind .. " " .. item.user_data.nvim.lsp.completion_item.labelDetails.description
end

---@param server lspimport.Server
---@param result lsp.CompletionList|lsp.CompletionItem[] Result of `textDocument/completion`
---@param unresolved_import string
local lsp_completion_handler = function(server, result, unresolved_import)
    if vim.tbl_isempty(result or {}) then
        vim.notify("no import found for " .. unresolved_import)
        return
    end
    local items = get_auto_import_complete_items(server, result, unresolved_import)
    if vim.tbl_isempty(items) then
        vim.notify("no import found for " .. unresolved_import)
        return
    end
    if #items == 1 then
        resolve_import(items[1])
    else
        vim.ui.select(
            items,
            { prompt = "Select Import For " .. unresolved_import, format_item = format_import },
            resolve_import
        )
    end
end

---@param diagnostic Diagnostic
local lsp_completion = function(diagnostic)
    local unresolved_import = vim.api.nvim_buf_get_text(
        diagnostic.bufnr,
        diagnostic.lnum,
        diagnostic.col,
        diagnostic.end_lnum,
        diagnostic.end_col,
        {}
    )
    if vim.tbl_isempty(unresolved_import) then
        vim.notify("cannot find diagnostic symbol")
        return
    end
    local server = servers.get_server(diagnostic)
    if server == nil then
        vim.notify("cannot find server implemantion for lsp import")
        return
    end
    local params = {
        textDocument = vim.lsp.util.make_text_document_params(0),
        position = { line = diagnostic.lnum, character = diagnostic.end_col },
    }
    return vim.lsp.buf_request(0, ms.textDocument_completion, params, function(_, result)
        lsp_completion_handler(server, result, unresolved_import[1])
    end)
end

LspImport.import = function()
    vim.schedule(function()
        local diagnostics = get_unresolved_import_errors()
        if vim.tbl_isempty(diagnostics) then
            vim.notify("no unresolved import error")
            return
        end
        for _, diagnostic in ipairs(diagnostics) do
            lsp_completion(diagnostic)
        end
    end)
end

return LspImport
