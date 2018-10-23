-------------------------
-- 快3
-------------------------
module("ui", package.seeall)

local json = require("kernel.framework.json")

clsGameK3View = class("clsGameK3View", clsBaseUI)

function clsGameK3View:ctor(parent, gameArg)
	clsBaseUI.ctor(self, parent, "uistu/GameK3.csb")
	self.ScrollViewGame = self.AreaAuto
	self.EditMoney = utils.ReplaceTextField(self.EditMoney, "")
	self.EditMoney:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	if const.MAX_BET_LENGTH then self.EditMoney:setMaxLength(const.MAX_BET_LENGTH) end
	self.ScrollViewGame:setScrollBarWidth(5)
	self.ScrollViewGame:setScrollBarPositionFromCorner(cc.p(2,2)) 
	
	ClsLayerManager.GetInstance():SetKeyboardAniDelegate({self.AreaBottom}, 90)
	
	self._btnFeatureList = {}
	self._gameObj = ClsGameK3Mgr.GetInstance()
	self._billPaper = clsBillPaper.new()
	
	self:InitUiEvents()
	self:InitGlbEvents()
	self:ClearSelectedBalls()
	
	if gameArg then
		self:SetGameArg(gameArg)
	end
end

function clsGameK3View:dtor()
	ClsLayerManager.GetInstance():SetKeyboardAniDelegate()
	ClsGameK3Mgr.GetInstance():DelListener(self)
	ClsGameMgr.GetInstance():LeaveGame()
end

function clsGameK3View:SetGameArg(gameArg)
	self._kithe = nil 
	self._preIssueData = nil
	self.gameArg = gameArg
	self._gameObj:SetGameArg(gameArg)
	
	self.lblGameName:setString(gameArg.name or "")
	self:RefleshBallsArea(nil)
	self.lblCurrent:setString("投注截止")
	self.lblCountDown:setString("")
	self.lblWangQi:setString("开奖号码")
	self.NodeWait:removeAllChildren()
	self._effSaizi = nil
	self.NodeLottery:removeAllChildren()
	self._diceList = nil
	--初始假动画
	if not self._effSaizi then
			self._effSaizi = {}
			local cnt = 3
			for idx=1, cnt do
				self._effSaizi[idx] = self:CreateTouziAni()   --clsEffectSeq.new(-1, "seqani/saizi.plist", self.NodeWait, -1)
				self.NodeWait:addChild(self._effSaizi[idx])
				if self._effSaizi[idx] then
					self._effSaizi[idx]:setScale(0.5)
					self._effSaizi[idx]:setPositionX(50*(idx-(cnt+1)/2))
				end
			end
	end
	self:StartCD(10, gameArg.gid)
	
	self:on_req_bet_game_state(ClsGameMgr.GetInstance():GetGameSate(gameArg.gid), {gid=gameArg.gid}, true)
	self:on_req_bet_open_result(ClsGameMgr.GetInstance():GetOpenResult(gameArg.gid), {gid=gameArg.gid})
	
	proto.req_bet_game_state({gid=gameArg.gid})
	if ClsGameMgr.GetInstance():GetWanfaData(gameArg.gid) then
		print("从缓存读取玩法")
		self:on_req_goucai_game_wanfa_list({data=ClsGameMgr.GetInstance():GetWanfaData(gameArg.gid)}, { gid=gameArg.gid })
	else
		proto.req_goucai_game_wanfa_list({ gid=gameArg.gid }, { gid=gameArg.gid })
	end
	proto.req_bet_open_result({gid=gameArg.gid})
	
	proto.req_user_balance()
	ClsCollectMgr.GetInstance():req_user_get_favorite()
	self:RefleshCollectBtn()
end

