-------------------------
-- 消消乐进入页面
-------------------------
module("xiaoxiaole", package.seeall)

local FruitItem = require("app.xiaoxiaole.view.FruitItem") 

clsXiaoxiaoleGameScene = class("clsXiaoxiaoleGameScene", clsScene)

function clsXiaoxiaoleGameScene:ctor()
    ClsResManager.GetInstance():AddSpriteFrames("xiaoxiaole/xxl_play.plist", "xiaoxiaole/xxl_play.png")
    self.m_items = {}
    self.m_require = {{}, {}}
    self.m_score = 0
    self.m_propState = 0
    self.m_root = self:createBaseUI()
    --kAudioManager:playMusic("GameBGM", true)

end

function clsXiaoxiaoleGameScene:createBaseUI()
    local root_base = display.newNode()
                :setPosition(display.cx, display.cy)
                :setContentSize(cc.size(1, 1))
                :addTo(self)

    local bg = display.newSprite("xiaoxiaole/bg/game_bg.jpg")
                :setPosition(0, 0)
                :addTo(root_base)
    kSystemManager():setNodeFullScreen(bg)


    local branch = utils.CreateSprite("xiaoxiaole/bg/branch.png")
                :setAnchorPoint(cc.p(0, 0.5))
                :setPosition(-display.cx - 10, display.cy - 120)
                :setScale(0.8)
                :addTo(root_base)

    local leftleaf = utils.CreateSprite("xiaoxiaole/xxl_play/branch_beaf.png")
                :setPosition(cc.p(-display.cx + 60, display.cy - 30))
                :setScale(1.2)
                :setRotation(90)
                :addTo(root_base)

    local rightleaf = utils.CreateSprite("xiaoxiaole/xxl_play/branch_beaf.png")
                :setPosition(cc.p(display.cx - 60, display.cy - 30))
                :setScale(1.2)
                :setRotation(-90)
                :setFlippedX(true)
                :addTo(root_base)

    local leaf1 = utils.CreateSprite("xiaoxiaole/xxl_play/branch_beafs.png")
                :setPosition(cc.p(-100, display.cy + 10))
                :setFlippedX(true)
                :setScale(2)
                :addTo(root_base)

    local leaf2 = utils.CreateSprite("xiaoxiaole/xxl_play/branch_beafs.png")
                :setPosition(cc.p(80, display.cy + 10))
                :setScale(2)
                :addTo(root_base)

    local step_bg = utils.CreateSprite("xiaoxiaole/xxl_play/step_bg.png")
                :setAnchorPoint(cc.p(0.5, 1))
                :setPosition(display.cx - 100, display.cy + 5)
                :addTo(root_base)

    local step_tip = utils.CreateLabel("Remain Steps",28)
                :setAnchorPoint(cc.p(0.5, 0.5))
                :setPosition(80, 90)
                :addTo(step_bg)

    local step_lab = utils.CreateLabel("10", 24, cc.c3b(222,222,222))
                :setAnchorPoint(cc.p(0.5, 0.5))
                :setPosition(80, 50)
                :addTo(step_bg)

    local leveTip = utils.CreateLabel("Stage 1", 32, cc.c3b(11,23,245))
                :setAnchorPoint(cc.p(0.5, 0.5))
                :setPosition(-display.cx + 60, display.cy - 30)
                :addTo(root_base)

    local scoreLab = utils.CreateLabel("Score: 0", 24, cc.c3b(244,22,22))
            :setAnchorPoint(cc.p(0, 0.5))
            :setPosition(-display.cx+5 , display.cy - 140)
            :addTo(root_base)

    local pauseBtn = ccui.Button:create("xiaoxiaole/xxl_play/btn_pause.png", "", "", ccui.TextureResType.plistType)
		    root_base:addChild(pauseBtn)
		    pauseBtn:setPosition(-display.cx + 60, display.cy - 80)

    local btn = ccui.Button:create("xiaoxiaole/xxl_play/green_btn.png", "", "", ccui.TextureResType.plistType)
		    root_base:addChild(btn)
		    btn:setPosition(0, -display.cy + 100)
		   	btn:hide()
    
    
    self.m_root = root_base
    self.m_leveLab = leveTip
    self.m_stepLab = step_lab
    self.m_scoreLab = scoreLab

    utils.RegClickEvent(pauseBtn, function()
        local dlg = getTipDlg().new()
        dlg:addTo(self)
        dlg:show({mode = 1,})
    end)

    utils.RegClickEvent(btn, function()
        self:refreshCurGame(self.m_passState)
    end)
    
    self:createRequireNode()
    self:setLeveInfo(T_stages_info[g_curLevel])
    
    self:createItemPanel()
    self:createProps()

    return root_base
