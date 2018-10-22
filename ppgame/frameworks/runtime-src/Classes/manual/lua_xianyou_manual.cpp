/****************************************************************************
 Copyright (c) 2013-2016 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#include "manual/lua_xianyou_manual.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "tolua_fix.h"
#include "CCLuaStack.h"
#include "CCLuaValue.h"
#include "cocos2d.h"
#include "utils/Log.h"
#include "serialize/PacketHelper.h"
#include "utils/NetUtils.h"
#include "net/MessageDispatcher.h"


static int UTF16ToUTF8(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isstring(tolua_S, 1, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		size_t size = 0;
		char16_t *data = (char16_t*)lua_tolstring(tolua_S, 1, &size);
		if (data != NULL){

			//CSerialBuffer tmp((BYTE*)data, size);
			//log("%s:%s", __FUNCTION__, tmp.ToString(10).c_str());

			std::u16string str16 = std::u16string(data, size);
			std::string str8;
			StringUtils::UTF16ToUTF8(str16, str8);
			lua_pushlstring(tolua_S, (char*)str8.c_str(), str8.size());
			return 1;
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'UTF16ToUTF8'.", &tolua_err);
	return 0;
#endif

}
static int UTF8ToUTF16(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isstring(tolua_S, 1, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		size_t size = 0;
		char *data = (char*)lua_tolstring(tolua_S, 1, &size);
		if (data != NULL){
			std::string str8 = std::string(data, size);
			std::u16string str16;
			StringUtils::UTF8ToUTF16(str8, str16);
			lua_pushlstring(tolua_S, (char*)str16.c_str(), str16.length() * 2);
			return 1;
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'UTF8ToUTF16'.", &tolua_err);
	return 0;
#endif
}


#ifdef __cplusplus
static int tolua_collect_PacketHelper(lua_State* tolua_S)
{
	PacketHelper* self = (PacketHelper*)tolua_tousertype(tolua_S, 1, 0);
	Mtolua_delete(self);
	return 0;
}
#endif

#ifndef TOLUA_DISABLE_tolua_Cocos2d_PacketHelper_create00
static int tolua_Cocos2d_PacketHelper_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (!tolua_isusertable(tolua_S, 1, "cc.PacketHelper", 0, &tolua_err))
		goto tolua_lerror;
	else
#endif
	{
		PacketHelper* cobj = new PacketHelper();
		tolua_pushusertype(tolua_S, (void*)cobj, "cc.PacketHelper");
		tolua_register_gc(tolua_S, lua_gettop(tolua_S));
		return 1;
	}
	return 1;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'create'.", &tolua_err);
	return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

#ifndef TOLUA_DISABLE_tolua_Cocos2d_PacketHelper_encryptSendPacket00
static int tolua_Cocos2d_PacketHelper_encryptSendPacket00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isusertype(tolua_S, 1, "cc.PacketHelper", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		PacketHelper* self = (PacketHelper*)tolua_tousertype(tolua_S, 1, 0);
		int packetMaxSize = lua_tointeger(tolua_S, 2);
		size_t size = 0;
		const char* data = (const char*)lua_tolstring(tolua_S, 2, &size);
		if (data != NULL){
			CSerialBuffer packet((BYTE*)data, size);
			self->encryptSendPacket(packet);

			lua_pushlstring(tolua_S, (char*)packet.Buffer(), packet.Size());
			return 1;
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'encryptSendPacket'.", &tolua_err);
	return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: sendString of class WebSocket */
