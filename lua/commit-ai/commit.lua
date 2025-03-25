local M = {}
local Utils = require("commit-ai.utils")
local pickers = require("telescope.pickers")
local Log = require("commit-ai.log")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local telescope = require("telescope.builtin")
local backends = require("commit-ai.backends.gemini")

local function query_ai(prompt, cb)
  backends.call_ai(prompt, function(response)
    -- TODO: need to handle error from gemini
    if response then
      local commit_messages = {}
      if response.candidates and response.candidates[1] and response.candidates[1].content then
        local content = response.candidates[1].content.parts[1].text
        for line in content:gmatch("%- ([^\n]+)") do
          table.insert(commit_messages, line)
        end
      end

      cb(commit_messages)
    else
      print("No response received")
      cb({})
    end
  end)
end

local function generate_commit_suggestions(cb)
  local diff = Utils.get_git_diff()
  if not diff or diff == "" then
    print("No staged changes found")
    return {}
  end

  local config = require("commit-ai").config
  local git_conventions = config.git_conventions
  local format_lines = {}
  for _, convention in pairs(git_conventions) do
    table.insert(format_lines, string.format("- %s %s: %s", convention.icon, convention.prefix, convention.type))
  end

  local prompt = string.format(
    "Analyze this git diff and generate commit messages in plain text.\n" ..
    "Use exactly this format without additional explanation:\n\n" ..
    "- <icon> <prefix>: <commit message>\n\n" ..
    "Options:\n%s\n\nGit diff:\n%s",
    table.concat(format_lines, "\n"),
    diff
  )

  -- local prompt = string.format(
  --   "Analyze this git diff and generate multiple commit messages using exactly one of these formats:\n" ..
  --   "Format:\n" ..
  --   "- <icon> <prefix>: <commit message>\n\n" ..
  --   "Only respond with the commit messages, without any explanations.\n\n" ..
  --   "- %s %s: Documentation changes\n" ..
  --   "- %s %s: Bug fix\n" ..
  --   "- %s %s: New feature\n" ..
  --   "- %s %s: Chore\n" ..
  --   "- %s %s: Breaking change\n" ..
  --   "- %s %s: Enhancement\n\n" ..
  --   "Git diff:\n%s",
  --   git_conventions.docs.icon, git_conventions.docs.prefix,
  --   git_conventions.fix.icon, git_conventions.fix.prefix,
  --   git_conventions.feat.icon, git_conventions.feat.prefix,
  --   git_conventions.chore.icon, git_conventions.chore.prefix,
  --   git_conventions.refactor.icon, git_conventions.refactor.prefix,
  --   git_conventions.enhance.icon, git_conventions.enhance.prefix,
  --   diff
  -- )
  query_ai(prompt, cb)
end

local diff_previewer = previewers.new_buffer_previewer({
  title = "Git Diff Preview",
  get_buffer_by_name = function()
    return "Git Diff"
  end,
  define_preview = function(self, entry)
    local diff = Utils.get_git_diff()
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(diff, "\n"))
    vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "diff")
  end
})

-- TODO: lets try to call default_config directly here
function M.setup(config)
  local default_config = require("commit-ai.config")
  M.config = vim.tbl_deep_extend('force', default_config, config or {})
end

function M.commit_picker()
  generate_commit_suggestions(function(commit_suggestions)
    if not commit_suggestions or #commit_suggestions == 0 then
      print("No commit suggestions available")
      return
    end

    pickers.new({}, {
      prompt_title = "Select Commit Message",
      finder = finders.new_table({
        results = commit_suggestions,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = diff_previewer,
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          local cmd = string.format('git commit -m "%s"', selection.value)
          -- TODO:as for now we still add the staged changes into one single commit
          -- later it should be possible to add each change into a separate commit
          vim.fn.system('git add .')
          vim.fn.system(cmd)
          print("Committed: " .. selection.value)
        end)
        return true
      end,
    }):find()
  end)
end

vim.api.nvim_create_user_command("Commit", function()
  M.commit_picker()
end, {})

return M
