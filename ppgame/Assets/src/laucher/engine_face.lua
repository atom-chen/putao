-------------------
-- 被引擎调用
-------------------
-- call by engine
function updateDownloadGame(percent)
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	local event = cc.EventCustom:new("updateDownloadGame")
	event._usedata = percent
	eventDispatcher:dispatchEvent(event)
end

-- call by engine
function networkStateChange(sState)
	local bConnected = isNetworkConnected()
	CheckNetConnect()
	--
	if not PlatformHelper or not PlatformHelper.isNetworkConnected then return end
	if ClsUIManager then
		if not bConnected then
			ClsUIManager.GetInstance():PopConfirmDlg("CFM_NET_STATE", "", "网络连接异常，请检查网络状况", nil, nil, nil, 1)
		else
			ClsUIManager.GetInstance():CloseConfirmDlg("CFM_NET_STATE")
		end
	end
	if g_EventMgr then 
		g_EventMgr:FireEvent("NET_STATE_CHANGE", bConnected)
	end
end

-- call by engine 
function batteryChange(sPercent)
	
end