--注册控件事件
function clsGameK3View:InitUiEvents()
	utils.RegClickEvent(self.BtnClose, function() 
		self:quitListener()
	end)
	utils.RegClickEvent(self.BtnSelect, function() 
		ClsUIManager.GetInstance():ShowPopWnd("clsGameSelectView"):RefleshUI(self.gameArg.gid, self.gameArg.cptype)
	end)
	utils.RegClickEvent(self.BtnPlayType, function() 
		if not self._wanfaList then return end
		ClsUIManager.GetInstance():ShowPopWnd("clsPlayTypeSelectWnd2", self._wanfaList):RefleshUI(self._selectedWanFa, self._wanfaList.play[1].play, 3, function(info)
			self._gameObj:SetCurWanFa(info)
		end)
	end)
	utils.RegClickEvent(self.BtnClear, function() 
		self:ClearSelectedBalls()
	end)
	utils.RegClickEvent(self.BtnBet, function() 
		self._billPaper:SetCost(self:GetCost())
		if self._billPaper:CheckValid(self._gameObj,true,true) then
			self._gameObj:SetBillPaper(self._billPaper, self._kithe)
			ClsUIManager.GetInstance():ShowPopWnd("clsBetBasketK",nil,false,true):RefleshUI(self._gameObj)
		end
	end)
	self.EditMoney:registerScriptEditBoxHandler(function(evenName, sender)
		local money = tonumber(self.EditMoney:getString()) or 0
		if evenName == "return" then 
			money = math.floor(money) or 0
			if money <= 0 then money = 0 end
			if const.MAX_BET_MONEY and money > const.MAX_BET_MONEY then 
				money = const.MAX_BET_MONEY 
				utils.TellMe("下注额不得高于："..const.MAX_BET_MONEY) 
			end
			if money <= 0 then money = "" end
			self.EditMoney:setString(money)
		elseif evenName == "changed" then
			if const.MAX_BET_MONEY and  money > const.MAX_BET_MONEY then
				utils.TellMe("下注额不得高于："..const.MAX_BET_MONEY)
			end
		end
		self:OnSelectBallChanged()
	end)
	utils.RegClickEvent(self.BtnHistory, function() 
		ClsUIManager.GetInstance():ShowPopWnd("clsK3History",nil,true,false):SetGid(self.gameArg.gid)
	end)
	
	if self.BtnBerRecort then
		utils.RegClickEvent(self.BtnBerRecort, function() 
        	ClsUIManager.GetInstance():ShowPanel("clsBetHistoryView")
		end)
	end
	
    utils.RegClickEvent(self.CheckBoxCollect,function()
        local status = "0"
        if ClsCollectMgr.GetInstance():HasCollect(self.gameArg.gid) then status = "1" end
        local stateInfo = self._gameObj:GetGameStateInfo() or {}
        local tArgs = { 
        	gid = tostring(self.gameArg.gid),
        	status = status,
        	id = tostring(self.gameArg.gid),
        	img = stateInfo.img,
        	name = self.gameArg.name or stateInfo.name,
        	type = stateInfo.cptype,
        }
        proto.req_user_set_favorite(tArgs)
    end)
end

function clsGameK3View:quitListener()
	if self._billPaper:IsEmpty() then
		self:removeSelf()
		return
	end
	ClsUIManager.GetInstance():PopConfirmDlg("CFM_LEAVE_PLAY", "提示", "您确定要清除当前下注并离开游戏？", function(mnuId)
		if mnuId == 1 then
			self:removeSelf()
			ClsUIManager.GetInstance():ShowView("clsHallUI")
		end
	end)
end

