------------------
-- 控制游戏进程
------------------
clsGameArpg = class("clsGameArpg")

function clsGameArpg:ctor()
	self._mPhysWorld = phys.ClsPhysicsWorld.GetInstance()		--碰撞检测空间
	self._mRoleMgr = ClsRoleSprMgr.GetInstance()				--角色管理器
	self._mMissileMgr = missile.ClsMissileMgr.GetInstance()		--子弹管理器
	self._mEffectMgr = ClsEffectMgr.GetInstance()				--特效管理器
	self._mStoryPlayer = ClsStoryPlayer.GetInstance()			--剧情播放器
	self._mFightSystem = fight.FightService.GetInstance()		--战斗管理器
end

function clsGameArpg:dtor()
	self._mPhysWorld = phys.ClsPhysicsWorld.DelInstance()
	self._mStoryPlayer = ClsStoryPlayer.DelInstance()
	self._mFightSystem = fight.FightService.DelInstance()
	self._mEffectMgr = ClsEffectMgr.DelInstance()
	self._mRoleMgr = ClsRoleSprMgr.DelInstance()
	self._mMissileMgr = missile.ClsMissileMgr.DelInstance()
end

function clsGameArpg:PauseGame()
	
end

function clsGameArpg:ResumeGame()
	
end