end

function clsXiaoxiaoleGameScene:createProps()
    local propNode = display.newNode()
            :setPosition(0, - display.cy + 160)
            :addTo(self.m_root)

    local imgParam = {
        "xiaoxiaole/xxl_play/img_refresh.png",
        "xiaoxiaole/xxl_play/img_remove.png",
        "xiaoxiaole/xxl_play/img_exchange.png",
        "xiaoxiaole/xxl_play/img_addstep.png",
    }

    local space = 150
    self.m_props = {}

    for i = 1,4 do
        local btn = ccui.Button:create("xiaoxiaole/xxl_play/img_pop.png", "xiaoxiaole/xxl_play/img_pop.png", "", ccui.TextureResType.plistType)
		propNode:addChild(btn)
		btn:setPosition(space * (i - 2) - space/2, 0)
		btn:setScale(120/154)

        btn.light = display.newSprite("xiaoxiaole/img_prop_light.png")
                :addTo(btn)
                :setScale(170/101)
                :hide()

        local sprite = display.newSprite(imgParam[i])
                :addTo(btn)
        

        utils.RegClickEvent(btn, function()
            self:propEvent(i)
        end, 120/154)

        self.m_props[i] = btn
    end
end

function clsXiaoxiaoleGameScene:propEvent(index)
    if index == 1 then
        self:createItems(index)
        self:refreshPropState(0)
    elseif index == 2 then
        self:refreshPropState(self.m_propState ~= index and index or 0)
    elseif index == 3 then
        self:refreshPropState(self.m_propState ~= index and index or 0)
    elseif index == 4 then
        self:propAddStep(index)
        self:refreshPropState(0)
    end
end

function clsXiaoxiaoleGameScene:refreshPropState(index)
    self.m_propState = index
    for i = 1, 4 do
        local btn = self.m_props[i]
        if btn.light then
            btn.light:setVisible(i == index)
        end
    end
    if i ~= 0 and notnull(self.m_selectItem) then
        self.m_selectItem:setActive(false)
        self.m_selectItem = nil
    end
end

function clsXiaoxiaoleGameScene:propAddStep(index)
    if self.m_stepCount  then
        self.m_stepCount = self.m_stepCount + 5
        self:setStepCount(self.m_stepCount)
    end
end

