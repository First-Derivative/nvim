# Nvim Concept Tour

A wiki of Neovim concepts as they apply to this NvChad-based config. Each page follows the same shape:

1. **What runs the feature** — the actual layers (Neovim core, plugin, external CLI).
2. **How to interact** — commands and keymaps, with a column showing what's bound in *this* config.
3. **Minimal config** — the smallest knobs that matter, with file:line references.

## Pages

- [LSP Type Hints](lsp-type-hints.md) — inlay hints via typescript-tools
- [Formatting](formatting.md) — conform.nvim + prettier/stylua, format-on-save
- [Linting](linting.md) — diagnostics flow, why there's no linter plugin yet
- [Diagnostics & Quickfix Hotkeys](diagnostics-quickfix.md) — navigation, code actions, undo
- [Window Navigation](window-navigation.md) — splits, movement, resize

## Pending topics

- Sessions (`:mksession`)
- Markers (marks)

## Where things live

| File | Purpose |
|---|---|
| `init.lua` | Entrypoint — bootstraps lazy.nvim and NvChad |
| `lua/options.lua` | Vim options (`vim.o.*`) |
| `lua/mappings.lua` | All custom keymaps |
| `lua/autocmds.lua` | Autocommands |
| `lua/chadrc.lua` | NvChad theme/UI overrides |
| `lua/plugins/init.lua` | Plugin specs (lazy.nvim) |
| `lua/configs/lazy.lua` | lazy.nvim runtime config |
| `lua/configs/lspconfig.lua` | LSP server enable list |
| `lua/configs/conform.lua` | Formatter config |
