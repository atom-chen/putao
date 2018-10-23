-------------------
-- 消除
-------------------
module("xiaoxiaole", package.seeall)

FruitItem = class("FruitItem", function(x, y, index, callback)
    index = index or getRandomIndex()
    index = index + ITEM_START
    local respath = "xiaoxiaole/xxl_play/item" .. index .. "_1.png"
    local sprite = ccui.ImageView:create(respath, ccui.TextureResType.plistType)
    sprite:setScale(ITEM_WIDTH/70)
    sprite:setVisible(ITEM_VISIBLE)
                                        
    sprite.m_index = index or 0
    sprite.m_isActive = false
    sprite.m_callbace = callback
	
	print("---- new FruitItem: ", index, respath)
    return sprite
end)

function FruitItem:ctor(x, y, index, callback)
    self:setPosByCoord(x, y)

    self:setTouchEnabled(ITEM_ENABLE)
end

function FruitItem:setActive(active)
    self.m_isActive = active
    if self.m_isActive then
    	self:loadTexture("xiaoxiaole/xxl_play/item" .. self.m_index .."_2.png", ccui.TextureResType.plistType)
    else
        self:loadTexture("xiaoxiaole/xxl_play/item" .. self.m_index .."_1.png", ccui.TextureResType.plistType)
    end
end

function FruitItem:getCoordPos()
    return {x = self.x, y = self.y}
end

function FruitItem:setPosByCoord(x, y, withAni, aniTime)
    self.x = x or 0
    self.y = y or 0
    aniTime = aniTime or 0.15

    local pos = getItemPos(x, y)
    if not withAni then
        self:setPosition(pos)
    else
        self:stopAllActions()
        self:runAction(cc.MoveTo:create(aniTime, pos))
    end
end


return FruitItem
