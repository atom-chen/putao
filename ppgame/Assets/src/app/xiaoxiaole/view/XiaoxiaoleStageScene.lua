-------------------------
-- 消消乐关卡页面
-------------------------
module("xiaoxiaole", package.seeall)

clsXiaoxiaoleStageScene = class("clsXiaoxiaoleStageScene", clsScene)

function clsXiaoxiaoleStageScene:ctor()
	clsScene.ctor(self)
	local rootlayer = utils.LoadCsb("xiaoxiaole/XxlStageUI.csb")
	self:addChild(rootlayer)
	utils.getNamedNodes(rootlayer, self)
	self:InitUI()
	self:RefleshStageInfo()
end

function clsXiaoxiaoleStageScene:dtor()
	
end

function clsXiaoxiaoleStageScene:InitUI()
	local ScrollView_1 = self.ScrollView_1
	local idx = 0
	local objList = {}
	self._stageBtns = objList
	local stageInfoList = T_stages_info
	
	local sz = ScrollView_1:getContentSize()
	local autoGrid = clsAutoGrid.new(sz.width, sz.height, 0, 0)
	autoGrid:Begin()
	local resNormal, resPressed = "xiaoxiaole/xxl_play/normalFlower3.png", ""
	for lvl, info in ipairs(stageInfoList) do
		local stageBtn = ccui.Button:create(resNormal, resPressed, "", ccui.TextureResType.plistType)
		KE_SetParent(stageBtn, ScrollView_1)
		idx = idx + 1
		table.insert(objList, stageBtn)
		stageBtn._stageInfo = info
		utils.RegClickEvent(stageBtn, function() 
			local usrInfo = kGameCache():getCacheData("usrInfo")
			local passLevel = usrInfo and usrInfo.passLevel or 1
			if info.level > passLevel then
				Toast("请先通关第"..passLevel.."关")
			else
				g_curLevel = lvl
				ClsSceneManager.GetInstance():Turn2Scene("clsXiaoxiaoleGameScene")
			end
		end)
	end
	autoGrid:AddRow(objList, 5, sz.width/5, 150, "left", 1)
	local totalHei = autoGrid:End()
	ScrollView_1:setInnerContainerSize(cc.size(sz.width,totalHei))
	
	for _, stageBtn in ipairs(objList) do
		local labStage = utils.CreateLabel(stageBtn._stageInfo.level, 24, cc.c3b(66,66,66))
		ScrollView_1:addChild(labStage)
		local x, y = stageBtn:getPosition()
		labStage:setPosition(x,y-16)
	end 
end

function clsXiaoxiaoleStageScene:RefleshStageInfo()
	local usrInfo = kGameCache():getCacheData("usrInfo") or {
		passLevel = 1,
		stageInfo = {},
	}
	local passLevel = usrInfo.passLevel
	local stageInfo = usrInfo.stageInfo
	logger.dump(usrInfo)

	for i = 1, passLevel do
		local scoreLevel = T_stages_info[i].scoreLevel
		local score = stageInfo[i] or 0
		local starlvl = 0
		
		local stageBtn = self._stageBtns[i]
		local space = 25
		local x, y = stageBtn:getPosition()
		for j = 1, 3 do
			if score >= scoreLevel[j] then 
				starlvl = j 
				local x, y = stageBtn:getPosition()
				local star = display.newSprite("#xiaoxiaole/xxl_play/flowerStar" .. j .. ".png")
				star:setPosition(x + (j - 2) * space, y - 65)
				self.ScrollView_1:addChild(star)
			end
		end
	end
end

const.SCENE_CFG.clsXiaoxiaoleStageScene = { scene_cls = clsXiaoxiaoleStageScene }
