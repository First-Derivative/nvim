require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

local function map_alt_window(key, command, desc)
  map("n", "<M-w>" .. key, command, { desc = desc })
end

local excluded_paths = table.concat({
  "--glob '!.git/**'",
  "--glob '!**/.git/**'",
  "--glob '!node_modules/**'",
  "--glob '!**/node_modules/**'",
  "--glob '!.yarn/**'",
  "--glob '!**/.yarn/**'",
}, " ")

local env_only_globs = table.concat({
  "--hidden",
  "--no-ignore",
  "--glob '.env'",
  "--glob '.env*'",
  "--glob '*.env'",
  "--glob '**/.env'",
  "--glob '**/.env*'",
  "--glob '**/*.env'",
  excluded_paths,
}, " ")

local env_file_find_command = string.format(
  "{ rg --files --color never %s; rg --files --color never %s; } | sort -u",
  excluded_paths,
  env_only_globs
)

local env_only_find_command = string.format("rg --files --color never %s", env_only_globs)

local function find_files_with_env()
  require("telescope.builtin").find_files {
    prompt_title = "Find Files (.env*)",
    find_command = { "sh", "-c", env_file_find_command },
  }
end

local function live_grep_with_env()
  local env_files = vim.fn.systemlist({ "sh", "-c", env_only_find_command })

  if vim.v.shell_error == 0 and #env_files > 0 then
    require("telescope.builtin").live_grep {
      prompt_title = "Live Grep Env Files",
      search_dirs = env_files,
    }
  elseif vim.v.shell_error ~= 0 then
    vim.notify("Failed to enumerate .env* files for live grep", vim.log.levels.WARN)
  else
    vim.notify("No env files found for live grep", vim.log.levels.INFO)
  end
end

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>ff", find_files_with_env, { desc = "telescope find files + .env*" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fe", live_grep_with_env, { desc = "telescope live grep env files" })

map("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "toggle inlay hints" })
map("n", "<leader>to", "<cmd>TSToolsOrganizeImports<CR>", { desc = "TS organize imports" })
map("n", "<leader>ti", "<cmd>TSToolsAddMissingImports<CR>", { desc = "TS add missing imports" })
map("n", "<leader>tu", "<cmd>TSToolsRemoveUnusedImports<CR>", { desc = "TS remove unused imports" })
map("n", "<leader>tf", "<cmd>TSToolsFixAll<CR>", { desc = "TS fix all" })
map("n", "<leader>tr", "<cmd>TSToolsFileReferences<CR>", { desc = "TS file references" })
map("n", "<leader>tg", "<cmd>TSToolsGoToSourceDefinition<CR>", { desc = "TS go to source definition" })
map("n", "<leader>tq", "<cmd>cclose<CR>", { desc = "close quickfix window" })

-- Support an Alt-w prefix for common window commands alongside built-in <C-w>.
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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
