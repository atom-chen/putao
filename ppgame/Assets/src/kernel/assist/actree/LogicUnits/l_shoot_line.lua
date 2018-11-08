-------------------------
-- 给角色添加BUFF
-------------------------
module("smartor",package.seeall)

local default_args = {
	["respath"] = "res/effects/effect_img/huoqiu.png",
	["fromX"] = 0,
	["fromY"] = 0,
	["toX"] = 100,
	["toY"] = 100,
	["speed"] = 2000,
}

local l_shoot_line = class("l_shoot_line", clsPromise)

l_shoot_line._default_args = default_args

function l_shoot_line:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "l_shoot_line"
end

function l_shoot_line:OnStop()
    KE_SafeDelete(self.sprBullet)
end

function l_shoot_line:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	
	local info = {
		sResType = args.sResType,
		sResPath = args.sResPath,
		iPositionType = args.iPositionType,
		iLoopTimes = args.iLoopTimes,
	}
	self.sprBullet = utils.CreateObject(nil, info)
	local sprBullet = self.sprBullet
	sprBullet:setScale(0.6)
	gameutil.AddObj2Map(sprBullet)
	
	sprBullet:setPosition(args.fromX, args.fromY)
	local useTime = math.Distance(args.fromX,args.fromY, args.toX,args.toY)/args.speed 
	sprBullet:runAction(cc.Sequence:create(
		cc.MoveTo:create(useTime,cc.p(args.toX,args.toY)),
		cc.CallFunc:create(function()
			self:Done()
		end),
		cc.RemoveSelf:create()
	))
end

return l_shoot_line