function clsXiaoxiaoleGameScene:createRequireNode(param)
    param = param or {}
    for i = 1,2 do
        local data = param[i] or {}
        local offx = i == 1 and -100 or 30
        local index = data.index or 1
        local count = data.count or 0

        local require_node = display.newNode()
                    :setPosition(offx, display.cy)
                    :setTag(0x1111)
                    :addTo(self.m_root)

        local rope = display.newSprite("#xiaoxiaole/xxl_play/rope.png")
                    :setPosition(0, 0)
                    :setAnchorPoint(cc.p(0.5, 1))
                    :setLocalZOrder(1)
                    :addTo(require_node)

        local panel_broad = display.newSprite("#xiaoxiaole/xxl_play/item_broad.png")
                    :setPosition(0, -85)
                    :addTo(require_node)

        local panel_broad_bg = utils.CreateScale9Sprite("xiaoxiaole/xxl_play/item_broad_bg.png")
                    :setContentSize(cc.size(80, 60))
                    :setPosition(0, -88)
                    :addTo(require_node)

        local needItem = display.newSprite("#xiaoxiaole/xxl_play/item".. index .."_1.png")
                    :setPosition(0, -88)
                    :setScale(0.75)
                    :addTo(require_node)

        local needLab = utils.CreateLabel(tostring(count), 25, cc.c3b(33,22,22))
                    :setAnchorPoint(cc.p(0.5, 0.5))
                    :setPosition(25, -115)
                    :addTo(require_node)

        require_node:setVisible(param[i] and true or false)

        self.m_require[i].node = require_node
        self.m_require[i].index = data.index or 0
        self.m_require[i].count = count
        self.m_require[i].item = needItem
        self.m_require[i].countLab = needLab
    end
end

-- 设置关卡信息
function clsXiaoxiaoleGameScene:setLeveInfo(param)
    local level = g_curLevel
    local requireItem = param.requireItem
    local step = param.step

    self.m_stepCount = step
    self:setCurLevel(level)
    self:setStepCount(self.m_stepCount)

    for i = 1, 2 do
        local panel = self.m_require[i]
        local v = requireItem[i]
        if panel and v then
            panel.node:setVisible(true)
            panel.index = v.index
            panel.count = v.count
            setimg(panel.item, "xiaoxiaole/xxl_play/item" .. v.index .. "_1.png")
            panel.countLab:setString(v.count)
        elseif panel and not v then
            panel.node:setVisible(false)
        end
    end
end

-- 跟新当前进度
function clsXiaoxiaoleGameScene:refreshCurProgState(notWithAni)
    if notWithAni then
        return
    end
    
    local data = self.m_eliminateItems
    for k,v in pairs(data) do
        for i = 1,2 do
            local panel = self.m_require[i]
            if panel and v.m_index == panel.index then
                panel.count = panel.count - 1
                panel.countLab:setString(panel.count > 0 and panel.count or 0)
            end
        end
    end
end

--检查本关进度
function clsXiaoxiaoleGameScene:checkCurProgState()
    local finish = self.m_require[1].count <= 0 and self.m_require[2].count <= 0

    if self.m_stepCount <= 0 and not finish then
        self:loseCurLevel()
    elseif self.m_stepCount >= 0 and finish then
        self:passCurLevel()
    else
        return true
    end

    return false
end

--重开本关
function clsXiaoxiaoleGameScene:refreshCurGame(flag)
    g_curLevel = flag and (g_curLevel < MAXSTAGE and g_curLevel + 1 or MAXSTAGE) or g_curLevel
    local info = T_stages_info[g_curLevel]
    if info then
        self:setLeveInfo(info)
        self:createItems()
    end
    self.m_score = 0
    self.m_scoreLab:setString("Score: "..self.m_score)
end

--未通过当前关卡
function clsXiaoxiaoleGameScene:loseCurLevel()
    self.m_passState = false
    local dlg = getTipDlg().new()
    dlg:addTo(self)
    dlg:show({mode = 3,})
end

--通过当前关卡
function clsXiaoxiaoleGameScene:passCurLevel()
    self.m_passState = true
    self.m_score = self.m_score + self.m_stepCount * ITEM_SCORE * 10
    self.m_scoreLab:setString("Score: "..tostring(self.m_score))
    
    local usrInfo = kGameCache():getCacheData("usrInfo") or {
		passLevel = 1,
		stageInfo = {},
	}

    if usrInfo.passLevel == g_curLevel then
        usrInfo.passLevel = (g_curLevel < MAXSTAGE) and g_curLevel + 1 or MAXSTAGE
    end
    if not usrInfo.stageInfo[g_curLevel] then
        usrInfo.stageInfo[g_curLevel] = self.m_score
    elseif usrInfo.stageInfo[g_curLevel] < self.m_score then
        usrInfo.stageInfo[g_curLevel] = self.m_score
    end
    kGameCache():saveCacheData("usrInfo", usrInfo, true)
    
    local dlg = getTipDlg().new()
    dlg:addTo(self)
    dlg:show({mode = 2,})
