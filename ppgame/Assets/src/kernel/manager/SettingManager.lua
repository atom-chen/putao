-------------------------
-- 配置表
-------------------------
module("setting", package.seeall)

function Get(sFilePath)
	return require(sFilePath)
end

function UnLoad(sFilePath)
	unquire(sFilePath)
end

function ReLoad(sFilePath)
	UnLoad(sFilePath)
	return self:Get(sFilePath)
end
