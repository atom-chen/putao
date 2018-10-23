-----------------------
-- 全局变量
-----------------------
module("xiaoxiaole", package.seeall)

T_stages_info = require("app.xiaoxiaole.mgr.T_stages_info") 

g_curLevel = 1
MAXSTAGE = #T_stages_info
SOUNDFLAG = true
MUSICFLAG = true
ITEM_WIDTH = display.width/9
ITEM_INDEX = 7
ITEM_COUNT = 6
ITEM_START = 6
ITEM_VISIBLE = false
ITEM_ENABLE = true
ITEM_SCORE = 20

-----------------------
-- 全局函数
-----------------------
function dumpGlobalVars()
	print("---------------------")
	print("g_curLevel =", g_curLevel)
	print("MAXSTAGE =", MAXSTAGE)
	print("SOUNDFLAG =", SOUNDFLAG)
	print("MUSICFLAG =", MUSICFLAG)
	print("ITEM_WIDTH =", ITEM_WIDTH)
	print("ITEM_INDEX =", ITEM_INDEX)
	print("ITEM_COUNT =", ITEM_COUNT)
	print("ITEM_START =", ITEM_START)
	print("ITEM_VISIBLE =", ITEM_VISIBLE)
	print("ITEM_ENABLE =", ITEM_ENABLE)
	print("ITEM_SCORE =", ITEM_SCORE)
end 

-- getFruitPos
function getItemPos(x, y)
    local posx = (x - 0.5) * ITEM_WIDTH
    local posy = (y - 0.5) * ITEM_WIDTH
    return {x = posx, y = posy}
end

function getRandomIndex(count)
	count = count or ITEM_COUNT
	return math.round(math.random() * 1000) % count + 1
end

-- 延时异步操作
function delay_do (target, callback, time)
	if time == nil then 
		time = 0.01	
	end 
	
	if not target then 
		target = getAncestor()
	end 
	
	if time > 0 then 
		local sequence = transition.sequence({
			cc.DelayTime:create(time),
			cc.CallFunc:create (function ()
				if notnull(target) then 
					if callback then
						callback ()
					end
				end 
			end)
		})
		target:runAction (sequence)
	else 
		if notnull (target) then 
		if callback then 
			callback ()
		end
	end
	end
end

-- 自动设置X
function setAutoOffX (node, node2, offx)
	if isnull(node) or isnull(node2) then
		return
	end
	offx = offx or 0

	local pos = node:getPositionX()
	local anchor = node:getAnchorPoint()
	local size = node:getContentSize()

	local anchor2 = node2:getAnchorPoint()
	local size2 = node2:getContentSize()
	-- dump(pos)

	node2:setPositionX(pos + (1 - anchor.x) * size.width + size2.width * anchor2.x + offx)
end

-- 显示node的范围
function debugNode(node,color)
	if isnull (node) then 
		return ;
	end
	local box = node:getBoundingBox()
	local dnode = cc.DrawNode:create()
	local px,py = node:getPosition()
	dnode:drawRect(cc.p(box.x,box.y),cc.p(box.x + box.width,box.y + box.height),color or cc.c4f(1,1,0,1))
	node:getParent():addChild(dnode,100)
	return dnode;
end

--
function getAncestor (tar)
	if not tar then 
		tar = cc.Director:getInstance():getRunningScene()
	else 
		if tar.getParent then 
			tar = tar:getParent ()
		end
		
		if not tar then 
			tar = cc.Director:getInstance():getRunningScene()
		end
	end
	
	return tar
end

function isnull(target)
	return tolua.isnull(target)
end

function notnull(target)
	return not isnull (target);
end

function setimg(tar, img)
	if isnull(tar) then
		return 
	end

	local frame = display.newSpriteFrame(img)
	if frame then
		tar:setSpriteFrame(frame)
	end
end

function getDlgBase()
	return require("app.xiaoxiaole.view.DialogBase") 
end

function getTipDlg()	
	return require("app.xiaoxiaole.view.TipDlg") 
end

