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
	unquire(sFilePath)
	return require(sFilePath)
end