function clsGameK3View:RandSelect()
	if self._btnFeatureList and #self._btnFeatureList>=1 then
		if self._preSelect and utils.IsValidCCObject(self._preSelect) then
			self._preSelect:SetSelectedQuiet(false)
			self._billPaper:DelBall(self._preSelect._info.id)
			self:OnSelectBallChanged()
		end
		
		local curBtn = self._btnFeatureList[math.random(1,#self._btnFeatureList)]
		
		if self._billPaper:AddBall(self:GetCost(), curBtn._info, self._gameObj, true) then
			self._preSelect = curBtn
			curBtn:SetSelectedQuiet(true)
			self:OnSelectBallChanged()
			local curY = curBtn:getPositionY() + curBtn:getContentSize().height / 2
			local sz = self.ScrollViewGame:getInnerContainerSize()
			local percent = math.ceil((sz.height - curY) / sz.height * 100)
			self.ScrollViewGame:scrollToPercentVertical(percent,0.05,false)
		end
	end
end

-- 注册全局事件
function clsGameK3View:InitGlbEvents()
	g_EventMgr:AddListener(self, "APP_ENTER_FOREGROUND", function(thisObj)
		if utils.IsValidCCObject(self) then 
			proto.req_bet_game_state({gid=self.gameArg.gid}) 
			proto.req_bet_open_result({gid=self.gameArg.gid}) 
		end
	end)
	g_EventMgr:AddListener(self, "NET_STATE_CHANGE", function(thisObj)
		if PlatformHelper.isNetworkConnected() then
			proto.req_bet_game_state({gid=self.gameArg.gid}) 
			proto.req_bet_open_result({gid=self.gameArg.gid})
			if ClsGameMgr.GetInstance():GetWanfaData(self.gameArg.gid) then
				print("从缓存读取玩法")
				self:on_req_goucai_game_wanfa_list({data=ClsGameMgr.GetInstance():GetWanfaData(self.gameArg.gid)}, { gid=self.gameArg.gid })
			else
				proto.req_goucai_game_wanfa_list({ gid=self.gameArg.gid }, { gid=self.gameArg.gid })
			end
			proto.req_bet_open_result({gid=self.gameArg.gid})
		end
	end)
	g_EventMgr:AddListener(self, "fail_req_bet_game_state", function(this, recvdata, tArgs) 
		if tArgs and gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) and not self:HasTimer("tmstate") then 
			if not PlatformHelper.isNetworkConnected() then return end
			self:CreateAbsTimerDelay("tmstate", 1, function() proto.req_bet_game_state({gid=self.gameArg.gid}) end)
		end
	end)
	g_EventMgr:AddListener(self, "error_req_bet_game_state", function(this, recvdata, tArgs) 
		if tArgs and gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) and not self:HasTimer("tmstate") then 
			if not PlatformHelper.isNetworkConnected() then return end
			self:CreateAbsTimerDelay("tmstate", 1, function() proto.req_bet_game_state({gid=self.gameArg.gid}) end)
			if not self:HasTimer("tmerroropenrlt") then
				self:CreateAbsTimerDelay("tmerroropenrlt", 2, function() proto.req_bet_open_result({gid=self.gameArg.gid}) end)
			end
		end
	end)
	g_EventMgr:AddListener(self, "fail_req_goucai_game_wanfa_list", function(this, recvdata, tArgs) 
		if tArgs and gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) and not self:HasTimer("tmwanfa") then 
			if not PlatformHelper.isNetworkConnected() then return end
			self:CreateAbsTimerDelay("tmwanfa", 1, function() proto.req_goucai_game_wanfa_list({gid=self.gameArg.gid}, {gid=self.gameArg.gid}) end)
		end
	end)
	g_EventMgr:AddListener(self, "error_req_goucai_game_wanfa_list", function(this, recvdata, tArgs) 
		if tArgs and gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) and not self:HasTimer("tmwanfa") then 
			if not PlatformHelper.isNetworkConnected() then return end
			self:CreateAbsTimerDelay("tmwanfa", 1, function() proto.req_goucai_game_wanfa_list({gid=self.gameArg.gid}, {gid=self.gameArg.gid}) end)
		end
	end)
	g_EventMgr:AddListener(self, "fail_req_goucai_game_qiuhao_peilv_list", function(this, recvdata, tArgs) 
		if tArgs and self._selectedWanFa and gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) and not self:HasTimer("tmpeilv") then 
			if not PlatformHelper.isNetworkConnected() then return end
			self:CreateAbsTimerDelay("tmpeilv", 1, function() proto.req_goucai_game_qiuhao_peilv_list({ gid=self.gameArg.gid }, { gid=self.gameArg.gid, tid=tonumber(self._selectedWanFa.id) }) end)
		end
	end)
	g_EventMgr:AddListener(self, "error_req_goucai_game_qiuhao_peilv_list", function(this, recvdata, tArgs) 
		if tArgs and self._selectedWanFa and gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) and not self:HasTimer("tmpeilv") then 
			if not PlatformHelper.isNetworkConnected() then return end
			self:CreateAbsTimerDelay("tmpeilv", 1, function() proto.req_goucai_game_qiuhao_peilv_list({ gid=self.gameArg.gid }, { gid=self.gameArg.gid, tid=tonumber(self._selectedWanFa.id) }) end)
		end
	end)
	g_EventMgr:AddListener(self, "on_req_bet_game_state", self.on_req_bet_game_state, self)
	g_EventMgr:AddListener(self, "on_req_goucai_game_wanfa_list", self.on_req_goucai_game_wanfa_list, self)
	g_EventMgr:AddListener(self, "GAME_CUR_WANFA", self.OnCurWanFa, self)
	g_EventMgr:AddListener(self, "on_req_goucai_game_qiuhao_peilv_list", self.on_req_goucai_game_qiuhao_peilv_list, self)
	g_EventMgr:AddListener(self, "GAME_BILL_SUCC", function(thisObj, billId, oneBill, billPaper, gameObj)
		--询问是否清除旧的选中
		for _, BtnFeature in pairs(self._btnFeatureList) do
			if oneBill:GetBallIdx(BtnFeature._info.id) then
				self._billPaper:DelBall(BtnFeature._info.id)
				BtnFeature:SetSelectedQuiet(false)
			end
		end
		self:OnSelectBallChanged()
	end)
	g_EventMgr:AddListener(self, "GAME_ADD_BILLPAPER", function(thisObj, billPaper, gameObj)
		local betCount, totalCost = billPaper:GetTotalInfo(gameObj)
		if self.lblBetCount then self.lblBetCount:setString(betCount) end
	end)
	g_EventMgr:AddListener(self, "GAME_DEL_BILLPAPER", function(thisObj, gameObj)
		if self.lblBetCount then self.lblBetCount:setString(0) end
		self:ClearSelectedBalls()
		self.EditMoney:setString("")
	end)
	g_EventMgr:AddListener(self, "on_req_user_set_favorite", self.RefleshCollectBtn, self)
	g_EventMgr:AddListener(self, "on_req_user_get_favorite", self.RefleshCollectBtn, self)
	g_EventMgr:AddListener(self, "on_req_bet_open_result", self.on_req_bet_open_result, self)
