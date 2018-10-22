/*
** Lua binding: cocos2dx_extra_luabinding
** Generated automatically by tolua++-1.0.92 on Tue Jul 15 15:28:05 2014.
*/

#include "cocos2dx_extra_luabinding.h"
#include "CCLuaEngine.h"
#include "crypto/CCCrypto.h"
#include "native/CCNative.h"

using namespace std;
using namespace cocos2d;
using namespace cocos2d::extra;

/* function to release collected object via destructor */
#ifdef __cplusplus


#endif


/* function to register type */
static void tolua_reg_types(lua_State* tolua_S)
{
	tolua_usertype(tolua_S, "cc.Ref");
	tolua_usertype(tolua_S, "Crypto");
	tolua_usertype(tolua_S, "Native");
}

//---------------------------------------------------------------------------------
/* method: getAES256KeyLength of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_getAES256KeyLength00
static int tolua_cocos2dx_extra_luabinding_Crypto_getAES256KeyLength00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		{
			int tolua_ret = (int)Crypto::getAES256KeyLength();
			tolua_pushnumber(tolua_S, (lua_Number)tolua_ret);
		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'getAES256KeyLength'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: encryptAES256Lua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_encryptAES25600
static int tolua_cocos2dx_extra_luabinding_Crypto_encryptAES25600(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 4, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 5, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 6, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* plaintext = ((const char*)tolua_tostring(tolua_S, 2, 0));
		int plaintextLength = ((int)tolua_tonumber(tolua_S, 3, 0));
		const char* key = ((const char*)tolua_tostring(tolua_S, 4, 0));
		int keyLength = ((int)tolua_tonumber(tolua_S, 5, 0));
		{
			Crypto::encryptAES256Lua(plaintext, plaintextLength, key, keyLength);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'encryptAES256'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: decryptAES256Lua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_decryptAES25600
static int tolua_cocos2dx_extra_luabinding_Crypto_decryptAES25600(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 4, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 5, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 6, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* ciphertext = ((const char*)tolua_tostring(tolua_S, 2, 0));
		int ciphertextLength = ((int)tolua_tonumber(tolua_S, 3, 0));
		const char* key = ((const char*)tolua_tostring(tolua_S, 4, 0));
		int keyLength = ((int)tolua_tonumber(tolua_S, 5, 0));
		{
			Crypto::decryptAES256Lua(ciphertext, ciphertextLength, key, keyLength);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'decryptAES256'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: encryptXXTEALua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_encryptXXTEA00
static int tolua_cocos2dx_extra_luabinding_Crypto_encryptXXTEA00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 4, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 5, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 6, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* plaintext = ((const char*)tolua_tostring(tolua_S, 2, 0));
		int plaintextLength = ((int)tolua_tonumber(tolua_S, 3, 0));
		const char* key = ((const char*)tolua_tostring(tolua_S, 4, 0));
		int keyLength = ((int)tolua_tonumber(tolua_S, 5, 0));
		{
			Crypto::encryptXXTEALua(plaintext, plaintextLength, key, keyLength);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'encryptXXTEA'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: decryptXXTEALua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_decryptXXTEA00
static int tolua_cocos2dx_extra_luabinding_Crypto_decryptXXTEA00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 4, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 5, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 6, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* ciphertext = ((const char*)tolua_tostring(tolua_S, 2, 0));
		int ciphertextLength = ((int)tolua_tonumber(tolua_S, 3, 0));
		const char* key = ((const char*)tolua_tostring(tolua_S, 4, 0));
		int keyLength = ((int)tolua_tonumber(tolua_S, 5, 0));
		{
			Crypto::decryptXXTEALua(ciphertext, ciphertextLength, key, keyLength);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'decryptXXTEA'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: encodeBase64Lua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_encodeBase6400
static int tolua_cocos2dx_extra_luabinding_Crypto_encodeBase6400(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 4, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* input = ((const char*)tolua_tostring(tolua_S, 2, 0));
		int inputLength = ((int)tolua_tonumber(tolua_S, 3, 0));
		{
			Crypto::encodeBase64Lua(input, inputLength);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'encodeBase64'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: decodeBase64Lua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_decodeBase6400
static int tolua_cocos2dx_extra_luabinding_Crypto_decodeBase6400(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* input = ((const char*)tolua_tostring(tolua_S, 2, 0));
		{
			Crypto::decodeBase64Lua(input);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'decodeBase64'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: MD5Lua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_MD500
static int tolua_cocos2dx_extra_luabinding_Crypto_MD500(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isboolean(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 4, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		char* input = ((char*)tolua_tostring(tolua_S, 2, 0));
		bool isRawOutput = ((bool)tolua_toboolean(tolua_S, 3, 0));
		{
			Crypto::MD5Lua(input, isRawOutput);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'MD5'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: MD5FileLua of class  Crypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Crypto_MD5File00
static int tolua_cocos2dx_extra_luabinding_Crypto_MD5File00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Crypto", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* path = ((const char*)tolua_tostring(tolua_S, 2, 0));
		{
			Crypto::MD5FileLua(path);

		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'MD5File'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: showActivityIndicator of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_showActivityIndicator00
static int tolua_cocos2dx_extra_luabinding_Native_showActivityIndicator00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		{
			Native::showActivityIndicator();
		}
	}
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'showActivityIndicator'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: hideActivityIndicator of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_hideActivityIndicator00
static int tolua_cocos2dx_extra_luabinding_Native_hideActivityIndicator00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		{
			Native::hideActivityIndicator();
		}
	}
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'hideActivityIndicator'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createAlert of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_createAlert00
static int tolua_cocos2dx_extra_luabinding_Native_createAlert00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 4, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 5, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* title = ((const char*)tolua_tostring(tolua_S, 2, 0));
		const char* message = ((const char*)tolua_tostring(tolua_S, 3, 0));
		const char* cancelButtonTitle = ((const char*)tolua_tostring(tolua_S, 4, 0));
		{
			Native::createAlert(title, message, cancelButtonTitle);
		}
	}
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'createAlert'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addAlertButton of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_addAlertButton00
static int tolua_cocos2dx_extra_luabinding_Native_addAlertButton00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* buttonTitle = ((const char*)tolua_tostring(tolua_S, 2, 0));
		{
			int tolua_ret = (int)Native::addAlertButton(buttonTitle);
			tolua_pushnumber(tolua_S, (lua_Number)tolua_ret);
		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'addAlertButton'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: showAlertLua of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_showAlert00
static int tolua_cocos2dx_extra_luabinding_Native_showAlert00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		(tolua_isvaluenil(tolua_S, 2, &tolua_err) || !toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err)) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		LUA_FUNCTION listener = (toluafix_ref_function(tolua_S, 2, 0));
		{
			Native::showAlertLua(listener);
		}
	}
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'showAlert'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: cancelAlert of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_cancelAlert00
static int tolua_cocos2dx_extra_luabinding_Native_cancelAlert00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		{
			Native::cancelAlert();
		}
	}
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'cancelAlert'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getOpenUDID of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_getOpenUDID00
static int tolua_cocos2dx_extra_luabinding_Native_getOpenUDID00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		{
			string tolua_ret = (string)Native::getOpenUDID();
			tolua_pushcppstring(tolua_S, (const char*)tolua_ret);
		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'getOpenUDID'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: openURL of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_openURL00
static int tolua_cocos2dx_extra_luabinding_Native_openURL00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* url = ((const char*)tolua_tostring(tolua_S, 2, 0));
		{
			Native::openURL(url);
		}
	}
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'openURL'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInputText of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_getInputText00
static int tolua_cocos2dx_extra_luabinding_Native_getInputText00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 4, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 5, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		const char* title = ((const char*)tolua_tostring(tolua_S, 2, 0));
		const char* message = ((const char*)tolua_tostring(tolua_S, 3, 0));
		const char* defaultValue = ((const char*)tolua_tostring(tolua_S, 4, 0));
		{
			string tolua_ret = (string)Native::getInputText(title, message, defaultValue);
			tolua_pushcppstring(tolua_S, (const char*)tolua_ret);
		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'getInputText'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getDeviceName of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_getDeviceName00
static int tolua_cocos2dx_extra_luabinding_Native_getDeviceName00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		{
			const string tolua_ret = (const string)Native::getDeviceName();
			tolua_pushcppstring(tolua_S, (const char*)tolua_ret);
		}
	}
	return 1;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'getDeviceName'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: vibrate of class  Native */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_Native_vibrate00
