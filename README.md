# 🧠commit-ai.nvim

A Neovim plugin for committing with AI



https://github.com/user-attachments/assets/b6e6aa6c-85a8-42b1-994c-fa3ffe80d760

## Features
- **Automated Commit Message Generation** – Analyzes changes (git diff) and generates commit messages automatically.
- **AI-Powered Suggestions** – UsesAI to create meaningful commit messages.
- **Multiple Commit Message Options** – Provides different commit types (feat, fix, chore, enhancement, etc.).

## Requirements

- Neovim 0.10+.
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- An API key for at least one of the supported AI providers


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

## Usage

| Command               | Description                                             |
| --------------------- | ------------------------------------------------------- |
| `:Commit`      | Generate a commit message suggestions with AI |

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.
