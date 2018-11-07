ClsRechargeRecoMgr = class("ClsRechargeRecoMgr",clsCoreObject)
ClsRechargeRecoMgr.__is_singleton = true

function ClsRechargeRecoMgr:ctor()
    clsCoreObject.ctor(self)
    self.RechargeRecord = {}
    self.RechargeDetail = {}
    self.RechargeDate = {}
    
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

------------------- ��ֵ���� -----------------------------------
--[[
  / �ڲ���ҳ */
  public static final int JUMP_MODE_WEB_INNER = 1;
  / ���п�ת�� */
  public static final int JUMP_MODE_BANK = 2;
  / ���ں�ɨ�� */
  public static final int JUMP_MODE_QRCODE_PUBLIC = 3;
  / ����ɨ�� */
  public static final int JUMP_MODE_QRCODE_PERSONAL = 4;
  /** �ⲿ��ҳ */
  public static final int JUMP_MODE_WEB_OUTER = 5;


1. type == bank ��ת���п�֧��
2. 4��2ֱ����ת��
3. �������� /pay/pay/pay_do ֧���ӿ���ȷ����ת��
]]
function ClsRechargeRecoMgr:SaveRechargeRecharge(data)
    self.RechargeRecharge = data
end

function ClsRechargeRecoMgr:GetRechargeRecharge()
    return self.RechargeRecharge
end