end

--设置当前关卡
function clsXiaoxiaoleGameScene:setCurLevel(level)
    self.m_leveLab:setString("Stage: " .. level)
end

--设置剩余步数
function clsXiaoxiaoleGameScene:setStepCount(count)
    self.m_stepCount = count or self.m_stepCount - 1
    self.m_stepLab:setString(self.m_stepCount > 0 and self.m_stepCount or 0)
end

-- 创建item
function clsXiaoxiaoleGameScene:createItems()
 --   kAudioManager:playSound("begain", false)
    for k,v in pairs(self.m_items) do
        if notnull(v) then
            v:removeSelf()
        end
    end
    self.m_items = {}
    ITEM_VISIBLE = false
    ITEM_START = 6
    local info = T_stages_info[g_curLevel]
    for k,v in pairs(info.requireItem) do
        ITEM_START = ITEM_START > v.index and v.index or ITEM_START
    end
    ITEM_START = ITEM_START - 1
    ITEM_COUNT = 4 + math.floor(g_curLevel/8)
    ITEM_COUNT = ITEM_COUNT > 6 and 6 or ITEM_COUNT
    if ITEM_COUNT + ITEM_START > 6 then
        ITEM_START = 6 - ITEM_COUNT
    end
	print("------------", g_curLevel, ITEM_START, ITEM_COUNT, ITEM_INDEX)
    for y = 1, ITEM_INDEX do
        for x = 1, ITEM_INDEX do
            self:setItemByPos(x, y, self:createItem(x, y))
        end
    end
    
    self:resetItem()
    self:eliminateByAll(true)
end

-- 创建itemPanel
function clsXiaoxiaoleGameScene:createItemPanel()
     local item_panel = ccui.ImageView:create()
            :setPosition(- ITEM_WIDTH * ITEM_INDEX /2, - ITEM_WIDTH * ITEM_INDEX /2)
            :addTo(self.m_root)


    -- 初始化随机数
    math.newrandomseed()
    self.m_panel    = item_panel

    for y = 1, ITEM_INDEX do
        for x = 1, ITEM_INDEX do
            local pos = getItemPos(x, y)
            local bg = display.newSprite("#xiaoxiaole/xxl_play/item_bg.png")
                        :setScale(ITEM_WIDTH / 69)
                        :setPosition(pos.x, pos.y)
                        :setLocalZOrder(-1)
                        :addTo(item_panel)
        end
    end

    self:createItems()
--  debugNode(item_panel) 
end


-- 创建item
function clsXiaoxiaoleGameScene:createItem(x, y)
    local beginPos = cc.p(0, 0)
    local flag = true
    local item = FruitItem.new(x, y):addTo(self.m_panel)
 --   print("createItem", x,y)
    local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self:itemTouchEvent(item)
            flag = self.m_propState ~= 2
            if event then beginPos = cc.p(event.x, event.y) end
            return true
        elseif eventType == ccui.TouchEventType.moved then
        	if flag and false then
                
                local offx = event.x - beginPos.x
                local offy = event.y - beginPos.y

                if math.abs(offx) > ITEM_WIDTH/2 or math.abs(offy) > ITEM_WIDTH/2 then
                    flag = false
                    if math.abs(offx) > math.abs(offy) then
                        if offx > 0  then
                            self:itemTouchEvent(self:getItemByPos(item.x + 1, item.y))
                        else
                            self:itemTouchEvent(self:getItemByPos(item.x - 1, item.y))
                        end
                    else
                        if offy > 0 then
                            self:itemTouchEvent(self:getItemByPos(item.x, item.y + 1))
                        else
                            self:itemTouchEvent(self:getItemByPos(item.x, item.y - 1))
                        end
                    end
                end
            end
        elseif eventType == ccui.TouchEventType.ended then 
        	flag = true
		end
	end
	item:addTouchEventListener(touchEvent)

    return item