end

function clsGameK3View:CreateTouziAni()
	local spr = utils.CreateSprite("uistu/games/touzi1.png")
	if spr then
		spr._idxAni = 1
		spr:runAction(cc.RepeatForever:create(
			cc.Sequence:create(
				cc.DelayTime:create(0.1),
				cc.CallFunc:create(function()
					spr._idxAni = spr._idxAni + 1
					if spr._idxAni > 6 then spr._idxAni = 1 end
					spr:setTexture("uistu/games/touzi"..spr._idxAni..".png")
				end)
			)
		))
	end
	return spr
end

function clsGameK3View:RefleshWangqi()
	if not self._kithe or not self._preIssueData then return end
	local preKithe = tonumber(self._preIssueData.kj_issue)
	local curKithe = tonumber(self._kithe)
	local info = self._preIssueData
	local numtbl = string.split(info.number, ",") or {}
	
	local bWait = false
	if preKithe and curKithe and preKithe+2 == curKithe then
		bWait = true
	end
	
	if bWait then
		local waitKithe = curKithe - 1
		self.lblWangQi:setString(string.sub(waitKithe, -7,-1).."期开奖号码")
		
		self.NodeLottery:removeAllChildren()
		self._diceList = nil
		
		if not self._effSaizi then
			self._effSaizi = {}
			local cnt = 3
			for idx=1, cnt do
				self._effSaizi[idx] = self:CreateTouziAni()   --clsEffectSeq.new(-1, "seqani/saizi.plist", self.NodeWait, -1)
				self.NodeWait:addChild(self._effSaizi[idx])
				if self._effSaizi[idx] then
					self._effSaizi[idx]:setScale(0.5)
					self._effSaizi[idx]:setPositionX(50*(idx-(cnt+1)/2))
				end
			end
		end
		
		if not self:HasTimer("ask_kaijiang") then
			self:CreateAbsTimerDelay("ask_kaijiang", gameutil.GetOpenResultInterval(self._remain_sec), function()
				proto.req_bet_open_result({gid=self.gameArg.gid})
			end)
		end
	else
		self.lblWangQi:setString(string.sub(info.kj_issue, -7,-1).."期开奖号码")
		
		self.NodeWait:removeAllChildren()
		self._effSaizi = nil
		
		if not self._diceList then
			self._diceList = {}
			local cnt = #numtbl
			for idx, nStr in ipairs(numtbl) do
				local sprDice = utils.CreateSprite(DICE_RES[nStr], self.NodeLottery)
				sprDice:setScale(0.4)
				sprDice:setPositionX(50*(idx-(cnt+1)/2))
				self._diceList[idx] = sprDice
			end
		else
			for idx, nStr in ipairs(numtbl) do
				self._diceList[idx]:setTexture(DICE_RES[nStr])
			end
		end
	end
