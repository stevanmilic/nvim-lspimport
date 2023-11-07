# LSP Import

Resolves imports for undefiend terms by using LSP completion API. It's primary
usage is to support automatic imports for `pyright` language server.

Currently tested on neovim **nightly** only.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "stevanmilic/lsp-import" }
```

## Configuration

Mappings are not set by default, hence it's required to set a mapping for resolving import:

```lua
vim.keymap.set("n", "<leader>a", require("lsp-import").import, { noremap = true })
```

Once mapping is set, jump on the line with an undefined term and execute
mapping to resolve import.

## Supported language servers

- [pyright](https://github.com/microsoft/pyright) (python)
