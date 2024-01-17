# LSP Import

Resolves imports for undefined terms by using LSP completion API. It's primary
usage is to support automatic imports for `pyright` language server.

https://github.com/stevanmilic/nvim-lspimport/assets/6879030/5a7868e8-e09b-41e2-a5ec-bd2eacb9c1e0

Currently tested on neovim **nightly** only.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "stevanmilic/nvim-lspimport" }
```

## Configuration

Mappings are not set by default, hence it's required to set a mapping for resolving imports:

```lua
vim.keymap.set("n", "<leader>a", require("lspimport").import, { noremap = true })
```

Once mapping is set, execute mapping to resolve imports in the current buffer.

## Supported language servers

- [pyright](https://github.com/microsoft/pyright) (python)

NOTE: In order for `pyright` to resolve an import, module containing it should
be used in the workspace; otherwise import won't be found. Hence the
auto-import feature works well in modules loaded with pre-loaded imports.
