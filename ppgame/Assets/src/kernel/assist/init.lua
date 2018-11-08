require "kernel.assist.guide.init" 
require "kernel.assist.group.init" 
require "kernel.assist.physics.init"
require "kernel.assist.team.init"
if GAME_CONFIG.ENABLE_AI_MODULE then
require "kernel.assist.ai.init" 
end
if GAME_CONFIG.ENABLE_ACTREE_MODULE then
require "kernel.assist.actree.init" 
end
