module("xiaoxiaole", package.seeall)

local TipDlg = class("TipDlg", require("app.xiaoxiaole.view.DialogBase"))

function TipDlg:ctor()    
    self:createUI()
    kAudioManager:stopMusic(true)

    TipDlg.super.ctor(self)
end

function TipDlg:createUI()
    local bk = utils.CreateScale9Sprite("xiaoxiaole/xxl_play/com_mask.png")
            :setContentSize(cc.size(display.width, display.height))
            :setPosition(display.cx, display.cy)
            :addTo(self)

    local root_base = display.newNode()
            :setPosition(display.cx, display.cy)
            :setTouchEnabled(true)
            :addTo(self)

    local width, heigth = 550, 420
    local dlg_bg = utils.CreateScale9Sprite("xiaoxiaole/xxl_play/box_bg.png")
            :setContentSize(cc.size(width, heigth))
            :addTo(root_base)

    local dlg_fg = utils.CreateScale9Sprite("xiaoxiaole/xxl_play/box_fg.png")
            :setContentSize(cc.size(width - 30 * 2, heigth - 65 * 2))
            :addTo(root_base)

    local tipLab = utils.CreateLabel("Paused", 36, cc.c3b(22,22,22))
            :setAnchorPoint(cc.p(0.5, 0.5))
            :setPosition(0, 170)
            :addTo(root_base)

    local closebtn = ccui.Button:create("xiaoxiaole/xxl_play/btn_close.png", "", "", ccui.TextureResType.plistType)
    root_base:addChild(closebtn)
    closebtn:setPosition(225,175)

	utils.RegClickEvent(closebtn, function()
		self:close()
		self:closeEvent()
	end)

	self.m_bg = dlg_bg
	self.m_fg = dlg_fg
	self.m_tipLab = tipLab
	self.m_root = root_base
	self:createPauseUI()
	self:createPassUI()
	self:createFailUI()
end

function TipDlg:createFailUI()
    local failPanel = display.newNode()
            :addTo(self.m_root):hide()


    local againBtn = ccui.Button:create("xiaoxiaole/xxl_play/green_btn.png", "", "", ccui.TextureResType.plistType)
    failPanel:addChild(againBtn)
    againBtn:setPosition(0, -140)
    againBtn:setTitleFontSize(30)
    againBtn:setTitleText("再试一次")

    local loseImg = display.newSprite("#xiaoxiaole/xxl_play/lose_img.png") 
            :setPosition(0, 20)
            :setScale(1.3)
            :addTo(failPanel)

    self.m_againBtn = againBtn
    self.m_failPanel = failPanel
end

function TipDlg:createPassUI()
    local passPanel = display.newNode()
            :addTo(self.m_root):hide()

    local nextBtn = ccui.Button:create("xiaoxiaole/xxl_play/green_btn.png", "", "", ccui.TextureResType.plistType)
    passPanel:addChild(nextBtn)
    nextBtn:setPosition(0, -140)
    nextBtn:setTitleFontSize(30)
    nextBtn:setTitleText("下一关")

    local stars = {}
    for i = 1,3 do
        space = 160
        local sprite = display.newSprite("#xiaoxiaole/xxl_play/star_dark.png")
            :setPosition(space * (i - 2), 30)
            :setScale(0.8)
            :addTo(passPanel)
        stars[i] = sprite
    end

    local scoreLab = utils.CreateLabel("", 20, cc.c3b(22,22,22))
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setPosition(150, -55)
        :addTo(passPanel)
    scoreLab:setColor(cc.c3b(100, 100, 100))

    self.m_stars = stars
    self.m_scoreLab = scoreLab
    self.m_nextBtn = nextBtn
    self.m_passPanel = passPanel
end

