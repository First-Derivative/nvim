require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

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
  "--glob '.env*'",
  "--glob '**/.env*'",
  excluded_paths,
}, " ")

local env_file_find_command = string.format(
  "{ rg --files --color never %s; rg --files --color never %s; } | sort -u",
  excluded_paths,
  env_only_globs
)

local env_file_grep_command = table.concat({
  'pattern="$1"',
  "shift",
  "{",
  string.format(
    '  rg --color=never --no-heading --with-filename --line-number --column --smart-case %s -- "$pattern" "$@"',
    excluded_paths
  ),
  string.format(
    '  rg --color=never --no-heading --with-filename --line-number --column --smart-case %s -- "$pattern" "$@"',
    env_only_globs
  ),
  "} | sort -u",
}, "; ")

local function find_files_with_env()
  require("telescope.builtin").find_files {
    prompt_title = "Find Files (.env*)",
    find_command = { "sh", "-c", env_file_find_command },
  }
end

local function live_grep_with_env()
  require("telescope.builtin").live_grep {
    prompt_title = "Live Grep (.env*)",
    vimgrep_arguments = { "sh", "-c", env_file_grep_command },
  }
end

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>ff", find_files_with_env, { desc = "telescope find files + .env*" })
map("n", "<leader>fw", live_grep_with_env, { desc = "telescope live grep + .env*" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
