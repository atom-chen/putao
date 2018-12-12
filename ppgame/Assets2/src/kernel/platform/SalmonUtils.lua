-------------------------------
-- 工具接口，具体实现请看对应文件夹
-------------------------------
local luaj = {}
local luaoc = {}
if device.platform == "android" then
	luaj = require("cocos.cocos2d.luaj")
elseif device.platform == "ios" or device.platform == "mac" then
	luaoc = require("cocos.cocos2d.luaoc")
end

local className = "ppasist.utils.SalmonUtils"
if device.platform == "ios" then
	className = "SalmonUtils"
end


SalmonUtils = {}

-- 获取手机型号
function SalmonUtils:getPhoneType()
	if device.platform == "android" then
		
	elseif device.platform == "ios" then
		
	elseif device.platform == "mac" then
		
	elseif device.platform == "windows" then
		
	end
	return ""
end

-- 打开其他APP
function SalmonUtils:openAnotherApp(packname, appname)
	if device.platform == "android" then
		local ok,ret = luaj.callStaticMethod(className, "openAnotherApp", {packname, appname}, "(Ljava/lang/String;Ljava/lang/String;)V")
	elseif device.platform == "ios" then
		print("当前平台不支持")
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
end

-- ios的url含中文时需要转化
function SalmonUtils:fixUrl2utf8(url)
    if device.platform == "android" then
		return url
	elseif device.platform == "ios" then
		if not url or url == "" then return "" end
	    local ok,ret = luaoc.callStaticMethod(className, "fixUrl2utf8", { urlStr = url })
	    if not ok then
	        return url
	    else
	    	if not ret or type(ret) ~= "string" then return url end
	    	local s1 = string.find(ret or "", "http")
	    	if not s1 then return url end
	        return ret
	    end
	elseif device.platform == "mac" then
		return url
	elseif device.platform == "windows" then
		return url
	end
	return url
end

-- 检查相机权限
function SalmonUtils:CheckCamera()
	if device.platform == "android" then
		luaj.callStaticMethod(className, "CheckCamera", { }, "()Z")
	end
end

-- 保存相片到相册
function SalmonUtils:saveImageToPhotos(handler, captureName)
    if device.platform == "android" then
	    local ok,ret  = luaj.callStaticMethod(className,"saveImageToPhotos",{captureName, handler},"(Ljava/lang/String;I)V")
	elseif device.platform == "ios" then
	    local ok,ret  = luaoc.callStaticMethod(className,"saveImageToPhotos",{scriptHandler = handler, imageName = captureName})
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
end

-- 打开图库选取一张图
function SalmonUtils:openGallery(handler, captureName)
	if device.platform == "android" then
		if not captureName then
	        captureName = "image.jpg"
	    end
	
	    local function getImgCb(imgpath)
	        if handler and imgpath then
	            local suffix = imgpath:match(".+%.(%w+)$")
	            if suffix == "gif" then
	                handler(nil)
	                return
	            end
	            handler(imgpath)
	        end
	    end
	
	    local ok,ret  = luaj.callStaticMethod(className,"openGallery",{captureName, getImgCb},"(Ljava/lang/String;I)V")
	elseif device.platform == "ios" then
		if not captureName then
	        captureName = "/image.png"
	    end
	    captureName = "/"..captureName
	
	    local function callback(imgpath)
	        if handler then
	            handler(imgpath)
	        end
	    end
	    local ok,ret  = luaoc.callStaticMethod(className,"openGallery",{scriptHandler = callback, imageName = captureName})
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
end

-- 拍照
function SalmonUtils:captureImage(captureName, handler)
	if device.platform == "android" then
	    local ok,ret  = luaj.callStaticMethod(className,"captureImage",{captureName, handler},"(Ljava/lang/String;I)V")
	elseif device.platform == "ios" then
		if not captureName then
	        captureName = "/image.png"
	    end
	    captureName = "/"..captureName
	
	    local function callback( imgpath )
	        if handler then
	            handler(imgpath)
	        end
	    end
	
	    local ok,ret  = luaoc.callStaticMethod(className,"captureImage",{scriptHandler = callback, imageName = captureName})
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
end

-- 复制字符
function SalmonUtils:copy(content)
	if device.platform == "android" then
	    local ok,ret = luaj.callStaticMethod(className,"copy",{content},"(Ljava/lang/String;)V")
	    if ok then
	        KE_SetTimeout(1, function() utils.TellMe("复制成功") end)
	    end
	elseif device.platform == "ios" then
	    local ok,ret = luaoc.callStaticMethod(className,"copy", {content = content})
	    if ok then
	        KE_SetTimeout(1, function() utils.TellMe("复制成功") end)
	    end
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
end

-- 黏贴
function SalmonUtils:paste()
	if device.platform == "android" then
	    local ok,ret  = luaj.callStaticMethod(className,"paste",{},"()Ljava/lang/String;")
	elseif device.platform == "ios" then
		local ok,ret  = luaoc.callStaticMethod(className,"paste")
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
end
