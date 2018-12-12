-------------------------
-- 总管理中心
-- 全局变量在这里定义
-------------------------
VVDirector = {}

--生命周期为到APP结束
function VVDirector:Init()
	if self._isinited then return end
	self._isinited = true
	self.mResMgr = ClsResManager.GetInstance()				--资源管理器
	self.mCacheMgr = ClsCacheManager.GetInstance()			--本地缓存管理器
	self.mLayerMgr = ClsLayerManager.GetInstance()			--层管理器
	self.mSceneMgr = ClsSceneManager.GetInstance()			--场景管理器
	self.mUIMgr = ClsUIManager.GetInstance()				--UI管理器
	self.mWeatherMgr = ClsWeatherManager.GetInstance()		--天气系统
	if GAME_CONFIG.ENABLE_AI_MODULE then
		self.mBTFactory = ai.ClsBTFactory.GetInstance()		--AI Factory
	end
	
	g_EventMgr:AddListener("VVDirector", "ENTER_SCENE", function(thisObj, scene_name)
--		local filename = ClsSceneManager.GetInstance():GetCurSceneCfg().music
--		if filename and filename ~= "" then
--			AudioManager.PlayMusic(filename)
--		end
	end)
	g_EventMgr:AddListener("VVDirector", "LEAVE_SCENE", function(thisObj)
--		AudioManager.StopMusic(true)
	end)
end

function VVDirector:CreateNotificationNode()
	local noti_node = cc.Director:getInstance():getNotificationNode()
	if not noti_node then
		noti_node = cc.Node:create()
		cc.Director:getInstance():setNotificationNode(noti_node)
	end
	assert(cc.Director:getInstance():getNotificationNode(), "noti_node创建失败")
	return noti_node
end

function VVDirector:SyncServerTime(serverTime)
	
end

function VVDirector:GetServerTime()
	return os.time()
end

function VVDirector:GetCaipiaoProcedure() 
	return self.mCaipiaoProcedure 
end

---------------------------------------------------------------------------------

-- 初始化数据
function VVDirector:InitDatas()
	guide.ClsGuideMgr.GetInstance()
	--
	if APP_TYPE == 1 then
		self:InitCaiPiaoData()
	else 
		self:InitArpgDatas()
	end
end

-- 清理数据
function VVDirector:ClearDatas()
	guide.ClsGuideMgr.DelInstance()
	--
	if APP_TYPE == 1 then
		self:ClearCaiPiaoData()
	else 
		self:ClearArpgDatas()
	end
	
	UserDbCache.GetInstance():ClearTmpData()
end

function VVDirector:InitCaiPiaoData()
	self.mCaipiaoProcedure = smartor.clsPromise.new()
	UserEntity.GetInstance()
	--
	ClsAgentDataMgr.GetInstance()
	ClsBankMgr.GetInstance()
	ClsBetHistoryMgr.GetInstance()
	ClsRechargeRecoMgr.GetInstance()
	ClsTitleMgr.GetInstance()
	ClsWithdrawMgr.GetInstance()
	clsFindMgr.GetInstance()
	ClsPlayerInfoMgr.GetInstance()
	clsActiveMgr.GetInstance()
	ClsCollectMgr.GetInstance()
	ClsRedbagMgr.GetInstance()
	--
	ClsGameK3Mgr.GetInstance()
	ClsGameKL10Mgr.GetInstance()
	ClsGameLhcMgr.GetInstance()
	ClsGamePcddMgr.GetInstance()
	ClsGamePk10Mgr.GetInstance()
	ClsGameSscMgr.GetInstance()
	ClsGame11x5Mgr.GetInstance()
	ClsGameYbMgr.GetInstance()
	ClsGameMgr.GetInstance()
end

function VVDirector:ClearCaiPiaoData()
	KE_SafeDelete(self.mCaipiaoProcedure) self.mCaipiaoProcedure = nil
	UserEntity.DelInstance()
	--
	ClsAgentDataMgr.DelInstance()
	ClsBankMgr.DelInstance()
	ClsBetHistoryMgr.DelInstance()
	ClsTitleMgr.DelInstance()
	ClsRechargeRecoMgr.DelInstance()
	ClsWithdrawMgr.DelInstance()
	clsFindMgr.DelInstance()
	ClsPlayerInfoMgr.DelInstance()
	clsActiveMgr.DelInstance()
	ClsCollectMgr.DelInstance()
	ClsRedbagMgr.DelInstance()
	--
	ClsGameK3Mgr.DelInstance()
	ClsGameKL10Mgr.DelInstance()
	ClsGameLhcMgr.DelInstance()
	ClsGamePcddMgr.DelInstance()
	ClsGamePk10Mgr.DelInstance()
	ClsGameSscMgr.DelInstance()
	ClsGame11x5Mgr.DelInstance()
	ClsGameYbMgr.DelInstance()
	ClsGameMgr.DelInstance()
end


-- 初始化数据
function VVDirector:InitArpgDatas()
	self.mRoleDataMgr = ClsRoleEntityMgr.GetInstance()			--角色属性数据
end

-- 清理数据
function VVDirector:ClearArpgDatas()
	self.mRoleDataMgr = ClsRoleEntityMgr.DelInstance()			--角色属性数据
end

function VVDirector:SetMap(mapObj)
	self._the_map = mapObj
end

function VVDirector:GetMap()
	return self._the_map
end

function VVDirector:BindCameraOn(entityObj)
	if self._the_map then self._the_map:BindCameraOn(entityObj) end
end