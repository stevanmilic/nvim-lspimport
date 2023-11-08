# LSP Import

Resolves imports for undefined terms by using LSP completion API. It's primary
usage is to support automatic imports for `pyright` language server.

https://github.com/stevanmilic/lsp-import/assets/6879030/0699c307-b566-4bc3-af7d-858b39bf8a83

Currently tested on neovim **nightly** only.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "stevanmilic/nvim-lspimport" }
```

## Configuration

Mappings are not set by default, hence it's required to set a mapping for resolving import:

```lua
vim.keymap.set("n", "<leader>a", require("lspimport").import, { noremap = true })
```

Once mapping is set, jump on the line with an undefined term and execute
mapping to resolve import.

## Supported language servers

- [pyright](https://github.com/microsoft/pyright) (python)

NOTE: In order for `pyright` to resolve an import, module containing it should
be used in the workspace; otherwise import won't be found. Hence the
auto-import feature works well in modules loaded with pre-loaded imports.
