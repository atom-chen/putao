module("xiaoxiaole", package.seeall)

local f_secret = "LHP0522pp"
local crypto = require("kernel.framework.crypto")
local json = require("kernel.framework.json")
local GameState = require("app.xiaoxiaole.mgr.GameState") 
local GameCacheData = {}

local GameCache = class("GameCache")

function GameCache.getInstance()
	if not GameCache.s_instance then 
		GameCache.s_instance = GameCache.new()
	end
	return GameCache.s_instance;
end

function GameCache.releaseInstance()
	GameCache.s_instance = nil
end

function GameCache:ctor()
	local stateListener = function(event)
		if event.errorCode then
			print("ERROR, load:" .. event.errorCode)
			return
		end
		local returnValue = nil
		if "load" == event.name then
			local str = crypto.decryptXXTEA(event.values.data, f_secret)
			returnValue = json.decode(str)

		elseif "save" == event.name then
			local str = json.encode(event.values)
			if str then
				str = crypto.encryptXXTEA(str, f_secret)
				returnValue = {data = str}
			else
				print("ERROR, encode fail")
				return
			end
		end
		return returnValue
	end
	GameState.init(stateListener, "xxldata.txt", f_secret)
end

function GameCache:load()
	dump(GameState.getGameStatePath())
	if io.exists(GameState.getGameStatePath()) then
		GameCacheData = GameState.load() or {}
		dump(GameCacheData, "GameCacheData :")
	end
end

function GameCache:save()
	GameState.save(GameCacheData)
end

function GameCache:getCacheData(cacheName)
	local cacheData = nil
	if GameCacheData ~= nil then
		cacheData = GameCacheData[cacheName]
	end
	return cacheData
end

function GameCache:saveCacheData(cacheName, cacheData, save_now)
	dump(cacheData, cacheName .. " GameCache:saveCacheData : ")
	if GameCacheData == nil or cacheName == nil or cacheData == nil then
		return
	end
	GameCacheData[cacheName] = cacheData
	
	if save_now == nil or save_now == true then 
		self:save()
	end 
end


kGameCache = function ()
	return GameCache.getInstance()
end

return GameCache