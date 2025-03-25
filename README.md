# 🧠commit-ai.nvim

A Neovim plugin for committing with AI

## Installation

### Lazy

```lua
{
    'Abizrh/commit-ai.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        require('commit-ai').setup {
          icons = false,
          -- unopiniated commit conventions
          git_conventions = {
            docs = { icon = "📖", prefix = "docs", type = "Documentation changes" },
            fix = { icon = "🐛", prefix = "fix", type = "Bug fix" },
            feat = { icon = "✨", prefix = "feat", type = "New feature" },
            enhance = { icon = "⚡", prefix = "enhance", type = "Enhancement" },
            chore = { icon = "🧹", prefix = "chore", type = "Chore" },
            refactor = { icon = "⚠️", prefix = "refactor", type = "Breaking change" }
          },
          provider_options = {
            gemini = {
              model = 'gemini-2.0-flash',
              api_key = 'YOUR_API_KEY',
              stream = false,
            },
          }
        }
    end,
},
```

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.
