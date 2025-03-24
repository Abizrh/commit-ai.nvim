local log = require("commit-ai.log")
local M = {}

function M.get_git_diff()
  local staged_diff = vim.fn.system('git diff --cached --no-color')
  if staged_diff == "" then
    staged_diff = vim.fn.system('git diff --no-color')
  end
  staged_diff = staged_diff:gsub("^%s*(.-)%s*$", "%1") -- Remove trailing newlines

  -- Check if we're in a git repository
  if vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'):find("true") == nil then
    log.error("Not in a git repository")
    return nil
  end

  -- Check if there are any changes
  if staged_diff == "" then
    log.warn("No changes detected")
    return nil
  end

  return staged_diff
end

return M
