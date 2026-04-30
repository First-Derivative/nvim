# Window Navigation

## What runs this feature

Pure **Neovim core** — no plugins involved. Windows are built-in: a single Neovim instance can split its screen into multiple "windows" (viewports), each showing a buffer. The whole window system lives under the `<C-w>` prefix.

Terms worth pinning down:

- **Buffer** — an in-memory copy of a file's contents. Invisible until something displays it.
- **Window** — a viewport showing a buffer. Splits create more windows.
- **Tab** — a *layout* of windows. Closer to a virtual desktop than a browser tab. NvChad's tab bar at the top is showing **buffers**, not tabs.

This config adds one customization: `lua/mappings.lua` defines a helper that mirrors common `<C-w>` commands under an `<M-w>` (Alt-w) prefix:

```lua
local function map_alt_window(key, command, desc)
  map("n", "<M-w>" .. key, command, { desc = desc })
end
```

So most `<C-w>x` actions are also reachable as `<M-w>x`.

## How to interact

### Movement between windows

| Keys | Action |
|---|---|
| `<C-w>h` / `<M-w>h` | Move left |
| `<C-w>j` / `<M-w>j` | Move down |
| `<C-w>k` / `<M-w>k` | Move up |
| `<C-w>l` / `<M-w>l` | Move right |
| `<C-w>w` | Cycle to next window |
| `<C-w>p` | Jump to previous (last-used) window — useful for ping-ponging |
| `<C-w>t` / `<C-w>b` | Top-most / bottom-most window |

### Creating splits

| Keys / Command | Action |
|---|---|
| `<C-w>v` / `<M-w>v` | Vertical split (new window to the right) |
| `<C-w>s` / `<M-w>s` | Horizontal split (new window below) |
| `:vsp {file}` / `:sp {file}` | Split *and* open a specific file |

### Closing

| Keys | Action |
|---|---|
| `<C-w>q` / `<M-w>q` | Close current window |
| `<C-w>o` / `<M-w>o` | Close **all other** windows (zoom current) |
| `<C-w>c` | Close window but keep the buffer loaded |

### Resizing

| Keys | Action |
|---|---|
| `<C-w>>` / `<M-w>>` | Wider |
| `<C-w><` / `<M-w><` | Narrower |
| `<C-w>+` / `<M-w>+` | Taller |
| `<C-w>-` / `<M-w>-` | Shorter |
| `<C-w>=` / `<M-w>=` | Equalize all windows |
| `<C-w>_` / `<M-w>_` | Maximize height |
| `<C-w>\|` / `<M-w>\|` | Maximize width |
| `10<C-w>>` | Prefix with a count — widen by 10 columns instead of 1 |

### Moving windows around

| Keys | Action |
|---|---|
| `<C-w>H` / `J` / `K` / `L` | Move current window to far left / bottom / top / right (converts split orientation) |
| `<C-w>r` | Rotate windows clockwise |
| `<C-w>x` | Swap current window with next |
| `<C-w>T` | Move current window into a new tab |

### Tabs (related but separate)

| Keys / Command | Action |
|---|---|
| `:tabnew` | Open a new tab |
| `gt` / `gT` | Next / previous tab |
| `:tabclose` | Close tab |

## Minimal config

The whole customization (in `lua/mappings.lua`):

```lua
local function map_alt_window(key, command, desc)
  map("n", "<M-w>" .. key, command, { desc = desc })
end

map_alt_window("h", "<C-w>h", "window left")
map_alt_window("j", "<C-w>j", "window down")
map_alt_window("k", "<C-w>k", "window up")
map_alt_window("l", "<C-w>l", "window right")
map_alt_window("v", "<C-w>v", "window vertical split")
map_alt_window("s", "<C-w>s", "window horizontal split")
map_alt_window("q", "<C-w>q", "window close")
map_alt_window("o", "<C-w>o", "window close others")
map_alt_window(">", "<C-w>>", "window increase width")
map_alt_window("<", "<C-w><", "window decrease width")
map_alt_window("+", "<C-w>+", "window increase height")
map_alt_window("-", "<C-w>-", "window decrease height")
map_alt_window("=", "<C-w>=", "window equalize")
map_alt_window("|", "<C-w>|", "window maximize width")
map_alt_window("_", "<C-w>_", "window maximize height")
```

Adding more is one line per binding.

## Useful options

- **`:setlocal winfixbuf`** — lock the window to its current buffer. Useful if you keep accidentally opening files into your terminal/help split.
- **`vim.o.splitkeep = "screen"`** — keep the screen position stable when splits open or close (otherwise content jumps). Not set by default in this config; add to `lua/options.lua` if jumps annoy you.
