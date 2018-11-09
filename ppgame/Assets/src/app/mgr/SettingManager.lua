-------------------------
-- 配置表
-------------------------
module("setting", package.seeall)

T_multy_language = setting.Get("app.configs.T_multy_language")
T_sensitive_cfg = setting.Get("app.configs.T_sensitive_cfg")
T_net_fail = setting.Get("app.configs.T_net_fail")
T_guide_cfg = setting.Get("app.configs.T_guide_cfg")
T_advertise = setting.Get("app.configs.T_advertise")

------------------------------------------------------------------------------------------------------

------------------
-- 多语言
------------------
if device.platform == "windows" then
	local language_map = {}
	for id, text in pairs(T_multy_language) do
		assert( not language_map[text], string.format("重复了：%s(%s和%s)",text,id,language_map[text]) )
		language_map[text] = id
	end
	assert(table.size(language_map)==table.size(T_multy_language), "多语言表有重复")
	language_map = nil
end 

function GetMultyMsg(msgId)
	assert(T_multy_language[msgId], "未配置多语言："..msgId)
	return T_multy_language[msgId]
end

------------------
--剧情
------------------
function GetStoryCfg(sStoryName)
	local filepath = string.format("app.configs.storys/%s", sStoryName)
	return setting.Get(filepath)
end