static int tolua_cocos2dx_extra_luabinding_Native_vibrate00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
	if (
		!tolua_isusertable(tolua_S, 1, "Native", 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		{
			Native::vibrate();
		}
	}
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'vibrate'.", &tolua_err);
				return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE



/* Open function */
TOLUA_API int tolua_cocos2dx_extra_luabinding_open(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	tolua_reg_types(tolua_S);
	tolua_module(tolua_S, "cc", 0);
	tolua_beginmodule(tolua_S, "cc");
	tolua_cclass(tolua_S, "Crypto", "Crypto", "", NULL);
	tolua_beginmodule(tolua_S, "Crypto");
	//tolua_function(tolua_S,"getAES256KeyLength",tolua_cocos2dx_extra_luabinding_Crypto_getAES256KeyLength00);
	//tolua_function(tolua_S,"encryptAES256",tolua_cocos2dx_extra_luabinding_Crypto_encryptAES25600);
	//tolua_function(tolua_S,"decryptAES256",tolua_cocos2dx_extra_luabinding_Crypto_decryptAES25600);
	tolua_function(tolua_S, "encryptXXTEA", tolua_cocos2dx_extra_luabinding_Crypto_encryptXXTEA00);
	tolua_function(tolua_S, "decryptXXTEA", tolua_cocos2dx_extra_luabinding_Crypto_decryptXXTEA00);
	tolua_function(tolua_S, "encodeBase64", tolua_cocos2dx_extra_luabinding_Crypto_encodeBase6400);
	tolua_function(tolua_S, "decodeBase64", tolua_cocos2dx_extra_luabinding_Crypto_decodeBase6400);
	tolua_function(tolua_S, "MD5", tolua_cocos2dx_extra_luabinding_Crypto_MD500);
	tolua_function(tolua_S, "MD5File", tolua_cocos2dx_extra_luabinding_Crypto_MD5File00);
	tolua_endmodule(tolua_S);
	tolua_cclass(tolua_S, "Native", "Native", "", NULL);
	tolua_beginmodule(tolua_S, "Native");
	//tolua_function(tolua_S,"showActivityIndicator",tolua_cocos2dx_extra_luabinding_Native_showActivityIndicator00);
	//tolua_function(tolua_S,"hideActivityIndicator",tolua_cocos2dx_extra_luabinding_Native_hideActivityIndicator00);
	//tolua_function(tolua_S,"createAlert",tolua_cocos2dx_extra_luabinding_Native_createAlert00);
	//tolua_function(tolua_S,"addAlertButton",tolua_cocos2dx_extra_luabinding_Native_addAlertButton00);
	//tolua_function(tolua_S,"showAlert",tolua_cocos2dx_extra_luabinding_Native_showAlert00);
	//tolua_function(tolua_S,"cancelAlert",tolua_cocos2dx_extra_luabinding_Native_cancelAlert00);
	//tolua_function(tolua_S,"getOpenUDID",tolua_cocos2dx_extra_luabinding_Native_getOpenUDID00);
	//tolua_function(tolua_S,"openURL",tolua_cocos2dx_extra_luabinding_Native_openURL00);
	//tolua_function(tolua_S,"getInputText",tolua_cocos2dx_extra_luabinding_Native_getInputText00);
	//tolua_function(tolua_S,"getDeviceName",tolua_cocos2dx_extra_luabinding_Native_getDeviceName00);
	//tolua_function(tolua_S,"vibrate",tolua_cocos2dx_extra_luabinding_Native_vibrate00);
	tolua_endmodule(tolua_S);
	tolua_endmodule(tolua_S);
	return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
TOLUA_API int luaopen_cocos2dx_extra_luabinding(lua_State* tolua_S) {
	return tolua_cocos2dx_extra_luabinding_open(tolua_S);
};
#endif

