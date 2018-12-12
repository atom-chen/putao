module("ui",package.seeall)

clsCountMessage = class("clsCountMessage",clsBaseUI)

function clsCountMessage:ctor(parent)
    clsBaseUI.ctor(self,parent,"uistu/CountMessage.csb")
    self.data = ClsAgentDataMgr.GetInstance():GetCode()
    self.url = ClsHomeMgr.GetInstance():GetShareUrl()
    self.Image_1:setVisible(false)
    self:InUiEvent()
    g_EventMgr:AddListener(self,"on_req_delete_invite_code",function()
        local types = tonumber(self.data.type)
        proto.req_agent_invite_code_list({type = types})
        self:removeSelf()
    end)
end

function clsCountMessage:InUiEvent()
    utils.RegClickEvent(self.Button_3,function()
        ClsUIManager.GetInstance():ShowPopWnd("clsRebatesMessage")
    end)
    utils.RegClickEvent(self.Button_2,function()
        self.Panel_1:setVisible(false)
        self.Image_1:setVisible(true)
    end)
    utils.RegClickEvent(self.Button_1,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_4,function()
        self:removeSelf()
    end)
    utils.RegClickEvent(self.Button_5,function()
        proto.req_delete_invite_code({invite_code = self.data.invite_code})
    end)
    gameutil.RegCopyEvent(self.CopyLabel, self.url..self.data.invite_code)
end