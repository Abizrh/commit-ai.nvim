local M = {}

function M.default_prompt(diff, format_lines)
  return string.format(
    [[
Analyze the following Git diff and suggest commit messages.

Follow this format exactly:
- <icon> <prefix> (<scope>): <commit message>

Use one of the options below for <icon> and <prefix>, depending on the change type:

%s

Rules:
1. Only use the above icons and prefixes.
2. Use "chore" for configuration files (*.yml, *.json, *.env), CI/CD changes, build systems, or general non-code tasks.
3. Use "fix" for bug fixes.
4. Use "feat" ONLY for user-facing features or newly introduced functionality.
5. Use "docs" for documentation-only changes, including README.md and LICENSE.
6. Use "refactor" for breaking internal code changes that don’t affect functionality.
7. Use "enhance" for performance improvements or minor internal enhancements.
8. The scope in parentheses should reflect the affected module or file group (e.g., doctor, config, auth).
9. Keep commit message short and imperative (e.g., "add config for <context>

Git diff:
%s
]],
    table.concat(format_lines, "\n"),
    diff
  )
end

return M
