----------------------------
-- 音频
----------------------------
module("xiaoxiaole", package.seeall)

local AUDIO_MAP = {
	begain = "sound/sound.create.color.mp3",
	wrap = "sound/sound.create.wrap.mp3",
	drop = "sound/sound.Drop.mp3",
}

local MUSIC_MAP = {
	GameBGM = "sound/sound.GameBGM.mp3",
	WorldBGM = "sound/sound.WorldBGM.mp3",
};


local MMM = class("MMM")

function MMM.getInstance()
	if not MMM.s_instance then 
		MMM.s_instance = MMM.new();
    end
	return MMM.s_instance;
end

function MMM.releaseInstance()
	MMM.s_instance = nil;
end

function MMM:ctor()
	self.m_curMusic = 0;
end

function MMM:playMusic(bg_type,isLoop)
	if not MUSICFLAG then
		return
	end
	
	if not MUSIC_MAP[bg_type] then 
		print("No such bg_type " .. tostring (bg_type));
		return ;
	end 
	
	if self.m_curMusic ~= bg_type then
		self:stopMusic(false);
    else
        return;
	end
	audio.playMusic(MUSIC_MAP[bg_type], isLoop);
	self.m_curMusic = bg_type;
end

function MMM:stopMusic(isReleaseData)
	if audio.isMusicPlaying() then
		audio.stopMusic(isReleaseData)
	end
    self.m_curMusic = 0;
end

function MMM:pauseAllSounds()
	audio.pauseAllEffects();
end

function MMM:resumeAllSounds()
	audio.resumeAllSounds();
end

function MMM:isPlaingMusic()
	return audio.isMusicPlaying();
end

function MMM:playSound(audioType, bLoop)
	if not SOUNDFLAG then
		return
	end
	bLoop = bLoop or false;
	
	if AUDIO_MAP[audioType] then 
		local audioHandle = audio.playSound(AUDIO_MAP[audioType], bLoop);
		return audioHandle;
	end
	
	print ("No such audioType " .. tostring (audioType));

end

function MMM:stopSound(audioHandle)
    audio.stopSound(audioHandle);
end

function MMM:stopAllSound()
	audio.stopAllSounds()
end

function MMM:setSoundVolume(volume)
	audio.setSoundsVolume(volume)
end

function MMM:getSoundVolume()
	return audio.getSoundsVolume();
end

function MMM:setMusicVolume(volume)
	audio.setMusicVolume(volume)
end

function MMM:getMusicVolume()
	return audio.getMusicVolume();
end



kAudioManager = MMM.getInstance();
return MMM