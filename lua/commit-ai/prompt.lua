local locales = require('commit-ai.locales')
local _plugin

local function get_plugin()
  if not _plugin then
    _plugin = require('commit-ai')
  end
  return _plugin
end

local M = {}

function M.default_prompt(diff, format_lines)
  local config = get_plugin().config

  local header = table.concat({
    "Analyze the following Git diff and suggest commit messages.",
    "",
    "Follow this format exactly:",
    "- <icon> <prefix> (<scope>): <commit message>",
    "",
    "Commit rules:",
    "0. Use " .. config.language .. " for commit messages.",
    "1. Only use the above icons and prefixes.",
    "2. Use \"chore\" for configuration files (*.yml, *.json, *.env), CI/CD changes, build systems, or general non-code tasks.",
    "3. Use \"fix\" for bug fixes.",
    "4. Use \"feat\" ONLY for user-facing features or newly introduced functionality.",
    "5. Use \"docs\" for documentation-only changes, including README.md and LICENSE.",
    "6. Use \"refactor\" for breaking internal code changes that don’t affect functionality.",
    "7. Use \"enhance\" for performance improvements or minor internal enhancements.",
    "8. The <scope> should describe the affected module, file group or folder.",
    "9. Keep commit message concise and written in the imperative mood.",
    "10. Only use lowercase letters in the commit message.",
    "",
  }, "\n")

  local conventions_block = table.concat(format_lines, "\n")

  local diff_block = "\n\nGit diff:\n" .. diff

  local lang_name = locales[config.language] or locales.en

  local footer = ("\n\nLanguage: %s\n\n" ..
                  "Please provide the commit message in the format specified above."):format(lang_name)

  return header
       .. conventions_block
       .. diff_block
       .. footer
end

return M