end

function clsGameK3View:on_req_bet_open_result(recvdata, tArgs)
	local rows = recvdata and recvdata.data and recvdata.data.rows
	if not rows then return end
	if not gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) then return end
	local info = rows[1]
	self._preIssueData = info
	self:RefleshWangqi()
end

function clsGameK3View:RefleshCollectBtn(recvdata, tArgs)
	self.CheckBoxCollect:setSelected(ClsCollectMgr.GetInstance():HasCollect(self.gameArg.gid))
end

function clsGameK3View:OnRemainSec(remainSec)
	if remainSec < 0 then remainSec = 0 end
	self._remain_sec = remainSec
	self.lblCountDown:setString( libtime.ChangeSToH(remainSec) )
end

function clsGameK3View:StartCD(remainSec, gid)
	self:DestroyTimer("tmr_cd")
	self:DestroyTimer("tm_delay_state")
	self:OnRemainSec(remainSec)
	if remainSec > 0 then
		self:CreateAbsTimerLoop("tmr_cd", 1, function()
			remainSec = remainSec - 1
			if remainSec < 0 then remainSec = 0 end
			self:OnRemainSec(remainSec)
			if remainSec <= 0 then 
				proto.req_bet_game_state({gid=gid})
				proto.req_bet_open_result({gid=gid})
				return true 
			end
		end)
	else
		self:CreateAbsTimerDelay("tm_delay_state", 2, function()
			proto.req_bet_game_state({gid=gid})
			proto.req_bet_open_result({gid=gid})
		end)
	end
end

