ClsWithdrawMgr = class("ClsWitehdrawMgr",clsCoreObject)

function ClsWithdrawMgr:ctor()
    clsCoreObject.ctor(self)
    self.WithdrawData = {}
end

function ClsWithdrawMgr:SaveWithdrawData(recvdata)
    self.WithdrawData = recvdata
end

function ClsWithdrawMgr:GetWithdrawData()
    return self.WithdrawData
end