local Utils = require("commit-ai.utils")
local Job = require('plenary.job')
local Log = require("commit-ai.log")
local Common = require("commit-ai.backends.common")

local M = {}

function M.is_available()
  local config = require("commit-ai").config
  return (config.provider_options.gemini.api_key) and true or false
end

-- if not M.is_available() then
--   Log.error("Gemini API_KEY is not set")
-- end

function M.call_ai(prompt, cb)
  local commit_ai = require("commit-ai")
  local options = vim.deepcopy(commit_ai.config.provider_options.gemini)

  local request_data = {
    contents = {
      {
        parts = {
          {
            text = prompt
          }
        }
      }
    }
  }

  local tmp_file = os.tmpname()
  local f = io.open(tmp_file, "w")
  if f ~= nil then
    f:write(vim.json.encode(request_data))
    f:close()
  end

  local args = {
    '-X', 'POST',
    string.format(
      'https://generativelanguage.googleapis.com/v1beta/models/%s:%skey=%s',
      options.model,
      -- options.stream and 'streamGenerateContent?alt=sse&' or
      'generateContent?',
      (options.api_key)
    ),
    '-H', 'Content-Type: application/json',
    '-d', '@' .. tmp_file
  }


  local new_job = Job:new {
    command = "curl",
    args = args,
    on_exit = vim.schedule_wrap(function(job, exit_code)
      os.remove(tmp_file)

      if exit_code ~= 0 then
        Log.error("API request failed with exit code " .. exit_code)
        if cb then cb(nil) end
        return
      end

      local result = table.concat(job:result(), "\n")

      local success, parsed = pcall(vim.json.decode, result)

      if not success then
        Log.error("Failed to parse JSON API response: " .. parsed)
        if cb then cb(nil) end
        return
      end

      if cb then cb(parsed) end
    end)
  }

  -- Common.register_job(new_job)
  new_job:start()

  return new_job
end

return M
