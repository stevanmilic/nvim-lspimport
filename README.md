# LSP Import

Resolves imports for undefiend terms by using LSP completion API. It's primary
usage is to support automatic imports for `"pyright"`language server.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "stevanmilic/lsp-import" }
```

## Configuration

Mappings are not set by default, hence it's required to set a mapping:

```lua
vim.keymap.set("n", "<leader>a", require("lsp-import").import, { noremap = true })
```
