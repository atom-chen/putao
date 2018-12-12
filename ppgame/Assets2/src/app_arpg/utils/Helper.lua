-------------------------
-- 游戏辅助库
-------------------------
module("gameutil", package.seeall)

function AddObj2Map(obj,x,y)
	if not VVDirector:GetMap() then return false end
	return VVDirector:GetMap():AddObject(obj,x,y)
end

function PopReward(BonusList)
	if not BonusList or #BonusList<=0 then logger.normal("奖励为空") return end
	local procedure_1 = smartor.clsPromise.new()
	procedure_1:SetProcFunc(function(thisObj, promise) 
		local wnd = ClsUIManager.GetInstance():ShowDialog("clsRewardUI", true, function()
			promise:Done()
		end) 
		if wnd then wnd:SetBonusList(BonusList) end
		KE_SetAbsTimeout(5, function() promise:Done() end)
	end)
	procedure_1:SetEndCallback(function()
		ClsUIManager.GetInstance():DestroyWindow("clsRewardUI") 
	end)
	VVDirector:GetTipProcedure():SetNext(procedure_1)
end
