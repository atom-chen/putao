-------------------------
-- 充值
-------------------------
module("ui", package.seeall)

clsRecharge22View = class("clsRecharge22View", clsBaseUI)

function clsRecharge22View:ctor(parent)
	clsBaseUI.ctor(self, parent, "uistu/Recharge22View.csb")
	
	self.EditorMoney = utils.ReplaceTextField(self.EditorMoney)
	self.EditorMoney:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	
	self.ListView2:setItemModel(self.ListItem2)
	KE_SafeDelete(self.ListItem2)
	self.ListItem2 = nil
    
	self.ListView3:setItemModel(self.ListItem3)
	KE_SafeDelete(self.ListItem3)
	self.ListItem3 = nil
	
	self.ListView1:setScrollBarEnabled(false)
	self.ListView2:setScrollBarEnabled(false)
	self.ListView3:setScrollBarEnabled(false)
	
	self:InitUiEvents()
	self:InitGlbEvents()
	self:RefleshUI()
	
	proto.req_pay_get_pay_channel_info()
end

function clsRecharge22View:dtor()
	
end

function clsRecharge22View:ForceAdapt()
	clsBaseUI.ForceAdapt(self)
	local w = self.ListView3:getContentSize().width
	local h = self:GetAdaptInfo().hAuto - 420
	self.ListView2:setContentSize(w, h)
	self.ListView3:setContentSize(w, h)
end

--注册控件事件
function clsRecharge22View:InitUiEvents()
	utils.RegClickEvent(self.BtnClose, function() self:removeSelf() end)
	
	local money_list = { 50, 100, 300, 500, 800, 1000, 2000, 3000 }
	local tabGroup = clsCompTabGroup.new("button")
	for i, money in ipairs(money_list) do
		tabGroup:AddTabButton(money, self["Btn"..i])
		self["lblYuan"..i]:setString(money.."元")
	end
	tabGroup:AddListener(self, "ec_select_changed", function(thisObj, id, old_selected_id)
		self.EditorMoney:setString(id)
	end)
	
	utils.RegClickEvent(self.BtnRechargeRecord, function()
		ClsUIManager.GetInstance():ShowPanel("clsRechargeRecord")
	end)
end

-- 注册全局事件
function clsRecharge22View:InitGlbEvents()
	g_EventMgr:AddListener(self, "on_req_user_info", self.RefleshUI, self)
	g_EventMgr:AddListener(self, "on_req_user_balance", self.RefleshUI, self)
	g_EventMgr:AddListener(self, "on_req_pay_get_pay_channel_info", self.on_req_pay_get_pay_channel_info, self)
	g_EventMgr:AddListener(self,"RechargeOver",function()
        self:removeSelf()
    end,self)
end

function clsRecharge22View:RefleshUI(recvdata)
	local userObj = UserEntity.GetInstance()
	self.lblAccount:setString(userObj:Get_username() or "")
	self.lblBalance:setString(string.format("%.3f元", userObj:Get_balance() or 0))
end

