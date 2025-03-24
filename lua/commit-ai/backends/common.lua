local Log = require("commit-ai.log")
local M = {}

---@param job Job
function M.register_job(job)
    table.insert(M.current_jobs, job)
    Log.info("Registered completion job")
end

return M
