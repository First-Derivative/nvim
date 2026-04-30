# Diagnostics & Quickfix Hotkeys

A reference for navigating errors (file-local and codebase-wide), running quick fixes, and using undo.

## Diagnostics — current file

| Keys | Action | Source |
|---|---|---|
| `]d` / `[d` | Next / previous diagnostic | Neovim default |
| `<leader>de` | Show diagnostic float (full message under cursor) | this config |
| `<leader>ds` | Send file's diagnostics to **location list** (per-window list, scoped to this buffer) | NvChad |

After `<leader>ds`:
- `:lopen` / `:lclose` — show/hide loclist panel
- `:lnext` / `:lprev` — next/prev item

## Diagnostics — entire codebase

| Keys / Command | Action | Source |
|---|---|---|
| `<leader>dq` | All loaded diagnostics → quickfix list | this config |
| `<leader>fd` | Telescope diagnostics (fuzzy picker, best UX) | this config |
| `:lua vim.diagnostic.setqflist()` | Same as `<leader>dq` | Neovim core |

> Caveat: only buffers that have actually been opened/loaded by an LSP show up. To get truly project-wide errors, run `tsc --noEmit` in the terminal and pipe to quickfix, or use a linter.

## Quickfix list

Quickfix is the project-wide list (one global). Vim built-ins:

| Keys / Command | Action |
|---|---|
| `<leader>co` | Open quickfix window (this config) |
| `<leader>cq` | Close quickfix window (this config) |
| `<leader>tq` | Close quickfix window (alias, this config) |
| `]q` / `[q` | Next / previous quickfix item (this config) |
| `:cnext` / `:cprev` | Next / prev item |
| `:cfirst` / `:clast` | First / last item |
| `:cdo {cmd}` | Run a command on every quickfix entry (e.g. `:cdo s/foo/bar/g \| update`) |
| `<C-q>` (in Telescope) | Send all picker results to quickfix |

## Quick fixes (LSP code actions)

| Keys | Action |
|---|---|
| `gra` | Code action menu (Neovim 0.11 default) — general fix entry point |
| `<leader>tf` | TS Fix All — applies tsserver auto-fixes file-wide |
| `<leader>to` | TS organize imports |
| `<leader>ti` | TS add missing imports |
| `<leader>tu` | TS remove unused imports |
| `<leader>ra` | Rename symbol (NvChad NvRenamer UI) |

`gra` lists every available fix at the cursor — LSP code actions plus tsserver's "Move to a new file", "Convert to async function", etc. (since `expose_as_code_action = "all"` is set in typescript-tools).

## Undo / redo

| Keys / Command | Action |
|---|---|
| `u` | Undo |
| `<C-r>` | Redo |
| `U` | Undo all changes on the current line |
| `g-` / `g+` | Step back/forward through the undo **tree** (handles divergent branches) |
| `:earlier 5m` / `:later 5m` | Time-travel: state of buffer 5 minutes ago / forward |
| `:earlier 10` / `:later 10` | Same, by edit count |
| `:undolist` | Print undo branches |

The `earlier`/`later` commands are the genuinely useful trick — faster than spamming `u` to roll back many edits.

## Underlying APIs

| Layer | Surface |
|---|---|
| Neovim core | `vim.diagnostic.*` (open_float, setloclist, setqflist, goto_next, goto_prev, get) |
| Vim built-in | quickfix (`:cope`, `:cnext`, …) and location list (`:lope`, `:lnext`, …) commands |
| Telescope | `:Telescope diagnostics`, `:Telescope quickfix`, `:Telescope loclist` |
