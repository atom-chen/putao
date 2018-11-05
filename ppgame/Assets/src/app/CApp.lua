-------------------------
-- 应用类
-------------------------
ClsApp = class("ClsApp")
ClsApp.__is_singleton = true

function ClsApp:ctor()
	self:InitGLEnviroument()
	self:InitAppEvents()
end

function ClsApp:dtor()
	self:Exit()
end

-- 初始化director和glview
function ClsApp:InitGLEnviroument()
	local theDirector = cc.Director:getInstance()
	local theGLView = theDirector:getOpenGLView()
	if nil == theGLView then
		theGLView = cc.GLView:create("KuEngine")
	    theDirector:setOpenGLView(theGLView)
	end
--	theGLView:setDesignResolutionSize(GAME_CONFIG.DESIGN_W, GAME_CONFIG.DESIGN_H, cc.ResolutionPolicy.SHOW_ALL)
	theDirector:setDisplayStats(GAME_CONFIG.ShowFps)
	theDirector:setAnimationInterval(1.0 / GAME_CONFIG.FPS)
	cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	theDirector:setProjection(cc.DIRECTOR_PROJECTION2_D)
end

-- 初始化App事件
function ClsApp:InitAppEvents()
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	
	local customListenerBg = cc.EventListenerCustom:create("event_come_to_background",function()
	--	logger.normal("切入后台了...")
		if g_EventMgr then g_EventMgr:FireEvent("APP_ENTER_BACKGROUND") end
	end)
	eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
	
	local customListenerFg = cc.EventListenerCustom:create("event_come_to_foreground",function()
	--	logger.normal("切回前台了...")
		if g_EventMgr then g_EventMgr:FireEvent("APP_ENTER_FOREGROUND") end
	end)
	eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)
end

function ClsApp:Exit()
	profiler:stop()
    cc.Director:getInstance():endToLua()
    if device.platform ~= "android" then
    	os.exit(0)
    end 
end

function ClsApp:GetModFileList()
	local ModFileList = {
		--lib
		"lib.common.init",			-- 通用库
		"lib.base.init",			-- 基础库
		--kernel
		"kernel.consts.init",		-- 常量
		"kernel.globals.init",		-- 全局变量与全局函数
		"kernel.platform.init",		-- 平台相关的逻辑
		"kernel.framework.init",	-- cocos框架扩展
		"kernel.objects.init",		-- 渲染对象
		"kernel.utils.init",		-- 辅助接口
		"kernel.net.init",			-- 网络库
		"kernel.smartor.init",		-- 串行播放器
		"kernel.manager.init",		-- 管理器
		"kernel.assist.init",		-- 辅助模块
		--logic
--		"app.configs.init",			-- 配置表
		"app.arpg.init",			-- 游戏逻辑
		"app.VVDirector",			-- 游戏总管理器
	}
	
	return ModFileList
end 

function ClsApp:Run()
	local ModFileList = self:GetModFileList()
	
	--加载lua文件
	logger.normal("***************************************")
	logger.normal("预加载开始")
	local tmOrigin = os.clock()
	local TotalMod = #ModFileList
	local CurIndex = 0
	local theScene = cc.Director:getInstance():getRunningScene()
	theScene:scheduleUpdateWithPriorityLua(function(dt)
		CurIndex = CurIndex + 1
		if ModFileList[CurIndex] then
			local tmStart = os.clock()
			require(ModFileList[CurIndex])
			local iPercent = 100*CurIndex/TotalMod
		--	theProgBar:setPercent(iPercent)
		--	theLabel:setString( string.format("加载中（%d%%）... ...",iPercent) )
			local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
			local event = cc.EventCustom:new("update_scene_loading_res")
			event._usedata = iPercent
			eventDispatcher:dispatchEvent(event)
			
			logger.normal( string.format("进度：%d/%d 用时：%f 模块：%s", CurIndex, TotalMod, os.clock()-tmStart, ModFileList[CurIndex]) )
		else 
			if CurIndex == TotalMod+1 then
			--	theProgBar:setPercent(100)
			--	theLabel:setString( string.format("加载中（%d%%）... ...",100) )
				local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
				local event = cc.EventCustom:new("update_scene_loading_res")
				event._usedata = 100
				eventDispatcher:dispatchEvent(event)
				logger.normal( string.format("预加载完成。用时%f秒，类数量：%d",os.clock()-tmOrigin,table.size(GetAllClass())) )
				logger.normal("***************************************")
				ClsSceneManager:GetInstance()._mCurScene = cc.Director:getInstance():getRunningScene()
				xpcall(function() self:OnPreloadOver() end, __G__TRACKBACK__)
			end
		end
	end, 0)
end