end

-- 消除所有可消除
function clsXiaoxiaoleGameScene:eliminateByAll(notWithAni)
    self.m_start = self.m_start or os.clock()
    self.m_eliminateItems = {}
    self.m_hasEliminate = false

    self:setItemTouchEnable(false)
    ITEM_ENABLE = false
    
    print("eliminateByAll: 消除所有可消除", #self.m_items)

    for i = 1, #self.m_items do
        local item = self.m_items[i]
        self:eliminateByitem(item)
        if self.m_hasEliminate then
            break
        end
    end

    self:eliminate(notWithAni)
end

-- 消除item周围
function clsXiaoxiaoleGameScene:eliminateByitem(item)
    if isnull(item) then
        print("===eliminateByitem====ERR")
        return
    end

    self.m_neighborItems = {}
    self:findNeighborItem(item)

    self:checkEliminate()

end

--消除完成
function clsXiaoxiaoleGameScene:eliminateFinish()
    print("=========eliminateFinish==========" .. os.clock() - self.m_start)
    
    if self:checkCurProgState() then
        self:setItemTouchEnable(true)
        ITEM_ENABLE = true
    end


    self:setItemVisible(true)
    ITEM_VISIBLE = true

    self.m_start = nil
end

-- 消除
function clsXiaoxiaoleGameScene:eliminate(notWithAni)
    if #self.m_eliminateItems <= 0 then
        self:eliminateFinish()
        return
    end

    self.m_hasEliminate = true

    local delay1 = self.m_firstEliment and 0.3 or 0.1
    local delay2 = delay1 + 0.3
    self.m_firstEliment = false

    delay_do(self, function()
    --    kAudioManager:playSound("wrap", false)
    end, delay1)

    -- dump(self.m_eliminateItems)
    print("播放消除动画:", #self.m_eliminateItems, notWithAni)
    
    self:refreshCurProgState(notWithAni)
    for i = 1, #self.m_eliminateItems do
        local item = self.m_eliminateItems[i]
        if notnull(item) then
            delay_do(self, function()
                --local animation = display.getAnimationCache("destroy")
                --local action = cc.Animate:create(animation)
                if notnull(item) then
                    item:setScale(ITEM_WIDTH/90)
                    item:runAction(cc.ScaleTo:create(0.1,0.1))
                end
            end, delay1)
            delay_do(self, function()
                if notnull(item) then
                    local itemPos = item:getCoordPos()
                    item:removeSelf()
                    item = nil
                    local flag = ITEM_INDEX + 1
                    while self:getItemByPos(itemPos.x, flag) do
                        flag = flag + 1
                    end
                    self:setItemByPos(itemPos.x, flag, self:createItem(itemPos.x, flag))
                    self:setItemByPos(itemPos.x, itemPos.y, nil)

                else
                    print("==eliminate=====ERR2")
                end
                if i == #self.m_eliminateItems then
                    if not notWithAni then
                        self.m_score = self.m_score + ITEM_SCORE * #self.m_eliminateItems
                        self.m_scoreLab:setString("Score: "..tostring(self.m_score))
                    end
                    self:dropOut(notWithAni)
                end
            end, notWithAni and 0 or delay2)
        else
            self:dropOut(notWithAni)
            print("==eliminate=====ERR1")
        end

    end
end

-- 掉落
function clsXiaoxiaoleGameScene:dropOut(notWithAni, callback)
    local maxTime = 0
    local hasDorp = false
    for x = 1, ITEM_INDEX do
        for y = 1, ITEM_INDEX do
            local item = self:getItemByPos(x, y)
            local aniTime = 0.1
            while isnull(item) do
                hasDorp = true
                local maxindex = self:getMaxIndexByX(x)
                for i = y + 1, maxindex do
                    self:dropDown(self:getItemByPos(x, i), aniTime, notWithAni)
                end
                maxTime = maxTime > aniTime and maxTime or aniTime
                aniTime = aniTime + 0.04
                item = self:getItemByPos(x, y)
            end
        end
    end

    delay_do(self, function()
        self:eliminateByAll(notWithAni)
    end, notWithAni and 0 or maxTime)
end

-- item下落一个
function clsXiaoxiaoleGameScene:dropDown(item, time, notWithAni)
    if isnull(item) then
        return
    end
    local itemPos = item:getCoordPos()

    if notnull(self:getItemByPos(itemPos.x, itemPos.y - 1)) then
        return
    end

    item:setPosByCoord(item.x, item.y - 1, not notWithAni, time)
    self:setItemByPos(itemPos.x, itemPos.y - 1, item)
    self:setItemByPos(itemPos.x, itemPos.y , nil)
end

-- 获取最大的indexY
function clsXiaoxiaoleGameScene:getMaxIndexByX(x)
    if x < 1 or x > ITEM_INDEX then
        return
    end
    local count = ITEM_INDEX
    while self:getItemByPos(x, count + 1) do
        count = count + 1
    end
    return count
end

-- 递归搜索相邻
function clsXiaoxiaoleGameScene:findNeighborItem(item)
    local itemPos = item:getCoordPos()
    local itemIndex = item.m_index or 0

    for k,v in pairs(self.m_neighborItems) do
        if v.x == itemPos.x and  v.y == itemPos.y then
            return
        end
    end

    table.insert(self.m_neighborItems, item)

    local leftItem = self:getItemByPos(itemPos.x - 1, itemPos.y)
    if leftItem and leftItem.m_index ==  itemIndex then
        self:findNeighborItem(leftItem)
    end

    local upItem = self:getItemByPos(itemPos.x , itemPos.y + 1)
    if upItem and upItem.m_index ==  itemIndex then
        self:findNeighborItem(upItem)
    end

    local rightItem = self:getItemByPos(itemPos.x + 1, itemPos.y )
    if rightItem and rightItem.m_index ==  itemIndex then
        self:findNeighborItem(rightItem)
    end

    local downItem = self:getItemByPos(itemPos.x , itemPos.y - 1)
    if downItem and downItem.m_index ==  itemIndex then
        self:findNeighborItem(downItem)
    end
end

-- 检查能消除的水果
function clsXiaoxiaoleGameScene:checkEliminate()
    if #self.m_neighborItems < 3 then
        return 
    end

    -- 检查是否存在相邻
    local function checkInNeighbor(item)
        for k,v in pairs(self.m_neighborItems) do
            if v.x == item.x and v.y == item.y then
                return true
            end
        end
        return false
    end

    -- 找到相邻个数
    local function findDirection(dir, gap, count, itemPos)
        local offx, offy = 0, 0

        local flag = gap
        while flag do
            offx = dir and 0 or flag
            offy = dir and flag or 0
            local item = self:getItemByPos(itemPos.x + offx, itemPos.y + offy)
            if item and checkInNeighbor(item) then
                count = count + 1
                flag = flag + gap
            else
                flag = false
            end
        end
        return count
    end

    for k,v in pairs(self.m_neighborItems) do
        local row, col = 0, 0
        local itemPos = v:getCoordPos()

        row = findDirection(false, -1, row, itemPos)
        row = findDirection(false, 1, row, itemPos)
        col = findDirection(true, 1, col, itemPos)
        col = findDirection(true, -1, col, itemPos)

        if row >= 2 or col >= 2 then
            local flag = true
            for _,vv in pairs(self.m_eliminateItems) do
                if vv.x == v.x and vv.y == v.y then
                    flag = false
                end 
            end
            if flag then
                table.insert(self.m_eliminateItems, v)
            end
        end
    end
end

-- 点击或拖动事件
function clsXiaoxiaoleGameScene:itemTouchEvent(item)
    if isnull(item) then
        return
    end
	
	print("itemTouchEvent: ", self.m_propState)
    if self.m_propState == 2 then
        table.insert(self.m_eliminateItems, item)
        self.m_firstEliment = true
        item:setActive(true)
        self:eliminate()

        self:refreshPropState(0)
        return
    end

    if isnull(self.m_selectItem) then                                   
        --设置第一个选中的item
        print("设置第一个选中的item")
        self.m_selectItem = item
        self.m_selectItem:setActive(true)
    else
        --已有选中的item进行处理
        local selPos = self.m_selectItem:getCoordPos()
        local curPos = item:getCoordPos()
		print("尝试交换：", selPos.x,selPos.y, curPos.x,curPos.y)

        self.m_selectItem:setActive(item == self.m_selectItem)

        if self:checkExchange(selPos, curPos) then
        	print("可交换")
            self:setStepCount()
            self:changeItem(self.m_selectItem, item)

            local temp = self.m_selectItem

            self.m_firstEliment = true
            self:resetItem()
            print("开始消除")
            self:eliminateByAll()
            self.m_selectItem = nil

            if #self.m_eliminateItems == 0 then
                if self.m_propState ~= 3 then
                    delay_do(self, function()
                        self:changeItem(temp, item)
                    end, 0.2)
                else
                    self:refreshPropState(0)
                end
            end

        else
        	print("不可交换")
            item:setActive(true)
            self.m_selectItem = item
        end

    end
end

-- 交换item
function clsXiaoxiaoleGameScene:changeItem(item1, item2)
    
    local pos1 = item1:getCoordPos()
    local pos2 = item2:getCoordPos()

    item1:setPosByCoord(pos2.x, pos2.y, true)
    item2:setPosByCoord(pos1.x, pos1.y, true)

    local item = self:getItemByPos(pos1.x, pos1.y)
    self:setItemByPos(pos1.x, pos1.y, self:getItemByPos(pos2.x, pos2.y))
    self:setItemByPos(pos2.x, pos2.y, item)
end

-----------------------------------------------------------------------------------------------设置item的状态

-- 重设Item的状态
function clsXiaoxiaoleGameScene:resetItem()
    for k,v in pairs(self.m_items) do
        v:setActive(false)
    end
end

function clsXiaoxiaoleGameScene:setItemVisible(isVisible)
    for k,v in pairs(self.m_items) do
        if v then
            v:setVisible(isVisible)
        end
    end
end

function clsXiaoxiaoleGameScene:setItemTouchEnable(enable)
    for k,v in pairs(self.m_items) do
        if v then
            v:setTouchEnabled(enable)
        end
    end
end

-- 获取item
function clsXiaoxiaoleGameScene:getItemByPos(x, y)
    if x > ITEM_INDEX or x < 1 then
        return false
    end
    return self.m_items[(y - 1) * ITEM_INDEX + x]
end

-- 设置item
function clsXiaoxiaoleGameScene:setItemByPos(x, y, item)
    if notnull(item) then
        item:setVisible(ITEM_VISIBLE)
    end
    self.m_items[(y - 1) * ITEM_INDEX + x] = item
end
-----------------------------------------------------------------------------------------------设置item的状态

-- 检查是否能交换
function clsXiaoxiaoleGameScene:checkExchange(selPos, curPos)
    local flag = false
    if (selPos.x == curPos.x or selPos.y == curPos.y) and math.abs(selPos.x + selPos.y - curPos.x - curPos.y) == 1 then
        flag = true
    end
    return flag
end

const.SCENE_CFG.clsXiaoxiaoleGameScene = { scene_cls = clsXiaoxiaoleGameScene }