function clsGameK3View:on_req_bet_game_state(recvdata, tArgs, bFromCache)
	local data = recvdata and recvdata.data and recvdata.data[1]
	if not data then return end
	if not gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) then return end
	self:DestroyTimer("tmstate")
	self._gameObj:SetGameStateInfo(data)
	
	if self._kithe and self._kithe ~= data.kithe and not bFromCache then
		local function callback(mnuId)
			if mnuId == 1 then
			--	self:ClearSelectedBalls()
			end
		end
		local tipStr = string.format( "%s期已截止#r当前期号#R%s#n#r投注时请注意期号", string.sub(self._kithe, -7,-1), string.sub(data.kithe, -7,-1) )
		ClsUIManager.GetInstance():PopConfirmDlg2("CFM_CLEAR_SELECT", "温馨提示", tipStr, callback)
        g_EventMgr:FireEvent("OVERTIPS")
        PlatformHelper.closeSystemKeyboard(self.EditMoney)
	end
	self._kithe = data.kithe
	
	self.lblCurrent:setString(string.sub(data.kithe,-7,-1).."期投注截止")
	
	local remainSec = data.kithe_time_stamp - data.current_time_stamp

	self:StartCD(remainSec, data.gid)
	
	self:RefleshWangqi()
	
	local wnd = ClsUIManager.GetInstance():GetWindow("clsBetBasketK")
	if wnd then
		wnd:SetKithe(self._kithe)
	end
end

function clsGameK3View:on_req_goucai_game_wanfa_list(recvdata, tArgs)
	local data = recvdata and recvdata.data 
	if not data then return end
	if not gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) then return end
	self:DestroyTimer("tmwanfa")
	self._wanfaList = data
	self._gameObj:SetWanFaList(data)
	self._gameObj:SetCurWanFa(self._wanfaList.play[1].play[1])
end

function clsGameK3View:OnCurWanFa(info)
	print("选择游戏玩法")
	logger.dump(info)
	self._selectedWanFa = info
	self:RefleshBallsArea(nil)
	
	self.lblPlayType:setString(info.name or "")
	local sz = self.lblPlayType:getContentSize()
	local sz2 = self.BtnPlayType:getContentSize()
	self.BtnPlayType:setContentSize(sz.width+60, sz2.height)
	self.lblPlayType:setPositionX(10)
	self.sprPlayType:setPositionX(sz.width+60-10)
	
	self.lblGameTip:setString(setting.T_k3_wanfa_tip[info.name] or "")
	
	local cached_peilv = ClsGameMgr.GetInstance():GetPeiLvData(self.gameArg.gid, tonumber(info.id))
	if cached_peilv then
		print("读取缓存中的赔率")
		local tArgs = { gid=self.gameArg.gid, _tUrlParams = { gid=self.gameArg.gid, tid=tonumber(info.id) } }
		self:on_req_goucai_game_qiuhao_peilv_list({data=cached_peilv}, tArgs)
	else
		proto.req_goucai_game_qiuhao_peilv_list({ gid=self.gameArg.gid }, { gid=self.gameArg.gid, tid=tonumber(info.id) })
	end
end


function clsGameK3View:on_req_goucai_game_qiuhao_peilv_list(recvdata, tArgs)
	local data = recvdata and recvdata.data
	if not data then return end
	if not gameutil.IsSameGid(tArgs.gid, self.gameArg.gid) then return end
	self:DestroyTimer("tmpeilv")
	self._gameObj:SetCurPeiLvList(data, tArgs.gid, tArgs.tid)
	self:RefleshBallsArea(data)
end

function clsGameK3View:RefleshBallsArea(data)
	self.ScrollViewGame:removeAllChildren()
	self._btnFeatureList = {}
	self._billPaper:Clear()
	if not data then
		self:OnSelectBallChanged()
		return
	end
	
	local tid = tostring( self._selectedWanFa.id )
	local infolist = data.balls_rate[tid].balls 
	
	--
	local cnt = #infolist
	local autoGrid = clsAutoGrid.new(720, self.ScrollViewGame:getContentSize().height, 20, 20)
	autoGrid:Begin()
	autoGrid:AddSpace(5)
	local objList = {}
	local btnWid, btnHei = 155, 150
	for idx=1, cnt do 
		local ball = infolist[idx]
		local BtnFeature = self:CreateFeatureBtn(btnWid, btnHei, ball.name, self._gameObj:CalculatePeiLv(ball))
		table.insert(objList, BtnFeature)
		KE_SetParent(BtnFeature, self.ScrollViewGame)
		self._btnFeatureList[idx] = BtnFeature
		BtnFeature._info = ball
		
		BtnFeature:SetSelectCallback(function(sender, bSelected)
			if bSelected then
				if self._billPaper:AddBall(self:GetCost(), ball, self._gameObj, true) then
					self:OnSelectBallChanged()
				else
					BtnFeature:SetSelectedQuiet(false)
				end
			else 
				self._billPaper:DelBall(ball.id)
				self:OnSelectBallChanged()
			end
		end)
	end
	autoGrid:AddRow(objList, 4, btnWid,btnHei, "left", 10)
	autoGrid:AddSpace(5)
	local totalHei = autoGrid:End()
	self.ScrollViewGame:setInnerContainerSize(cc.size(720,totalHei))
	
	self:OnSelectBallChanged()
