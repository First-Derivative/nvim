# NvimTree

The file explorer panel — the sidebar showing your project's directory tree.

## What runs this feature

Three layers:

1. **`nvim-tree.lua`** plugin (`nvim-tree/nvim-tree.lua`) — the actual implementation. A Lua-only Neovim plugin that draws the tree, watches the filesystem, and proxies file operations.
2. **NvChad** ships it as a built-in plugin — declared in `/Users/ash/.local/share/nvim/lazy/NvChad/lua/nvchad/plugins/init.lua` with sensible defaults, so you don't have to register it yourself.
3. **NvChad's default config** (`/Users/ash/.local/share/nvim/lazy/NvChad/lua/nvchad/configs/nvimtree.lua`) sets the look and behavior — no dotfile filter, git highlighting, custom folder glyphs, etc.

Worth knowing: NvChad sets `disable_netrw = true`. Netrw is Vim's built-in directory browser (the thing you see when you `:edit .`). NvimTree replaces it entirely.

## How to interact

### Opening / focusing the panel (NvChad bindings)

| Keys | Action |
|---|---|
| `<C-n>` | Toggle tree (open if closed, close if open) |
| `<leader>e` | Focus the tree window (opens if needed) |

`<leader>e` is more useful when the tree is already visible but your cursor is in a code window.

### Inside the tree (nvim-tree defaults)

These bindings only apply when the cursor is inside the tree buffer.

| Keys | Action |
|---|---|
| `<CR>` / `o` | Open file / expand-collapse directory |
| `l` | Open / expand directory (vim-style) |
| `h` | Close current directory (if on a file, jumps up and closes its parent) |
| `W` | Collapse **all** open directories (everything back to root) |
| `P` | Move cursor to parent directory (no collapse) |
| `-` | Go up one level — sets the parent as the new tree root |
| `<C-v>` | Open file in vertical split |
| `<C-x>` | Open file in horizontal split |
| `<C-t>` | Open file in new tab |
| `<Tab>` | Open in preview (cursor stays in tree) |
| `a` | Create file/folder (end with `/` for a folder) |
| `d` | Delete |
| `r` | Rename |
| `x` | Cut |
| `c` | Copy |
| `p` | Paste |
| `y` | Yank name |
| `Y` | Yank relative path |
| `gy` | Yank absolute path |
| `R` | Refresh tree |
| `H` | Toggle dotfiles |
| `I` | Toggle gitignored files |
| `?` | Show full keymap help (always-available cheat sheet) |
| `q` | Close tree |

`?` is the one to remember — pulls up the full reference inside the tree.

### Useful commands

| Command | Action |
|---|---|
| `:NvimTreeToggle` | Toggle (what `<C-n>` runs) |
| `:NvimTreeFocus` | Focus (what `<leader>e` runs) |
| `:NvimTreeFindFile` | Open tree and reveal the current buffer's file |
| `:NvimTreeCollapse` | Collapse all open folders |
| `:NvimTreeResize 60` | Set width to 60 cols |

`:NvimTreeFindFile` is the genuinely useful one — "where is this file in the tree?"

## Minimal config

NvChad declares the plugin spec for you, so you only need to override the options you want changed. lazy.nvim deep-merges your `opts` table on top of NvChad's defaults.

In `lua/plugins/init.lua`:

```lua
{
  "nvim-tree/nvim-tree.lua",
  opts = {
    view = {
      side = "right",
      width = 50,
    },
  },
},
```

This config currently overrides:

| Setting | Value | Effect |
|---|---|---|
| `view.side` | `"right"` | Tree on the right side of the editor |
| `view.width` | `50` | 50-column-wide tree (NvChad default is 30) |

Apply changes without restarting: `:Lazy reload nvim-tree.lua`.

### Other common things people change

| Setting | What it does |
|---|---|
| `filters.dotfiles = true` | Hide `.eslintrc`, `.git`, etc. by default (press `H` to toggle) |
| `git.ignore = false` | Show files listed in `.gitignore` |
| `actions.open_file.quit_on_open = true` | Auto-close tree when you pick a file |
| `update_focused_file.update_root = true` | Re-root tree as you jump around projects |
| `renderer.indent_markers.enable` | Toggle the vertical indent guides |
