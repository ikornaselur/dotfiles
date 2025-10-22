local settings = require("config.settings")

local M = {}

function M.build_formatter_map()
	local map = {}
	for ft, cfg in pairs(settings.languages) do
		if cfg.formatters and #cfg.formatters > 0 then
			map[ft] = cfg.formatters
		end
	end
	return map
end

return M
