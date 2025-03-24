local log = {}

local p = "[commit-ai.nvim] "

function log.info(txt)
    vim.notify(p .. txt)
end

function log.error(txt)
    vim.notify(p .. txt)
end

return log