function ClsApp:OnPreloadOver()
	cc.disable_global()	--开始限制全局变量
	
	PlatformHelper.onGameLauch()
	
	--@每帧更新
	local InstTimerMgr = ClsTimerManager.GetInstance()
	local InstUpdator = ClsUpdator.GetInstance()
	local function UpdateEveryFrame(deltaTime)
		InstTimerMgr:FrameUpdate(deltaTime)
		InstUpdator:FrameUpdate(deltaTime)
	end
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(UpdateEveryFrame, 0, false)
	
	--
	cc.SpriteFrameCache:getInstance():addSpriteFrames("uistu/common.plist")
	self:runGame()
end

--游戏
function ClsApp:runGame()
	require("app.arpg.proto.proto_register"):RegisterAllProtocal()
	
	HttpUtil:AddUserCacheProto("req_goucai_game_wanfa_list", HttpUtil.CACHE_TYPE_FOREVER)
	HttpUtil:AddUserCacheProto("req_goucai_game_qiuhao_peilv_list", HttpUtil.CACHE_TYPE_TEMP)
	
	HttpUtil:AddUserTmpProto("req_agent_junior_report_today", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_junior_report_yestoday", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_junior_report_cur_month", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_junior_report_last_month", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_today_report", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_yestoday_report", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_cur_month_report", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_last_month_report", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_agent_junior_member", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_bonus_detailed_get_list", HttpUtil.CACHE_TYPE_FOREVER)
	HttpUtil:AddUserTmpProto("req_user_get_favorite", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddUserTmpProto("req_home_getnotice", HttpUtil.CACHE_TYPE_TEMP)
	
	HttpUtil:AddPublicCacheProto("req_home_homedata", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddPublicCacheProto("req_home_caizhong", HttpUtil.CACHE_TYPE_TEMP)
	HttpUtil:AddPublicCacheProto("req_goucai_all_games", HttpUtil.CACHE_TYPE_TEMP)
	
	HttpUtil:AddQuietProto("req_bet_open_result")
	HttpUtil:AddQuietProto("req_get_ipinfo")
	HttpUtil:AddQuietProto("req_goucai_game_wanfa_list")
	HttpUtil:AddQuietProto("req_goucai_game_qiuhao_peilv_list")
	HttpUtil:AddQuietProto("req_home_homedata")
	HttpUtil:AddQuietProto("req_home_caizhong")
	HttpUtil:AddQuietProto("req_get_game_article_content")
	HttpUtil:AddQuietProto("req_goucai_all_games")
	HttpUtil:AddQuietProto("req_login_logon")
	HttpUtil:AddQuietProto("req_login_get_token_private_key")
	HttpUtil:AddQuietProto("req_award_yestoday")
	HttpUtil:AddQuietProto("req_user_info")
	HttpUtil:AddQuietProto("req_user_nobility")
	HttpUtil:AddQuietProto("req_goucai_game_lhc_sx")
	HttpUtil:AddQuietProto("req_bet_game_state")
	HttpUtil:AddQuietProto("req_bet_open_result")
	HttpUtil:AddQuietProto("req_user_balance")
	HttpUtil:AddQuietProto("req_login_code")
	HttpUtil:AddQuietProto("req_home_sysinfo")
	HttpUtil:AddQuietProto("req_user_get_favorite")
    HttpUtil:AddQuietProto("req_agent_junior_report_today")
    HttpUtil:AddQuietProto("req_agent_junior_report_yestoday")
    HttpUtil:AddQuietProto("req_agent_junior_report_cur_month")
    HttpUtil:AddQuietProto("req_agent_junior_report_last_month")
	HttpUtil:AddQuietProto("req_agent_today_report")
    HttpUtil:AddQuietProto("req_agent_yestoday_report")
    HttpUtil:AddQuietProto("req_agent_cur_month_report")
    HttpUtil:AddQuietProto("req_agent_last_month_report")
	HttpUtil:AddQuietProto("req_grade_uplevel_img")
	HttpUtil:AddQuietProto("req_grade_grade_info")
	HttpUtil:AddQuietProto("req_daily_reward_reward_info")
	HttpUtil:AddQuietProto("req_user_today_earn")
	HttpUtil:AddQuietProto("req_activity_list")
	HttpUtil:AddQuietProto("req_redbag_openstate")
	HttpUtil:AddQuietProto("req_redbag_ranklist")
	HttpUtil:AddQuietProto("req_redbag_detail")

	--
	VVDirector:Init()
	
	--
	g_EventMgr:AddListener(self, "NET_CONNECTING", function(thisObj)
		utils.TellMe("开始连接服务器")
	end)
	g_EventMgr:AddListener(self, "NET_CONNECT_SUCC", function(thisObj)
		utils.TellMe("成功连接服务器")
	end)
	g_EventMgr:AddListener(self, "NET_DISCONNECTED", function(thisObj)
		utils.TellMe("连接服务器失败")
	end)
	
	ClsStateMachine.GetInstance():StartUp()
end


