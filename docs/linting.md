# Linting

> **Status:** No dedicated linter plugin is installed. The "squiggles" you see come from LSP diagnostics, not a linter.

## What gives you lint-like diagnostics today

Even without a linter plugin, red/yellow squiggles appear because:

1. **LSP diagnostics** — surfaced through Neovim's built-in `vim.diagnostic` API. Every attached LSP server publishes diagnostics via the `textDocument/publishDiagnostics` LSP method. Neovim renders them as virtual text, signs in the gutter, and underlines.
2. **The compiler/typechecker behind that LSP** — for `.ts/.tsx`, those squiggles are TypeScript's type errors from `tsserver` (proxied by typescript-tools), not ESLint rules.

So:
- "Missing comma" / "type mismatch" → tsserver (you have this).
- "Don't use `any`" / "prefer-const" → ESLint (you don't have this).

**Linters** specifically mean style/quality rules outside of typechecking — `eslint`, `ruff`, `shellcheck`, `markdownlint`, `selene`, etc. To plug those in, you need a runner (see below).

## How to interact with diagnostics

These work today for LSP-supplied diagnostics — see [Diagnostics & Quickfix Hotkeys](diagnostics-quickfix.md) for the full list.

| Keys / Command | Action |
|---|---|
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>de` | Show diagnostic float for cursor | 
| `<leader>ds` | Diagnostics for current buffer → loclist (NvChad) |
| `<leader>dq` | All diagnostics → quickfix |
| `<leader>fd` | Telescope diagnostics |

## How to add a real linter

The standard pattern is **nvim-lint** (`mfussenegger/nvim-lint`). Same shape as conform: it's a runner; the actual linters are external CLIs.

### 1. Add the plugin spec to `lua/plugins/init.lua`

```lua
{
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("configs.lint")
  end,
},
```

### 2. Create `lua/configs/lint.lua`

```lua
local lint = require("lint")

lint.linters_by_ft = {
  javascript      = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescript      = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function() require("lint").try_lint() end,
})
```

### 3. Install the CLI

```sh
npm i -g eslint_d
```

`eslint_d` is the daemonized eslint — much faster than vanilla `eslint`. It reuses your project's local `.eslintrc` / `eslint.config.js`. Diagnostics flow through the same `vim.diagnostic` channel as LSP ones, so all the keymaps above work unchanged.

## nvim-lint vs ESLint-as-LSP

Two patterns recommended online:

| Approach | Pros | Cons |
|---|---|---|
| **nvim-lint** | Simple, transparent, no LSP gymnastics | Lint-on-save only; no fix-on-save built in |
| **eslint-lsp / vtsls** | Fix-on-save, code actions | More moving parts, can clash with typescript-tools |

For this setup (where typescript-tools already handles TS itself), **nvim-lint is the cleaner addition** — it stays out of the LSP layer.