end

function clsGameK3View:CreateFeatureBtn(wid,hei,name,rate)
	return UIFactory.CreateRectButton(parent, wid, hei, name, rate)
end

function clsGameK3View:OnSelectBallChanged()
	local strBalls = ""
	for _, BtnFeature in pairs(self._btnFeatureList) do
		if BtnFeature:IsSelected() then
			strBalls = strBalls .. BtnFeature._info.name .. " "
		else
			if self._preSelect == BtnFeature then self._preSelect = nil end
		end
	end
	self.lblSelectedBalls:setString(strBalls)
	
	self._billPaper:SetCost(self:GetCost())
	local betCount, totalCost = self._billPaper:GetTotalInfo(self._gameObj)
	self.lblBetInfo:setString( "共"..betCount.."注"..totalCost.."元" )
	
	--
	if not self._btnFeatureList then return end
	local preY = self.ScrollViewGame:getInnerContainerPosition().y
	local preSize = self.ScrollViewGame:getInnerContainerSize()
	if betCount > 0 then
		self.WndSelectInfo:setVisible(true)
		self.ScrollViewGame:setContentSize(cc.size(preSize.width,self:GetAdaptInfo().hAuto+20))
        self.BtnBet:setColor(cc.c3b(255,255,255))
        self.BtnBet:setTouchEnabled(true)
	else
		self.WndSelectInfo:setVisible(false)
		self.ScrollViewGame:setContentSize(cc.size(preSize.width,self:GetAdaptInfo().hAuto+self.WndSelectInfo:getContentSize().height))
        self.BtnBet:setColor(cc.c3b(77,77,77))
        self.BtnBet:setTouchEnabled(false)
	end
	local cnt = #self._btnFeatureList
	local autoGrid = clsAutoGrid.new(720, self.ScrollViewGame:getContentSize().height, 20, 20)
	autoGrid:Begin()
	autoGrid:AddSpace(5)
	local objList = {}
	local btnWid, btnHei = 155, 150
	for idx=1, cnt do 
		table.insert(objList, self._btnFeatureList[idx])
	end
	autoGrid:AddRow(objList, 4, btnWid,btnHei, "left", 10)
	autoGrid:AddSpace(5)
	local totalHei = autoGrid:End()
	self.ScrollViewGame:setInnerContainerSize(cc.size(720,totalHei))
	local curY = self.ScrollViewGame:getInnerContainerPosition().y
	local diff = curY - preY
	local minY = self.ScrollViewGame:getContentSize().height-self.ScrollViewGame:getInnerContainerSize().height
	local maxY = 0
	local innerY = math.Limit(curY-diff, minY, maxY)
	self.ScrollViewGame:setInnerContainerPosition(cc.p(self.ScrollViewGame:getInnerContainerPosition().x, innerY))
end

function clsGameK3View:ClearSelectedBalls()
	for _, BtnFeature in pairs(self._btnFeatureList) do
		BtnFeature:SetSelectedQuiet(false)
	end
	self._billPaper:Clear()
	self:OnSelectBallChanged()
end

function clsGameK3View:GetCost()
	local cost = self.EditMoney:getString() or ""
	cost = tonumber(cost) or 0
	return cost
end