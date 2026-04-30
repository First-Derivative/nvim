# Formatting

Auto-formatting that runs on save and reshapes code (indentation, quotes, line breaks). Distinct from linting — formatters don't reason about correctness, they just apply style rules.

## What runs this feature

Three layers:

1. **conform.nvim** (`lua/plugins/init.lua:3`) — the orchestrator. Picks the right formatter for the buffer's filetype, runs it as a subprocess, and applies the diff back to the buffer. Does **not** ship any formatters itself.
2. **External CLI tools** — the actual formatters:
   - `stylua` — Lua formatter (Rust binary)
   - `prettier` — JS/TS/CSS/HTML/JSON/Markdown formatter (Node CLI)

   Must exist on `$PATH`. Verify with `which stylua` / `which prettier`.
3. **`BufWritePre` autocmd** — triggers conform before each save. Set in `lua/plugins/init.lua` (`event = 'BufWritePre'`) and again via `format_on_save` in `lua/configs/conform.lua`. With `lsp_fallback = true`, if no formatter is configured, it falls back to whatever the attached LSP exposes via `textDocument/formatting`.

## How to interact

| Keys / Command | Action |
|---|---|
| `:w` | Format and save (automatic) |
| `:lua require("conform").format()` | Manual format current buffer |
| `:ConformInfo` | Show available formatters and configuration for current filetype |
| `:noa w` | Save **without** running autocmds — skip format-on-save once |

No keymap for manual format is bound by default.

## Minimal config

Whole config is in `lua/configs/conform.lua`:

```lua
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
  },

  formatters = {
    prettier = {
      prepend_args = function(self, ctx)
        if ctx.filename:match("%.tpl$") then
          return { "--parser", "json" }
        end
        return {}
      end,
    },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
```

The `prettier` block is a per-formatter override: any `.tpl` file gets `--parser json` appended (Helm/template files treated as JSON).

### Adding a language

```lua
python = { "ruff_format" },
```

### Chaining formatters

```lua
typescript = { "prettier", "prettier_plugin_organize_imports" },  -- runs in order
```

### Per-buffer escape hatch

To allow disabling format-on-save per buffer, convert `format_on_save` to a function:

```lua
format_on_save = function(bufnr)
  if vim.b[bufnr].disable_autoformat then return end
  return { timeout_ms = 500, lsp_fallback = true }
end,
```

Then `:lua vim.b.disable_autoformat = true` skips it in the current buffer.
