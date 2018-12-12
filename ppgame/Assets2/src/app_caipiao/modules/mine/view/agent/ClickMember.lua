module("ui",package.seeall)

clsClickMember = class("clsClickMember",clsBaseUI)

function clsClickMember:ctor(parent)
    clsBaseUI.ctor(self,parent,"uistu/ClickMember.csb")
    self:InUiEvent()
    self:Refresh()
end

function clsClickMember:InUiEvent()
    utils.RegClickEvent(self.Button_3,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_1,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_4,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_7,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_11,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_8,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_2,function()
        ClsUIManager.GetInstance():ShowPopWnd("clsRebatesMessage")
    end)
    utils.RegClickEvent(self.Button_5,function()
        ClsUIManager.GetInstance():ShowPanel("clsAgentReport")
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_6,function()
        g_EventMgr:FireEvent("showpage")
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_10,function()
        ClsUIManager.GetInstance():ShowPopWnd("clsRebatesMessage")
    end)
    utils.RegClickEvent(self.Button_9,function()
        g_EventMgr:FireEvent("showmemberpage")
        self:removeSelf()
    end)
end

function clsClickMember:Refresh()
    local type = ClsAgentDataMgr.GetInstance():GetType()
    if type == 5 then
        self.Panel_2:setVisible(false)
        self.Panel_1:setVisible(true)
        self.Panel_3:setVisible(false)
        local data = ClsAgentDataMgr.GetInstance():GetMemberdata()
        self.Text_1:setString(data.username)
    elseif type == 2 then
        self.Panel_2:setVisible(true)
        self.Panel_1:setVisible(false)
        self.Panel_3:setVisible(false)
        self.Text_2:setString(ClsAgentDataMgr.GetInstance():GetReportid())
    elseif type == 6 then
        self.Panel_2:setVisible(false)
        self.Panel_1:setVisible(false)
        self.Panel_3:setVisible(true)
        local data = ClsAgentDataMgr.GetInstance():GetMemberdata()
        self.Text_3:setString(data.username)
    end
end