#ifndef TOLUA_DISABLE_tolua_Cocos2d_PacketHelper_pushRecvData00
static int tolua_Cocos2d_PacketHelper_pushRecvData00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isusertype(tolua_S, 1, "cc.PacketHelper", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		PacketHelper* self = (PacketHelper*)tolua_tousertype(tolua_S, 1, 0);
		size_t size = 0;
		const char* data = (const char*)lua_tolstring(tolua_S, 2, &size);
		if (NULL != data || size > 0){
			self->pushRecvData((BYTE*)data, size);
		}
		return 0;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'pushRecvData'.", &tolua_err);
	return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

#ifndef TOLUA_DISABLE_tolua_Cocos2d_PacketHelper_popRecvPaket00
static int tolua_Cocos2d_PacketHelper_popRecvPaket00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isusertype(tolua_S, 1, "cc.PacketHelper", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		PacketHelper* self = (PacketHelper*)tolua_tousertype(tolua_S, 1, 0);
		CSerialBuffer packet;
		if (self->popRecvPacket(packet)){
			lua_pushboolean(tolua_S, true);
			//log("%s:\n%s", __FUNCTION__, packet.ToString(10).c_str());
			lua_pushlstring(tolua_S, (char*)packet.Buffer(), packet.Size());
			return 2;
		}
		else{
			lua_pushboolean(tolua_S, false);
			return 1;
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'popRecvPaket'.", &tolua_err);
	return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE


TOLUA_API int tolua_packet_helper_open(lua_State* tolua_S){

	tolua_open(tolua_S);
	tolua_module(tolua_S, "cc", 0);
	tolua_beginmodule(tolua_S, "cc");
	tolua_usertype(tolua_S, "cc.PacketHelper");
	tolua_cclass(tolua_S, "PacketHelper", "cc.PacketHelper", "", tolua_collect_PacketHelper);
	tolua_beginmodule(tolua_S, "PacketHelper");
	tolua_function(tolua_S, "create", tolua_Cocos2d_PacketHelper_create00);
	tolua_function(tolua_S, "encryptSendPacket", tolua_Cocos2d_PacketHelper_encryptSendPacket00);
	tolua_function(tolua_S, "pushRecvData", tolua_Cocos2d_PacketHelper_pushRecvData00);
	tolua_function(tolua_S, "popRecvPaket", tolua_Cocos2d_PacketHelper_popRecvPaket00);
	tolua_endmodule(tolua_S);
	std::string typeName = typeid(PacketHelper).name();
	g_luaType[typeName] = "cc.PacketHelper";
	g_typeCast["PacketHelper"] = "cc.PacketHelper";
	tolua_endmodule(tolua_S);
	return 1;
}

TOLUA_API int register_packet_helper_manual(lua_State* tolua_S){

	lua_getglobal(tolua_S, "_G");
	if (lua_istable(tolua_S, -1))//stack:...,_G,
	{
		tolua_packet_helper_open(tolua_S);
	}
	lua_pop(tolua_S, 1);
	lua_register(tolua_S, "UTF16ToUTF8", UTF16ToUTF8);
	lua_register(tolua_S, "UTF8ToUTF16", UTF8ToUTF16);

	return 1;
}



static int tolua_Custom_XLog_start00(lua_State* tolua_S){
	XLog::getInstance()->start();
	return 0;
}

static int tolua_Custom_XLog_stop00(lua_State* tolua_S){
	XLog::getInstance()->stop();
	return 0;
}

static int tolua_Custom_XLog_writeLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (!tolua_isstring(tolua_S, 1, 0, &tolua_err) ||
		!tolua_isboolean(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		size_t size = 0;
		const char* data = (const char*)lua_tolstring(tolua_S, 1, &size);
		bool isPrint = lua_toboolean(tolua_S, 2);
		if (data != NULL){
			XLog::getInstance()->writeLog(data, isPrint);
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'writeLog'.", &tolua_err);
	return 0;
#endif
}

static int tolua_Custom_XLog_syncSaveFile00(lua_State* tolua_S)
{
	size_t size1 = 0;
	size_t size2 = 0;
	const char* fpath = (const char*)lua_tolstring(tolua_S, 1, &size1);
	const char* data = (const char*)lua_tolstring(tolua_S, 2, &size2);
	if (fpath != NULL && data != NULL) {
		XLog::getInstance()->syncSaveFile(fpath, data);
	}
	return 0;
}

static int tolua_Custom_XLog_pushLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (!tolua_isstring(tolua_S, 1, 0, &tolua_err) ||
		!tolua_isboolean(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isboolean(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 4, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		size_t size = 0;
		const char* data = (const char*)lua_tolstring(tolua_S, 1, &size);
		bool isPrint = lua_toboolean(tolua_S, 2);
		bool isWrite = lua_toboolean(tolua_S, 3);
		if (data != NULL){
			XLog::getInstance()->pushLog(data, isPrint, isWrite);
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'pushLog'.", &tolua_err);
	return 0;
#endif
}

TOLUA_API int register_Custom_XLog(lua_State* tolua_S){
	static const struct luaL_reg _reg[] = {
		{ "start", tolua_Custom_XLog_start00 },
		{ "stop", tolua_Custom_XLog_stop00 },
		{ "writeLog", tolua_Custom_XLog_writeLog00 },
		{ "pushLog", tolua_Custom_XLog_pushLog00 },
		{ "syncSaveFile", tolua_Custom_XLog_syncSaveFile00 },
		{ NULL, NULL }
	};
	luaL_register(tolua_S, "XLog", _reg);
	return 1;
}

int lua_xianyou_MessageDispatcher_sendMessageToServer00(lua_State* tolua_S)
{
	int argc = 0;
	xianyou::MessageDispatcher* cobj = nullptr;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertype(tolua_S, 1, "xianyou.MessageDispatcher", 0, &tolua_err)) goto tolua_lerror;
#endif

	cobj = (xianyou::MessageDispatcher*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
	if (!cobj)
	{
		tolua_error(tolua_S, "invalid 'cobj' in function 'lua_xianyou_MessageDispatcher_sendMessageToServer'", nullptr);
		return 0;
	}
#endif

	argc = lua_gettop(tolua_S) - 1;
	if (argc == 2)
	{
		int arg0;
		const char* arg1;

		ok &= luaval_to_int32(tolua_S, 2, (int *)&arg0, "xianyou.MessageDispatcher:sendMessageToServer");
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_xianyou_MessageDispatcher_sendMessageToServer'", nullptr);
			return 0;
		}

		size_t size = 0;
		arg1 = (const char*)lua_tolstring(tolua_S, 3, &size);
		if (NULL == arg1)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_xianyou_MessageDispatcher_sendMessageToServer'", nullptr);
			return 0;
		}

		cobj->sendMessageToServer(arg0, arg1);
		lua_settop(tolua_S, 1);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.MessageDispatcher:sendMessageToServer", argc, 2);
	return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'lua_xianyou_MessageDispatcher_sendMessageToServer00'.", &tolua_err);
#endif

	return 0;
}

int lua_xianyou_MessageDispatcher_registerScriptHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isusertype(tolua_S, 1, "xianyou.MessageDispatcher", 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 2, 0, &tolua_err) ||
		!toluafix_isfunction(tolua_S, 3, "LUA_FUNCTION", 0, &tolua_err))
	{
		goto tolua_lerror;
	}
	else
#endif
	{
		xianyou::MessageDispatcher* self = (xianyou::MessageDispatcher*)tolua_tousertype(tolua_S, 1, 0);
		if (NULL != self) {
			int type;
			luaval_to_int32(tolua_S, 2, (int *)&type);
			int handler = toluafix_ref_function(tolua_S, 3, 0);
			self->registerScriptHandler(type, handler);
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'lua_xianyou_MessageDispatcher_registerScriptHandler00'.", &tolua_err);
	return 0;
#endif
}

TOLUA_API int register_manual_MessageDispatcher(lua_State* L)
{
	lua_pushstring(L, "xianyou.MessageDispatcher");
	lua_rawget(L, LUA_REGISTRYINDEX);
	if (lua_istable(L, -1))
	{
		tolua_function(L, "sendMessageToServer", lua_xianyou_MessageDispatcher_sendMessageToServer00);
		tolua_function(L, "registerScriptHandler", lua_xianyou_MessageDispatcher_registerScriptHandler00);
	}
	lua_pop(L, 1);

	return 1;
}

