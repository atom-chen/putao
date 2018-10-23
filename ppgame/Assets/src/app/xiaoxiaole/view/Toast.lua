--------------------------
-- 飘字提示
--------------------------

-- 显示通知消息
function Toast(Txt, DelayTime)
	if not Txt or utils.IsWhiteSpace(Txt) then return end
	local Parent = ClsLayerManager.GetInstance():GetLayer(const.LAYER_TOAST)
	if not Parent then return end
	
	Parent._all_tellme = Parent._all_tellme or {}
	local all_tellme = Parent._all_tellme
	
	for obj, _ in pairs(all_tellme) do
		if obj._tellStr == Txt then return end
	end
	
	-- 弹出位置
	local PosX, BeginY = GAME_CONFIG.DESIGN_W_2, GAME_CONFIG.DESIGN_H_2-42
	
	-- 创建控件
	local TellPanel = cc.Node:create()
	KE_SetParent(TellPanel, Parent)
	local BkgTell = utils.CreateScale9Sprite("xiaoxiaole/toast_bg.png")
	TellPanel:addChild(BkgTell)
	local LabelTell = utils.CreateLabel(Txt, 24)
	TellPanel:addChild(LabelTell)
	BkgTell:setPreferredSize(cc.size(LabelTell:getContentSize().width+30, 42))
	TellPanel:setPosition(PosX,BeginY)
	all_tellme[TellPanel] = true
	TellPanel._tellStr = Txt
	
	-- 调整位置
	for Pnl, _ in pairs(all_tellme) do
		Pnl:setPosition(PosX, Pnl:getPositionY()+42)
	end
	
	-- 定时销毁
	TellPanel:runAction(cc.Sequence:create(
		cc.DelayTime:create(DelayTime or 2),
		cc.CallFunc:create(function ()
			KE_SafeDelete(TellPanel)
			all_tellme[TellPanel] = nil
		end)
	))
end