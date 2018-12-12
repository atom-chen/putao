---------------------------------------
-- 平台相关接口
---------------------------------------
local luaj = {}
local luaoc = {}
if device.platform == "android" then
	luaj = require("cocos.cocos2d.luaj")
elseif device.platform == "ios" or device.platform == "mac" then
	luaoc = require("cocos.cocos2d.luaoc")
end

local className = "org.cocos2dx.lua.AppActivity"
if device.platform == "ios" then
	className = "AppController"
end

local socket = require("socket")

local function GetAdd(hostname)
	local ip, resolved = socket.dns.toip(hostname)
	local ListTab = {}
	if resolved and resolved.ip then
		for k, v in ipairs(resolved.ip) do
			table.insert(ListTab, v)
		end
	end
	return ListTab
end


PlatformHelper = {}

-- 获取IP地址
function PlatformHelper:GetIpAddress()
	local ipAddr = unpack(GetAdd(socket.dns.gethostname()))
	return ipAddr
end

-- 在浏览器中打开url
function PlatformHelper.openURL(url)
	if not url or url == "" then
		return
	end
	cc.Application:getInstance():openURL(url)
end

-- 关闭键盘
function PlatformHelper.closeSystemKeyboard(edtbox)
	if device.platform == "android" then
		luaj.callStaticMethod(className, "closeSystemKeyboard", { }, "()V")
	else 
		if utils.IsValidCCObject(edtbox) then
			edtbox:setVisible(false)
			edtbox:setVisible(true)
		end
	end
end

-- 获取虚拟键盘高度
function PlatformHelper.getKeyboardHei()
	if device.platform == "android" then
		local ok,ret  = luaj.callStaticMethod(className, "getKeyboardHei" , {}, "()I")
	    if ok then
	        return ret
	    else
	        return 0
	    end
	elseif device.platform == "ios" then
	    local ok,ret  = luaoc.callStaticMethod(className,"getKeyboardHei",{})
	    if ok then
	        return ret
	    else
	        return 0
	    end
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
	return 0
end

--
function PlatformHelper.getAdjustHei()
	if device.platform == "android" then
		print("当前平台不支持")
	elseif device.platform == "ios" then
		local ok,ret  = luaoc.callStaticMethod(className,"getAdjustHei",{})
	    if ok then
	        return ret
	    else
	        return 0
	    end
	elseif device.platform == "mac" then
		print("当前平台不支持")
	elseif device.platform == "windows" then
		print("当前平台不支持")
	end
	return 0
end

-- 获取引擎版本
function PlatformHelper.getVersion()
	if device.platform == "android" then
		local ok, ret = luaj.callStaticMethod(className, "getVersion", { }, "()Ljava/lang/String;")
		if ok then
			return "V" .. ret
		else
			return "V1.0.0"
		end
	elseif device.platform == "ios" then
		local ok, ret = luaoc.callStaticMethod(className, "getVersion", { })
		if ok then
			return "V" .. ret
		else
			return "V1.0.0"
		end
	elseif device.platform == "mac" then
		return "V1.5.0"
	elseif device.platform == "windows" then
		return "V1.5.0"
	end
end

-- 是否安装了微信
function PlatformHelper.isInstallWX()
    if device.platform == "android" then
        if true then
            return 1
        end
        local ok, ret = luaj.callStaticMethod(className, "isInstallWX", { }, "()I")
        if ok then
            return ret
        else
            return false
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(className, "isInstallWX", { })
        if ok then
            return ret
        else
            return false
        end
    elseif device.platform == "mac" then
        return false
    elseif device.platform == "windows" then
        return false
    end
end

-- 开始监听网络状态和电池状态
function PlatformHelper.onGameLauch()
    if device.platform == "android" then
        local ok, ret = luaj.callStaticMethod(className, "onGameLauch", { }, "()V")
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(className, "onGameLauch", { })
    elseif device.platform == "windows" then

    else

    end
end

-- 系统网络是否打开
function PlatformHelper.isNetworkConnected()
    if device.platform == "android" then
        local ok, ret = luaj.callStaticMethod(className, "isNetworkConnected", { }, "()Z")
        return ret
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(className, "isNetworkConnected", { })
        return ret == 1 and true or false
    elseif device.platform == "windows" then

    else

    end
    return true
end

-- 获取设备ID
function PlatformHelper.getDeviceId()
    if device.platform == "android" then
        local ok, ret = utils.callJavaFunc(className, "getDeviceId", { }, "()Ljava/lang/String;")
        if ok then
            return ret;
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(className, "getDeviceId", { })
        if ok then
            return ret;
        end
    end
    return ""
end 

-- 获取手机机型
function PlatformHelper.getModel()
    if device.platform == "android" then
        local ok, ret = utils.callJavaFunc(className, "getModel", { }, "()Ljava/lang/String;")
        if ok then
            return ret;
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(className, "getModel", { })
        if ok then
            return ret;
        end
    end
    return ""
end 

-- 获取剩余电量
function PlatformHelper.getBattery()
    if device.platform == "android" then
        local ok, ret = utils.callJavaFunc(className, "getBattery", { }, "()I")
        if ok then
            return g_battery;
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(className, "getBattery", { })
        if ok then
            return ret;
        end
    end
    return 100
end

---------------------------------------------------

-- OkHttp GET
function PlatformHelper.httpGet(url, succCallback, failCallback, loadingCallback)
	if device.platform == "android" then
		local ok, ret = utils.callJavaFunc("ppasist.utils.HttpLua", "httpGet", { url, succCallback, failCallback, loadingCallback }, "(Ljava/lang/String;III)V")
	end
end

-- OkHttp POST
function PlatformHelper.httpPost(url, cont, succCallback, failCallback, loadingCallback)
	if device.platform == "android" then
		local ok, ret = utils.callJavaFunc("ppasist.utils.HttpLua", "httpPost", { url, cont, succCallback, failCallback, loadingCallback }, "(Ljava/lang/String;Ljava/lang/String;III)V")
	end
end

-- OkHttp HEAD
function PlatformHelper.setHeader(key, value)
	if device.platform == "android" then 
		local ok, ret = utils.callJavaFunc("ppasist.utils.HttpLua", "setHeader", {key, value}, "(Ljava/lang/String;Ljava/lang/String;)V")
	end
	PlatformHelper.addHeader("FROMWAY", const.FROMWAY)
end

-- OkHttp HEAD
function PlatformHelper.addHeader(key, value)
	if device.platform == "android" then 
		local ok, ret = utils.callJavaFunc("ppasist.utils.HttpLua", "addHeader", {key, value}, "(Ljava/lang/String;Ljava/lang/String;)V")
	end
end
