# LSP Type Hints (Inlay Hints)

Ghost-text annotations like `: string` or `param:` that appear inline next to your code without you typing them.

## What runs this feature

Three cooperating layers:

1. **Neovim core** — `vim.lsp.inlay_hint` is built into Neovim (≥ 0.10). It's the renderer that draws the ghost text. No plugin required for the display.
2. **An LSP server** — produces the hint data. In this config:
   - `typescript-tools.nvim` (`lua/plugins/init.lua:17`) wraps TypeScript's `tsserver` directly via its native protocol (faster than the standard `ts_ls` LSP bridge). This is what generates hints for `.ts/.tsx/.js/.jsx`.
   - `nvim-lspconfig` with `html`, `cssls`, `jsonls` (`lua/configs/lspconfig.lua:3`) — these don't really emit inlay hints in practice.
3. **The hint settings** — `tsserver_file_preferences` in `lua/plugins/init.lua` controls which kinds of hints are requested (parameter names, return types, etc.). These keys are forwarded straight to tsserver.

Inlay hints are **off by default** in this config (the auto-enable on attach was removed). Toggle via `<leader>th`.

## How to interact

| Keys / Command | Action | Source |
|---|---|---|
| `<leader>th` | Toggle inlay hints in current buffer | this config |
| `<leader>to` | TS organize imports | this config |
| `<leader>ti` | TS add missing imports | this config |
| `<leader>tu` | TS remove unused imports | this config |
| `<leader>tf` | TS fix all | this config |
| `<leader>tr` | TS file references | this config |
| `<leader>tg` | TS go to source definition | this config |
| `gra` | Code action menu (includes TS-specific actions) | Neovim 0.11 default |
| `:LspInfo` | Show attached servers for current buffer | nvim-lspconfig |
| `:TSToolsRenameFile` | Rename file + update imports across project | typescript-tools |

## Minimal config

The hint kinds are controlled by `tsserver_file_preferences` in `lua/plugins/init.lua`. The boolean / `"all"` toggles map 1:1 to TypeScript options:

```lua
tsserver_file_preferences = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = false,                   -- noisiest one; off
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
},
```

Setting `includeInlayVariableTypeHints = true` annotates every `const`/`let` — usually too noisy.

The toggle keymap (in `lua/mappings.lua`):

```lua
map("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "toggle inlay hints" })
```
