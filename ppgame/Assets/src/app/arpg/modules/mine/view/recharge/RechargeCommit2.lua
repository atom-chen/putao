-------------------------
-- 充值
-------------------------
module("ui", package.seeall)

clsRechargeCommit2 = class("clsRechargeCommit2", clsBaseUI)
local _nList = 0 --用来计算Listview是否可见
function clsRechargeCommit2:ctor(parent)
	clsBaseUI.ctor(self, parent, "uistu/RechargeCommit2.csb")
	
	--self.editBindName = utils.ReplaceTextField(self.editBindName, "", "FFFF0000")
	
--	self:BindTypeBtn(self.Btn1, "网银转账", 1, "wy", 1)
--	self:BindTypeBtn(self.Btn2, "ATM现金入款", 2, "", 3)
--	self:BindTypeBtn(self.Btn3, "银行柜台", 3, "", 4)
--	self:BindTypeBtn(self.Btn4, "手机转账", 4, "", 5)
--	self:BindTypeBtn(self.Btn5, "支付宝转账", 5, "zfb", 6)
--	self:BindTypeBtn(self.Btn6, "微信支付", 6, "wx", 7)
	
--	self._bandStyleBtns = {}
--	for i=1, 6 do 
--		self._bandStyleBtns[i] = self["Btn"..i]
--		utils.RegClickEvent(self._bandStyleBtns[i], function()
--			self:CheckBankStyle(self._bandStyleBtns[i])
--            self.Text_26:setString(self._bandStyleBtns[i].name)
--            _nList = _nList + 1
--            self.ListView_1:setVisible(false)
--		end)
--	end
	--self:CheckBankStyle(self._bandStyleBtns[1])
	
	self:InitUiEvents()
	self:InitGlbEvents()
end

function clsRechargeCommit2:dtor()
	
end

function clsRechargeCommit2:ForceAdapt()
    clsBaseUI.ForceAdapt(self)
    self.AreaAuto:setInnerContainerSize(cc.size(720,1190))
    self.ddddd:setPositionY(self.AreaAuto:getInnerContainerSize().height)
end

function clsRechargeCommit2:BindTypeBtn(btn, name, bank_style, Type, id)
	btn.bank_style = bank_style
	btn.type = Type 
	btn.id = id
    btn.name = name
	btn:getChildByName("lblCommitName"):setString(name)
end

function clsRechargeCommit2:CheckBankStyle(btn)
	self._selectedBtn = btn
	for i=1, 6 do 
		local bSelect = btn == self._bandStyleBtns[i]
		self._bandStyleBtns[i]:getChildByName("Image_1"):setVisible(bSelect)
		self._bandStyleBtns[i]:getChildByName("Image_2"):setVisible(not bSelect)
	end
end

--注册控件事件
function clsRechargeCommit2:InitUiEvents()
	utils.RegClickEvent(self.BtnClose, function() self:removeSelf() end)
	
	utils.RegClickEvent(self.BtnCpy1, function() SalmonUtils:copy(self.lblBankName:getString()) end)
	utils.RegClickEvent(self.BtnCpy2, function() SalmonUtils:copy(self.lblShouKuanRen:getString()) end)
	utils.RegClickEvent(self.BtnCpy3, function() SalmonUtils:copy(self.lblBankCard:getString()) end)
	utils.RegClickEvent(self.BtnCpy4, function() SalmonUtils:copy(self.lblKaiHuDian:getString()) end)
	
	utils.RegClickEvent(self.BtnCommit, function()
--		if not self._selectedBtn then
--			utils.TellMe("请选择转账方式")
--			return 
--		end
		self:AskPay(self.info3, self.money, self.info1, self.info2)
	end)
    utils.RegClickEvent(self.Button_Service,function()
		PlatformHelper.openURL(ClsHomeMgr.GetInstance():GetHomeConfigData().online_service)
	end)
    utils.RegClickEvent(self.ways,function()
        _nList = _nList + 1
        if _nList%2 == 0 then
            self.ListView_1:setVisible(false)
        else
            self.ListView_1:setVisible(true)
            print(_nList)
        end
    end)
end

function clsRechargeCommit2:AskPay(bank_style, money, info1, info2)
	bank_style = tostring(bank_style)
--	local money = self.money
--	if not money or money < 0 then
--		utils.TellMe("请输入有效的充值额度")
--		return
--	end
--	local bindName = self.editBindName:getString()
--	if not bindName or bindName == "" then
--		utils.TellMe("请输入存款人姓名")
--		return
--	end
--	if not bank_style then
--		utils.TellMe("请选择转账方式")
--		return
--	end

	local param = {}
	param.bank_style = bank_style
	param.code = info2.code
	param.money = money
--	param.data = ""
	param.name = self.info4
	param.id = info2.id
	param.from_way = const.FROMWAY
	if self.info3 == 6 and self.TextField_1:getString() == "" and param.name == nil then
        utils.TellMe("请输入姓名")
        return
    end
    if self.info3 == 6 and param.name == nil then
        param.name = self.TextField_1:getString()
    end
	param._client_jump = false
    if info2.jump_mode == 1 or info2.jump_mode == "1" then
		proto.req_get_game_article_content({id="13", param=param})
		ClsUIManager.GetInstance():ShowPanel("clsRechargeScan", {
			info1 = info1,
			info2 = info2,
			name = info2.name,
            --name = self.editBindName:getString(),
			money = money,
		})
	else
		proto.req_pay_commit(param)
	end
end

-- 注册全局事件
function clsRechargeCommit2:InitGlbEvents()
	g_EventMgr:AddListener(self,"RechargeOver",function()
        self:removeSelf()
    end,self)
end

function clsRechargeCommit2:SetParams(money, info1, info2, info3, info4)
	self.info1 = info1
	self.info2 = info2
    self.info3 = info3
    self.info4 = info4
    if info4 == nil then
        self.TextField_1:setVisible(true)
        self.TextField_1 = utils.ReplaceTextField(self.TextField_1, "", "ff000000")
        self.editBindName:setVisible(false)
    else
        self.TextField_1:setVisible(false)
    end
	self.money = tonumber(money)
	dump(info1)
	dump(info2)
    if info3 == 1 then
        self.Text_63:setString("网银转账")
    elseif info3 == 3 then
        self.Text_63:setString("ATM现金入款")
    elseif info3 == 4 then
        self.Text_63:setString("银行柜台")
    elseif info3 == 5 then
        self.Text_63:setString("手机转账")
    elseif info3 == 6 then
        self.Text_63:setString("支付宝转账")
    elseif info3 == 7 then
        self.Text_63:setString("微信支付")
    end
    self.editBindName:setString(info4)
	self.lblBankName:setString(info2.bank_name)
	self.lblShouKuanRen:setString(info2.name)
	self.lblBankCard:setString(info2.num)
	self.lblKaiHuDian:setString(info2.card_address)
	self.lblMoney:setString(money)
end