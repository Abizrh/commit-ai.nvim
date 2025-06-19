# 🧠commit-ai.nvim

https://github.com/user-attachments/assets/a6ce9da9-b9fd-4801-8c00-acd05021a0a1

**commit-ai** is a Neovim plugin that automatically generates commit messages using AI and summarizes changes properly! 💡



## Features

- **Automated Commit Message Generation** – Analyzes changes (git diff) and generates commit messages automatically.
- **AI-Powered Suggestions** – UsesAI to create meaningful commit messages.
- **Multiple Commit Message Options** – Provides different commit types (feat, fix, chore, enhancement, etc.).
- **Multiple Commit Languages** – Supports multiple commit message languages.

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
          language = 'en', -- default language
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
              api_key = vim.env.GEMINI_API_KEY, -- assuming you have set GEMINI_API_KEY in .zshrc or .bashrc
              stream = false,
            },
          }
        }
    end,
},
```

## Usage

| Command   | Description                                   |
| --------- | --------------------------------------------- |
| `:Commit` | generate a commit message suggestions with AI |

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.
