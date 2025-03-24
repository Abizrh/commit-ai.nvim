local M = {}

-- default config
M.config = {
  conventions = {
    docs = { icon = "📖", prefix = "docs", type = "Documentation changes" },
    fix = { icon = "🐛", prefix = "fix", type = "Bug fix" },
    feat = { icon = "✨", prefix = "feat", type = "New feature" },
    enhance = { icon = "⚡", prefix = "enhance", type = "Enhancement" },
    chore = { icon = "🧹", prefix = "chore", type = "Chore" },
    refactor = { icon = "⚠️", prefix = "refactor", type = "Breaking change" }
  },
  provider_options = {
    openai = {
      api_key = 'YOUR_API_KEY',
    },
    gemini = {
      api_key = 'YOUR_API_KEY',
    },
    claude = {
      api_key = 'YOUR_API_KEY',
    },
  }
}

return M
