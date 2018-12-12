-------------------------
-- 射出子弹
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["owner_atom"] = 2,
	["tMagicInfo"] = {
		["sMissleType"] = "clsMissileLine",		--运动方式
		--资源路径
		["sResPath"] = "particles/SmallSun.plist",
		["sResType"] = "particle",
		["iPositionType"] = 0x2,
		--销毁策略
		["AfterCollid"] = 0,		--碰撞后表现。0：无   1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
		["iDelWithOwner"] = 0,		--随施法者消亡而消亡
		--运动轨迹（法术体的运动方式）
		["tTrackCfg"] = {
			["iMoveDir"] = 0,			--移动方向（角度）
			["iMoveSpeed"] = 8,			--移动速度
			["iMoveDis"] = 150,			--移动距离
		},
		--伤害帧
		["tHarmFrame"] = {
			[0] = {
				["iDamagePower"] = 1.50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcForce",
					["param"] = {
						["iSPframe"] = 30,
						["iCZspeed"] = 10,
					},
				},
			},
		},
	}
}

local v_add_missile = class("v_add_missile", clsPromise)

v_add_missile._default_args = default_args

function v_add_missile:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "v_add_missile"
end

function v_add_missile:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local owner_atom = args.owner_atom
	local tMagicInfo = args.tMagicInfo 
	
	local theOwner = xCtx:GetAtom(owner_atom)
	if not theOwner then
		logger.error("====ERROR: 不存在该角色", owner_atom, self._node_type)
		return self:Done()
	end
	
	local bullet = missile.ClsMissileMgr.GetInstance():CreateMissile(theOwner, tMagicInfo)
	bullet:Shoot()
	
	self:Done()
end

return v_add_missile
