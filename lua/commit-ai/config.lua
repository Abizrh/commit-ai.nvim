-- default config
local M = {
  -- define for adding icon to your commit msg
  icons = false
}

-- unopiniated commit conventions
M.git_conventions = {
  docs = { icon = "📖", prefix = "docs", type = "Documentation changes" },
  fix = { icon = "🐛", prefix = "fix", type = "Bug fix" },
  feat = { icon = "✨", prefix = "feat", type = "New feature" },
  enhance = { icon = "⚡", prefix = "enhance", type = "Enhancement" },
  chore = { icon = "🧹", prefix = "chore", type = "Chore" },
  refactor = { icon = "⚠️", prefix = "refactor", type = "Breaking change" }
}

-- provider options
M.provider_options = {
  openai = {
    model = 'gpt-4o',
    api_key = 'YOUR_API_KEY',
    stream = false,
  },
  gemini = {
    model = 'gemini-2.0-flash',
    api_key = vim.env.GEMINI_API_KEY,
    stream = false,
  },
  claude = {
    model = 'sonnet',
    api_key = 'YOUR_API_KEY',
    stream = false,
  },
}


return M
