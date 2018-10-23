ClsRechargeRecoMgr = class("ClsRechargeRecoMgr",clsCoreObject)

function ClsRechargeRecoMgr:ctor()
    clsCoreObject.ctor(self)
    self.RechargeRecord = {}
    self.RechargeDetail = {}
    self.RechargeDate = {}
    self.RechargeType = 0
    self.RechargeRecharge = {}
end

function ClsRechargeRecoMgr:SaveRechargeRecord(data)
    self.RechargeRecord = data
end

function ClsRechargeRecoMgr:GetRechargeRecord()
    return self.RechargeRecord
end

function ClsRechargeRecoMgr:SaveRechargeDetail(data)
    self.RechargeDetail = data
end

function ClsRechargeRecoMgr:GetRechargeDetail()
    return self.RechargeDetail
end

function ClsRechargeRecoMgr:SaveRechargeDate(data)
    self.RechargeDate = data
end

function ClsRechargeRecoMgr:GetRechargeDate()
    return self.RechargeDate
end

function ClsRechargeRecoMgr:SaveRechargeType(data)
    self.RechargeType = data
end

function ClsRechargeRecoMgr:GetRechargeType()
    return self.RechargeType
end

function ClsRechargeRecoMgr:SaveRechargeRecharge(data)
    self.RechargeRecharge = data
end

function ClsRechargeRecoMgr:GetRechargeRecharge()
    return self.RechargeRecharge
end