function TipDlg:createPauseUI()
    local pausePanel = display.newNode()
            :addTo(self.m_root)
            :hide()

    local reStartBtn = ccui.Button:create("xiaoxiaole/xxl_play/btn_blue.png", "", "", ccui.TextureResType.plistType)
    pausePanel:addChild(reStartBtn)
    reStartBtn:setPosition(-120, -70)
    reStartBtn:setTitleFontSize(30)
    reStartBtn:setTitleText("重新开始")

    local exitBtn = ccui.Button:create("xiaoxiaole/xxl_play/btn_yellow.png", "", "", ccui.TextureResType.plistType)
    pausePanel:addChild(exitBtn)
    exitBtn:setPosition(120, -70)
    exitBtn:setTitleFontSize(30)
    exitBtn:setTitleText("退出游戏")

    local soundBtn = ccui.Button:create("xiaoxiaole/xxl_play/sound.png", "", "", ccui.TextureResType.plistType)
    pausePanel:addChild(soundBtn)
    soundBtn:setPosition(80, 50)

    soundBtn.spr = display.newSprite("xiaoxiaole/chacha.png")
            :addTo(soundBtn)
            :hide()

    local musicBtn = ccui.Button:create("xiaoxiaole/xxl_play/music.png", "", "", ccui.TextureResType.plistType)
    pausePanel:addChild(musicBtn)
    musicBtn:setPosition(-80, 50)

    musicBtn.spr = display.newSprite("xiaoxiaole/chacha.png")
            :addTo(musicBtn)
            :hide()

    utils.RegClickEvent(soundBtn, function()
        SOUNDFLAG = not SOUNDFLAG
        soundBtn.spr:setVisible(not SOUNDFLAG)
    end)

    utils.RegClickEvent(musicBtn, function()
        MUSICFLAG = not MUSICFLAG
        musicBtn.spr:setVisible(not MUSICFLAG)
    end)

    self.m_pausePanel = pausePanel
    self.m_reStartBtn = reStartBtn
    self.m_exitBtn = exitBtn

    self.m_soundBtn = soundBtn
    self.m_musicBtn = musicBtn
end

function TipDlg:setUI(param)
    local mode = param.mode or 0
    local parent = self:getParent()
    self.m_mode = mode

    self.m_fg:setVisible(mode == 1)
    
    self.m_failPanel:setVisible(mode == 3)
    self.m_passPanel:setVisible(mode == 2)
    self.m_pausePanel:setVisible(mode == 1)
 --   setimg(self.m_bg, (mode == 1) and "box_bg.png" or "dlg_bg.png")
    self.m_bg:setContentSize(cc.size(550, 420))
    self.m_tipLab:setPosition(0, (mode == 1) and 170 or 150)
            


    if mode == 1 then

        self.m_tipLab:setString("已暂停")
        utils.RegClickEvent(self.m_reStartBtn, function()
            parent:refreshCurGame()
            self:close()
        end)
        utils.RegClickEvent(self.m_exitBtn, function()
            self:close()
            ClsSceneManager.GetInstance():Turn2Scene("clsXiaoxiaoleStageScene")
        end)

        self.m_soundBtn.spr:setVisible(not SOUNDFLAG)
        self.m_musicBtn.spr:setVisible(not MUSICFLAG)

    elseif mode == 2 then
		self.m_tipLab:setString("Pass Success")
		self.m_scoreLab:setString("Score: " .. checknumber(parent.m_score))
		if g_curLevel == MAXSTAGE then
			self.m_nextBtn:setTitleText("RePlay")
		else
			self.m_nextBtn:setTitleText("Next Stage")
		end
		local scoreLevel = T_stages_info[g_curLevel].scoreLevel
		for i = 1, #self.m_stars do
			local star = self.m_stars[i]
			local img = parent.m_score > scoreLevel[i] and "xiaoxiaole/xxl_play/star_light.png" or "xiaoxiaole/xxl_play/star_dark.png"
			setimg(star, img)
		end
		utils.RegClickEvent(self.m_nextBtn, function()
			parent:refreshCurGame(true)
			self:close()
		end) 
	elseif mode == 3 then
		self.m_tipLab:setString("Sorry! Lossed!")
		utils.RegClickEvent(self.m_againBtn, function()
			parent:refreshCurGame()
			self:close()
		end) 
	end
end

function TipDlg:closeEvent()
	if self.m_mode and self.m_mode == 2 or self.m_mode == 3 then
		ClsSceneManager.GetInstance():Turn2Scene("clsXiaoxiaoleStageScene")
	end
end

function TipDlg:show(param)
	self:setUI(param)
	self:removeBgEvent(true)
	TipDlg.super.show(self)
end

function TipDlg:close()
	kAudioManager:playMusic("GameBGM", true)
	TipDlg.super.close(self)
end

return TipDlg