-------------------
-- 技能树
-------------------
module("skillfactory", package.seeall)

local KEYFRAME1 = 18
local KEYFRAME2 = 26
local RUSHSPEED = 3600
local ALL_GEN_FUNC = {}
local g_SingleEnemyLessHp = ai.clsTargetLogic.new(ai.FOR_BUDDY.ENEMY, ai.PRIORITY.LESS_HP, 1)
local g_AllEnemy = ai.clsTargetLogic.new(ai.FOR_BUDDY.ENEMY, ai.PRIORITY.NONE, -1)
local g_AllMySide = ai.clsTargetLogic.new(ai.FOR_BUDDY.SELF_TEAMMATE, ai.PRIORITY.NONE, -1)

-------------------------------------------------------------------------------
function GenSkill(SkillId, Attacker)
	return ALL_GEN_FUNC[SkillId](Attacker)
end 

local g_IdList = false
function RandomSkillId()
	if not g_IdList then
		g_IdList = {}
		for SkillId, _ in pairs(ALL_GEN_FUNC) do
			table.insert(g_IdList,SkillId)
		end
	end
	return g_IdList[math.random(1,#g_IdList)]
end

-------------------------------------------------------------------------------

local function GetMinMaxX(targets, xMid)
	if #targets <= 0 then return xMid, xMid end
	local maxX = targets[1]:GetPosX()
	local minX = targets[1]:GetPosX()
	for _, obj in ipairs(targets) do
		local xObj = obj:GetPosX()
		if xObj > maxX then maxX = xObj end
		if xObj < minX then minX = xObj end
	end
	return minX, maxX
end 

local function Probability(v)
	return math.random(1,100) <= v
end

-------------------------------------------------------------------------------
-- 近程1 远程2
-- 单攻1 群攻2
-------------------------------------------------------------------------------

-------------------------
-- 11XXX 近程1 单攻1
-------------------------
ALL_GEN_FUNC[11001] = function(Attacker)
	local instFight = fight.FightService.GetInstance()
	local xMid = instFight:GetXMid()
	local yMid = instFight:GetYMid()
	local DIS = instFight:GetDis()
	local SPACE = instFight:GetSpace()
	
	local targetLgc = g_SingleEnemyLessHp
	local targets = targetLgc:Search(Attacker,1)
	logger.fight(string.format("%d发起攻击：目标数量%d",Attacker:GetUid(),#targets))
	
	local xTree = smartor.clsSmartTree.new()
	local ctx = xTree:GetContext()
	local sklAni = smartor.NewUnit("x_root_node", nil, ctx)
	xTree:SetRoot(sklAni)
	
	if #targets <= 0 then return xTree end 
	
	local Victim = targets[1]
	
	local fromX, fromY = Attacker:getPosition()
	local toX, toY = Victim:getPosition()
	if fromX < xMid then toX = toX - 90 else toX = toX + 90 end 
	
	local rushTime = math.sqrt( (toX-fromX)*(toX-fromX) + (toY-fromY)*(toY-fromY) ) / RUSHSPEED
	
	local aniRushTo = smartor.NewUnit("x_move_to", {["atom_id"]="starman",["dx"]=toX,["dy"]=toY,["distance"]=10,["seconds"]=rushTime,}, ctx)
	sklAni:SetNext(aniRushTo)
	
	local aniAct = smartor.NewUnit("s_role_play_ani", {["atom_id"]="starman",["ani_name"]="skill_0_1",["loop_times"]=1}, ctx)
	sklAni:SetNext(aniAct)
	
	if Probability(15) then
		local buffAni = smartor.NewUnit("l_add_buff", {["Placer"]=Attacker, ["Victim"]=Victim, ["BuffType"]=1003}, ctx)
		aniAct:AddPart(KEYFRAME1,buffAni)
	end
	
	local hurtAni = smartor.NewUnit("l_hurt", {["Attacker"]=Attacker,["Victim"]=Victim,["iDamagePower"]=1}, ctx)	
	aniAct:AddPart(KEYFRAME1,hurtAni)
	
	local aniRushBack = smartor.NewUnit("x_move_to", {["atom_id"]="starman",["dx"]=fromX,["dy"]=fromY,["seconds"]=rushTime}, ctx)
	aniAct:SetNext(aniRushBack)
	
	return xTree
end

-------------------------
-- 11XXX 近程1 群攻2
-------------------------
ALL_GEN_FUNC[12001] = function(Attacker)
	local instFight = fight.FightService.GetInstance()
	local xMid = instFight:GetXMid()
	local yMid = instFight:GetYMid()
	local DIS = instFight:GetDis()
	local SPACE = instFight:GetSpace()

	local targetLgc = g_AllEnemy
	local targets = targetLgc:Search(Attacker,1)
	logger.fight(string.format("%d发起攻击：目标数量%d",Attacker:GetUid(),#targets))
	
	local xTree = smartor.clsSmartTree.new()
	local ctx = xTree:GetContext()
	local sklAni = smartor.NewUnit("x_root_node", nil, ctx)
	xTree:SetRoot(sklAni)
	
	if #targets <= 0 then return xTree end 
	
	local minX, maxX = GetMinMaxX(targets, xMid)
	local fromX, fromY = Attacker:getPosition()
	local toX, toY = Attacker:getPosition()
	if fromX < xMid then toX = minX-90 else toX = maxX+90 end
	
	local rushTime = math.sqrt( (toX-fromX)*(toX-fromX) + (toY-fromY)*(toY-fromY) ) / RUSHSPEED
	
	local aniRushTo = smartor.NewUnit("x_move_to", {["atom_id"]="starman",["dx"]=toX,["dy"]=toY,["distance"]=10,["seconds"]=rushTime}, ctx)
	sklAni:SetNext(aniRushTo)
			
	local aniAct = smartor.NewUnit("s_role_play_ani", {["atom_id"]="starman",["ani_name"]="skill_0_1",["loop_times"]=1}, ctx)
	sklAni:SetNext(aniAct)
	
	for idx, Victim in ipairs(targets) do 
		if Probability(10) then
			local buffAni = smartor.NewUnit("l_add_buff", {["Placer"]=Attacker,["Victim"]=Victim,["BuffType"]=1003}, ctx)
			aniAct:AddPart(KEYFRAME1, buffAni)
		end
		
		local hurtAni = smartor.NewUnit("l_hurt", {["Attacker"]=Attacker, ["Victim"]=Victim, ["iDamagePower"]=1}, ctx)	
		aniAct:AddPart(KEYFRAME1, hurtAni)
	end
		
	local aniRushBack = smartor.NewUnit("x_move_to", {["atom_id"]="starman",["dx"]=fromX,["dy"]=fromY,["seconds"]=rushTime}, ctx)
	aniAct:SetNext(aniRushBack)
	
	return xTree
end

-------------------------
-- 21XXX 远程2 单攻1
-------------------------
ALL_GEN_FUNC[21001] = function(Attacker)
	local instFight = fight.FightService.GetInstance()
	local xMid = instFight:GetXMid()
	local yMid = instFight:GetYMid()
	local DIS = instFight:GetDis()
	local SPACE = instFight:GetSpace()

	local targetLgc = g_SingleEnemyLessHp
	local targets = targetLgc:Search(Attacker,1)
	logger.fight(string.format("%d发起攻击：目标数量%d",Attacker:GetUid(),#targets))
	
	local xTree = smartor.clsSmartTree.new()
	local ctx = xTree:GetContext()
	local sklAni = smartor.NewUnit("x_root_node", nil, ctx)
	xTree:SetRoot(sklAni)
	
	if #targets <= 0 then return xTree end 
	
	local Victim = targets[1]
	
	local aniAct = smartor.NewUnit("s_role_play_ani", {["atom_id"]="starman",["ani_name"]="skill_0_1",["loop_times"]=1}, ctx)
	sklAni:SetNext(aniAct)
	
	local fromX, fromY = Attacker:getPosition()
	if fromX < xMid then fromX = fromX + 130 else fromX = fromX - 130 end 
	fromY = fromY + 50 
	local toX, toY = Victim:getPosition()
	toY = toY + 50 
		
	local argInfo = { 
		["sResPath"] = "effects/effect_img/huoqiu.png",["sResType"] = "Sprite", 
		["fromX"]=fromX, ["fromY"]=fromY, ["toX"]=toX, ["toY"]=toY, ["speed"]=1800, ["jmpH"]=150, 
	}
	local shootAni = smartor.NewUnit("l_shoot_curve", argInfo, ctx)
		
	if Probability(13) then
		local buffAni = smartor.NewUnit("l_add_buff", {["Placer"]=Attacker,["Victim"]=Victim,["BuffType"]=4002}, ctx)
		shootAni:SetNext(buffAni)
	end
	
	local hurtAni = smartor.NewUnit("l_hurt", {["Attacker"]=Attacker,["Victim"]=Victim,["iDamagePower"]=1}, ctx)	
	shootAni:SetNext(hurtAni)
				
	aniAct:AddPart(KEYFRAME2, shootAni)
	
	return xTree
end

-------------------------
-- 22XXX 远程2 群攻2
-------------------------
--一批进攻，碰撞一个打击一个
ALL_GEN_FUNC[22001] = function(Attacker)
	local instFight = fight.FightService.GetInstance()
	local xMid = instFight:GetXMid()
	local yMid = instFight:GetYMid()
	local DIS = instFight:GetDis()
	local SPACE = instFight:GetSpace()

	local targetLgc = g_AllEnemy
	local targets = targetLgc:Search(Attacker,1)
	logger.fight(string.format("%d发起攻击：目标数量%d",Attacker:GetUid(),#targets))
	
	local xTree = smartor.clsSmartTree.new()
	local ctx = xTree:GetContext()
	local sklAni = smartor.NewUnit("x_root_node", nil, ctx)
	xTree:SetRoot(sklAni)
	
	if #targets <= 0 then return xTree end 
	
	local aniAct = smartor.NewUnit("s_role_play_ani", {["atom_id"]="starman",["ani_name"]="skill_0_1",["loop_times"]=1}, ctx)
	sklAni:AddPart(0,aniAct)
	
	local minX, maxX = GetMinMaxX(targets, xMid)
	local fromX, fromY = Attacker:getPosition()
	fromY = fromY + 50
	local toX, toY = maxX, fromY
	if fromX < xMid then 
		fromX = fromX + 130 
		toX = maxX
	else 
		fromX = fromX - 130 
		toX = minX
	end 
	
	local movSpeed = 1000 
	
	local argInfo = { ["sResType"]="EffectSeq", ["sResPath"]="effects/effect_seq/tornado1.plist",
					  ["fromX"]=fromX, ["fromY"]=fromY, ["toX"]=toX, ["toY"]=toY, ["speed"]=movSpeed, }
	local shootAni = smartor.NewUnit("l_shoot_line", argInfo, ctx)
	
	for idx, Victim in ipairs(targets) do 
		local iFrame = math.abs(fromX-Victim:GetPosX())/movSpeed
		
		local hurtAni = smartor.NewUnit("l_hurt", {["Attacker"]=Attacker,["Victim"]=Victim,["iDamagePower"]=1}, ctx)
		shootAni:AddPart(utils.Second2Frame(iFrame), hurtAni)
		
		if Probability(10) then
			local buffAni = smartor.NewUnit("l_add_buff", {["Placer"]=Attacker,["Victim"]=Victim,["BuffType"]=3002}, ctx)
			shootAni:AddPart(utils.Second2Frame(iFrame), buffAni)
		end
	end
	
	sklAni:AddPart(KEYFRAME2, shootAni)
	
	return xTree
end

--三批攻击，每批打击N个
ALL_GEN_FUNC[22002] = function(Attacker)
	local instFight = fight.FightService.GetInstance()
	local xMid = instFight:GetXMid()
	local yMid = instFight:GetYMid()
	local DIS = instFight:GetDis()
	local SPACE = instFight:GetSpace()

	local targetLgc = g_AllEnemy
	local targets = targetLgc:Search(Attacker,1)
	logger.fight(string.format("%d发起攻击：目标数量%d",Attacker:GetUid(),#targets))
	
	local xTree = smartor.clsSmartTree.new()
	local ctx = xTree:GetContext()
	local sklAni = smartor.NewUnit("x_root_node", nil, ctx)
	xTree:SetRoot(sklAni)
	
	if #targets <= 0 then return xTree end 
	
	local aniAct = smartor.NewUnit("s_role_play_ani", {["atom_id"]="starman",["ani_name"]="skill_0_1",["loop_times"]=1}, ctx)
	sklAni:SetNext(aniAct)
	
	local minX, maxX = GetMinMaxX(targets, xMid)
	local fromX, fromY = (minX+maxX)/2, Attacker:GetPosY()+250
	for iii=1, 3 do 
		for idx, Victim in ipairs(targets) do 
			local toX, toY = Victim:getPosition()
			toY = toY + 50 
			local argInfo = { ["sResType"]="particle", ["sResPath"]="effects/particle/SmallSun.plist", ["iPositionType"]=0x1, 
							  ["fromX"]=fromX, ["fromY"]=fromY, ["toX"]=toX, ["toY"]=toY, ["speed"]=500 }
			local shootAni = smartor.NewUnit("l_shoot_line", argInfo, ctx)
			
			local hurtAni = smartor.NewUnit("l_hurt", {["Attacker"]=Attacker,["Victim"]=Victim,["iDamagePower"]=1}, ctx)
			shootAni:SetNext(hurtAni)
			
			aniAct:AddPart(utils.Second2Frame(0.36+0.2*iii),shootAni)
		end
	end 
	
	return xTree
end

--一批回血，每批打击N个
ALL_GEN_FUNC[22003] = function(Attacker)
	local instFight = fight.FightService.GetInstance()
	local xMid = instFight:GetXMid()
	local yMid = instFight:GetYMid()
	local DIS = instFight:GetDis()
	local SPACE = instFight:GetSpace()

	local targetLgc = g_AllMySide
	local targets = targetLgc:Search(Attacker,1)
	logger.fight(string.format("%d发起攻击：目标数量%d",Attacker:GetUid(),#targets))
	
	local xTree = smartor.clsSmartTree.new()
	local ctx = xTree:GetContext()
	local sklAni = smartor.NewUnit("x_root_node", nil, ctx)
	xTree:SetRoot(sklAni)
	
	if #targets <= 0 then return xTree end 
	
	local aniAct = smartor.NewUnit("s_role_play_ani", {["atom_id"]="starman",["ani_name"]="skill_0_1",["loop_times"]=1}, ctx)
	sklAni:SetNext(aniAct)
	
	for idx, Victim in ipairs(targets) do 
		local buffAni = smartor.NewUnit("l_add_buff", {["Placer"]=Attacker,["Victim"]=Victim,["BuffType"]=1001}, ctx)
		aniAct:AddPart(KEYFRAME1,buffAni)
	end 
	
	return xTree
end
