module("xiaoxiaole", package.seeall)

local SystemManager = class("SystemManager")

function SystemManager:getInsance()
	if not SystemManager._instance then
		SystemManager._instance = SystemManager.new()
	end
	return SystemManager._instance
end

function SystemManager:ctor()
	self:calculate_scale_ratio();
end

function SystemManager:calculate_scale_ratio()
	
    self.disignRatio = 640/960
    self.activeRatio = display.width/display.height

    self.ratioScale = self.activeRatio/self.disignRatio
end

--全屏设置
function SystemManager:setNodeFullScreen( node )
	if isnull (node) then 
		return ;
	end 
	local size = node:getContentSize()

	local sw = display.width/size.width
	local sh = display.height/size.height
    node:setScale(math.max(sw, sh))
end

function SystemManager.releaseInstance()
    SystemManager._instance = nil
end


function SystemManager:delay_do (callback, time)
	local scheduler 		= require("framework.scheduler")
	time					= checknumber (time or 1)
	return scheduler.performWithDelayGlobal (callback, time)
end


function SystemManager:timer (callback, time)
	local scheduler 		= require("framework.scheduler")
	time					= checknumber (time or 1)
	return scheduler.scheduleGlobal (callback, time)
end


function SystemManager:update (callback)
	local scheduler 		= require("framework.scheduler")
	time					= checknumber (time or 1)
	return scheduler.scheduleUpdateGlobal (callback, time)
end


function SystemManager:close_handler (handler)
	local scheduler 		= require("framework.scheduler")
	if handler then
		scheduler.unscheduleGlobal (handler)
	end
end


kSystemManager = function ()
	return SystemManager.getInsance ()
end

return SystemManager