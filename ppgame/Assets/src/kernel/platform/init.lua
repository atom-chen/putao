if device.platform == "android" then
	luaj = require("cocos.cocos2d.luaj")
elseif device.platform == "ios" or device.platform == "mac" then
	luaoc = require("cocos.cocos2d.luaoc")
end

require("kernel.platform.SalmonUtils")
require("kernel.platform.PlatformHelper")
require("kernel.platform.KeyBoard")
