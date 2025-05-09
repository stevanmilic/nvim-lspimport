# LSP Import

Resolves imports for undefined terms by using LSP completion API. It's primary
usage is to support automatic imports for `pyright` language server.

https://github.com/stevanmilic/nvim-lspimport/assets/6879030/5a7868e8-e09b-41e2-a5ec-bd2eacb9c1e0

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


If you want to customize the appearance of the import selection window (used when multiple auto-import options are found), you can pass additional options to `vim.ui.select`.

For example, if you are using `telescope.nvim` as the `vim.ui.select` backend, you can control the layout as follows:

```lua
{
  "stevanmilic/nvim-lspimport",
  config = function()
    require("lspimport").cfg.select_config = {
      telescope = {
        layout_config = {
          width = 0.8,
          height = 0.3,
        },
      },
    }
  end,
}
```

## Supported language servers

- [pyright](https://github.com/microsoft/pyright) (python)

NOTE: In order for `pyright` to resolve an import, module containing it should
be used in the workspace; otherwise import won't be found. Hence the
auto-import feature works well in modules loaded with pre-loaded imports.
[Auto-imports are limited to only those symbols and modules that have been
imported somehwhere else in the
program.](https://github.com/microsoft/pyright/issues/967#issuecomment-679417083)