function clsRecharge22View:on_req_pay_get_pay_channel_info(recvdata)
	local data = recvdata and recvdata.data
	if not data then return end
	
	ClsUIManager.GetInstance():ShowPopWnd("clsAnounceWnd"):RefleshUI(data.is_bomb_box.bomb_box)
	
	self.ListView1:removeAllItems()
	
	for idx, info1 in ipairs(data.zhifu) do
		local btnTab = utils.CreateButton()
		btnTab:setScale9Enabled(true)
		btnTab._info1 = info1
		
		local spr9 = utils.CreateScale9Sprite("uistu/common/pnl_tag_btn.png")
		spr9:setScale9Enabled(true)
		btnTab:addChild(spr9)
		btnTab.spr9 = spr9
		
		local lblName = utils.CreateLabel(info1.name, 24)
		btnTab:addChild(lblName)
		lblName:setColor(cc.c3b(255,255,255))
		btnTab.lblName = lblName
		
		btnTab:setContentSize(lblName:getContentSize().width+22, 60)
		local sz = btnTab:getContentSize()
		lblName:setPosition(sz.width/2, 30)
		spr9:setPosition(sz.width/2,sz.height/2)
		spr9:setContentSize(sz)
		
		self.ListView1:pushBackCustomItem(btnTab)
	end
	
	self.ListView1:addEventListener(function(sender, eventType)
        if ccui.ListViewEventType.ONSELECTEDITEM_END == eventType then
			local curIndex = self.ListView1:getCurSelectedIndex()
			local selectedItem = curIndex and self.ListView1:getItem(curIndex)
			
			local allitems = self.ListView1:getChildren()
			for i, wnd in ipairs(allitems or {}) do
				wnd.spr9:setVisible(i-1==curIndex)
				wnd.lblName:setColor(i-1==curIndex and cc.c3b(255,0,0) or cc.c3b(255,255,255))
			end
			
			if data.zhifu[curIndex+1].type == "bank" then
				self.ListView2:setVisible(false)
				self.ListView3:setVisible(true)
				self.ListView3:removeAllItems()
				for i, info2 in ipairs(data.zhifu[curIndex+1].list) do
					self.ListView3:pushBackDefaultItem()
					local item = self.ListView3:getItem(i-1)
					
					item:getChildByName("lblBankName"):setString(info2.bank_name)
					item:getChildByName("lblBindName"):setString(info2.name)
					item:getChildByName("lblKaihuHang"):setString(info2.card_address)
					item:getChildByName("lblCardNum"):setString(info2.num)
					
					utils.RegClickEvent(item, function()
						self:AskPay(selectedItem._info1, info2)
					end)
				end
			elseif data.zhifu[curIndex+1].type == "wy" then
				self.ListView2:setVisible(true)
				self.ListView3:setVisible(false)
				self.ListView2:removeAllItems()
				for i, info2 in ipairs(data.zhifu[curIndex+1].list) do
					self.ListView2:pushBackDefaultItem()
					local item = self.ListView2:getItem(i-1)
					
					local imgGameIcon = item:getChildByName("ImgBankLogo")
					imgGameIcon:setScale9Enabled(false)
					imgGameIcon:setContentSize(80,80)
					imgGameIcon:ignoreContentAdaptWithSize(false)
					imgGameIcon:LoadTextureSync(info2.img)
					
					item:getChildByName("lblBank1"):setString(info2.name)
					item:getChildByName("lblBank2"):setString("")
					item:getChildByName("lblBank1"):setPositionY(item:getContentSize().height/2)
					
					utils.RegClickEvent(item, function()
						self:AskPay(selectedItem._info1, info2)
					end)
				end
			else
				self.ListView2:setVisible(true)
				self.ListView3:setVisible(false)
				self.ListView2:removeAllItems()
				for i, info2 in ipairs(data.zhifu[curIndex+1].list) do
					self.ListView2:pushBackDefaultItem()
					local item = self.ListView2:getItem(i-1)
					
					local imgGameIcon = item:getChildByName("ImgBankLogo")
					imgGameIcon:setScale9Enabled(false)
					imgGameIcon:setContentSize(80,80)
					imgGameIcon:ignoreContentAdaptWithSize(false)
					imgGameIcon:LoadTextureSync(info2.img)
					
					item:getChildByName("lblBank1"):setString(info2.title)
					item:getChildByName("lblBank2"):setString(info2.Prompt)
					
					utils.RegClickEvent(item, function()
						self:AskPay(selectedItem._info1, info2)
					end)
				end
			end
		end 
    end)
    
    self.ListView1:setCurSelectedIndex(0)
end

function clsRecharge22View:AskPay(info1, info2)
	local money = self.EditorMoney:getString()
	money = tonumber(money)
	if not money or money < 0 then
		utils.TellMe("请输入有效的充值额度")
		return
	end
	
	local param = {}
	param.id = info2.id
	param.code = info2.code
	param.money = money
	param.from_way = const.FROMWAY
--	param.name = self.editBindName:getString()
	
	if info2.jump_mode == 2 or info2.jump_mode == "2" then
		ClsUIManager.GetInstance():ShowPanel("clsRecharge22Commit"):SetParams(tostring(money), info1, info2)
	elseif info2.jump_mode == 4 or info2.jump_mode == "4" then
		proto.req_get_game_article_content({id="13", param=param})
		ClsUIManager.GetInstance():ShowPanel("clsRechargeScan", {
			info1 = info1,
			info2 = info2,
			name = info2.name,
			money = money,
		})
	elseif info2.jump_mode == 3 or info2.jump_mode == "3" then
		proto.req_get_game_article_content({id="13", param=param})
		ClsUIManager.GetInstance():ShowPanel("clsRechargeScan", {
			info1 = info1,
			info2 = info2,
			name = info2.name,
			money = money,
		})
	else
		proto.req_pay_commit(param)
	end
end

function clsRecharge22View:AskQuickPay(info1, info2)
	local money = self.EditorMoney:getString()
	money = tonumber(money)
	if not money or money < 0 then
		utils.TellMe("请输入有效的充值额度")
		return
	end
	
	local param = {}
	param.id = info2.id
	param.code = info2.code
	param.bank_type = info2.bank_type
	param.money = money
	--
	param.cardNo = ""
	param.cardType = 1
	param.cardName = UserEntity.GetInstance():Get_bank_name() or ""
	param.idCardNo = ""
--	param.cnv2 = ""
--	param.validData = ""
	param.step = 1
	proto.req_pay_quick_pay_step1(param)
end
