# LSP Import

Resolves imports for undefined terms by using LSP completion API. It's primary
usage is to support automatic imports for `pyright` language server.

![lsp-import](https://github.com/stevanmilic/lsp-import/assets/6879030/458df24e-09b4-495a-8caf-d500a9bb1bcc)

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

NOTE: In order for `pyright` to resolve an import, module containing it should
be used in the workspace; otherwise import won't be found. Hence the
auto-import feature works well in modules loaded with pre-loaded imports.
