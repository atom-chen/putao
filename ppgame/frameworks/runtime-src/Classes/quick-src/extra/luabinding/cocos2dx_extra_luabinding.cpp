/*
** Lua binding: cocos2dx_extra_luabinding
** Generated automatically by tolua++-1.0.92 on Tue Jul 15 15:28:05 2014.
*/
#define USE_HTTPREQUEST_UPLOAD 0

#include "cocos2dx_extra_luabinding.h"
#include "CCLuaEngine.h"
#include "crypto/CCCrypto.h"
#if USE_HTTPREQUEST_UPLOAD
#include "network/CCHTTPRequest.h"
#include "network/CCHTTPRequestDelegate.h"
#endif

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
#if USE_HTTPREQUEST_UPLOAD
    tolua_usertype(tolua_S, "HTTPRequest");
#endif
}

//---------------------------------------------------------------------------------
#if USE_HTTPREQUEST_UPLOAD
static int tolua_cocos2dx_httprequest_luabinding_HTTPRequest_createWithUrl00(lua_State* tolua_S)
{
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S, 1, "HTTPRequest", 0, &tolua_err) ||
        (tolua_isvaluenil(tolua_S, 2, &tolua_err) || !toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err)) ||
        !tolua_isstring(tolua_S, 3, 0, &tolua_err) ||
        !tolua_isnumber(tolua_S, 4, 1, &tolua_err) ||
        !tolua_isnoobj(tolua_S, 5, &tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LUA_FUNCTION listener = (toluafix_ref_function(tolua_S, 2, 0));
        const char* url = ((const char*)tolua_tostring(tolua_S, 3, 0));
        int method = ((int)tolua_tonumber(tolua_S, 4, kCCHTTPRequestMethodGET));
        {
            HTTPRequest* cobj = (HTTPRequest*)HTTPRequest::createWithUrlLua(listener, url, method);
            int nID = (cobj) ? cobj->_ID : -1;
            int* pLuaID = (cobj) ? &cobj->_luaID : NULL;
            toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)cobj, "HTTPRequest");
        }
    }
    return 1;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S, "#ferror in function 'createWithUrl'.", &tolua_err);
    return 0;
#endif
}

static int tolua_cocos2dx_httprequest_luabinding_HTTPRequest_addRequestHeader00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S, 1, "HTTPRequest", 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
        !tolua_isnoobj(tolua_S, 3, &tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        HTTPRequest* self = (HTTPRequest*)tolua_tousertype(tolua_S, 1, 0);
        const char* header = ((const char*)tolua_tostring(tolua_S, 2, 0));
#ifndef TOLUA_RELEASE
        if (!self) tolua_error(tolua_S, "invalid 'self' in function 'addRequestHeader'", NULL);
#endif
        {
            self->addRequestHeader(header);
        }
    }
    return 0;
#ifndef TOLUA_RELEASE
    tolua_lerror :
    tolua_error(tolua_S, "#ferror in function 'addRequestHeader'.", &tolua_err);
    return 0;
#endif
}

static int tolua_cocos2dx_httprequest_luabinding_HTTPRequest_addFormFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S, 1, "HTTPRequest", 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 3, 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 4, 1, &tolua_err) ||
        !tolua_isnoobj(tolua_S, 5, &tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        HTTPRequest* self = (HTTPRequest*)tolua_tousertype(tolua_S, 1, 0);
        const char* name = ((const char*)tolua_tostring(tolua_S, 2, 0));
        const char* filePath = ((const char*)tolua_tostring(tolua_S, 3, 0));
        const char* fileType = ((const char*)tolua_tostring(tolua_S, 4, "application/octet-stream"));
#ifndef TOLUA_RELEASE
        if (!self) tolua_error(tolua_S, "invalid 'self' in function 'addFormFile'", NULL);
#endif
        {
            self->addFormFile(name, filePath, fileType);
        }
    }
    return 0;
#ifndef TOLUA_RELEASE
    tolua_lerror :
    tolua_error(tolua_S, "#ferror in function 'addFormFile'.", &tolua_err);
    return 0;
#endif
}

static int tolua_cocos2dx_httprequest_luabinding_HTTPRequest_addFormContents00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S, 1, "HTTPRequest", 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 3, 0, &tolua_err) ||
        !tolua_isnoobj(tolua_S, 4, &tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        HTTPRequest* self = (HTTPRequest*)tolua_tousertype(tolua_S, 1, 0);
        const char* name = ((const char*)tolua_tostring(tolua_S, 2, 0));
        const char* value = ((const char*)tolua_tostring(tolua_S, 3, 0));
#ifndef TOLUA_RELEASE
        if (!self) tolua_error(tolua_S, "invalid 'self' in function 'addFormContents'", NULL);
#endif
        {
            self->addFormContents(name, value);
        }
    }
    return 0;
#ifndef TOLUA_RELEASE
    tolua_lerror :
    tolua_error(tolua_S, "#ferror in function 'addFormContents'.", &tolua_err);
    return 0;
#endif
}

static int tolua_cocos2dx_httprequest_luabinding_HTTPRequest_start00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S, 1, "HTTPRequest", 0, &tolua_err) ||
        !tolua_isnoobj(tolua_S, 2, &tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        HTTPRequest* self = (HTTPRequest*)tolua_tousertype(tolua_S, 1, 0);
#ifndef TOLUA_RELEASE
        if (!self) tolua_error(tolua_S, "invalid 'self' in function 'start'", NULL);
#endif
        {
            bool tolua_ret = (bool)self->start();
            tolua_pushboolean(tolua_S, (bool)tolua_ret);
        }
    }
    return 1;
#ifndef TOLUA_RELEASE
    tolua_lerror :
    tolua_error(tolua_S, "#ferror in function 'start'.", &tolua_err);
    return 0;
#endif
}
#endif //USE_HTTPREQUEST_UPLOAD


//---------------------------------------------------------------------------------
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

//---------------------------------------------------------------------------------------------

/* Open function */
TOLUA_API int tolua_cocos2dx_extra_luabinding_open(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	tolua_reg_types(tolua_S);
	tolua_module(tolua_S, "cc", 0);
	tolua_beginmodule(tolua_S, "cc");
    // <Crypto>
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
	tolua_endmodule(tolua_S); //Crypto
#if USE_HTTPREQUEST_UPLOAD
    // <HttpRequest>
    tolua_constant(tolua_S, "kCCHTTPRequestMethodGET", kCCHTTPRequestMethodGET);
    tolua_constant(tolua_S, "kCCHTTPRequestMethodPOST", kCCHTTPRequestMethodPOST);
    tolua_constant(tolua_S, "kCCHTTPRequestAcceptEncodingIdentity", kCCHTTPRequestAcceptEncodingIdentity);
    tolua_constant(tolua_S, "kCCHTTPRequestAcceptEncodingGzip", kCCHTTPRequestAcceptEncodingGzip);
    tolua_constant(tolua_S, "kCCHTTPRequestAcceptEncodingDeflate", kCCHTTPRequestAcceptEncodingDeflate);
    tolua_constant(tolua_S, "kCCHTTPRequestStateIdle", kCCHTTPRequestStateIdle);
    tolua_constant(tolua_S, "kCCHTTPRequestStateCleared", kCCHTTPRequestStateCleared);
    tolua_constant(tolua_S, "kCCHTTPRequestStateInProgress", kCCHTTPRequestStateInProgress);
    tolua_constant(tolua_S, "kCCHTTPRequestStateCompleted", kCCHTTPRequestStateCompleted);
    tolua_constant(tolua_S, "kCCHTTPRequestStateCancelled", kCCHTTPRequestStateCancelled);
    tolua_constant(tolua_S, "kCCHTTPRequestStateFailed", kCCHTTPRequestStateFailed);
    tolua_cclass(tolua_S, "HTTPRequest", "HTTPRequest", "cc.Ref", NULL);
    tolua_beginmodule(tolua_S, "HTTPRequest");
    tolua_function(tolua_S,"createWithUrl",tolua_cocos2dx_httprequest_luabinding_HTTPRequest_createWithUrl00);
//    tolua_function(tolua_S, "setRequestUrl", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_setRequestUrl00);
//    tolua_function(tolua_S, "getRequestUrl", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getRequestUrl00);
    tolua_function(tolua_S, "addRequestHeader", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_addRequestHeader00);
//    tolua_function(tolua_S, "addPOSTValue", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_addPOSTValue00);
//    tolua_function(tolua_S, "setPOSTData", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_setPOSTData00);
    tolua_function(tolua_S, "addFormFile", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_addFormFile00);
    tolua_function(tolua_S, "addFormContents", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_addFormContents00);
//    tolua_function(tolua_S, "setCookieString", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_setCookieString00);
//    tolua_function(tolua_S, "getCookieString", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getCookieString00);
//    tolua_function(tolua_S, "setAcceptEncoding", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_setAcceptEncoding00);
//    tolua_function(tolua_S, "setTimeout", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_setTimeout00);
//    tolua_function(tolua_S, "start", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_start00);
//    tolua_function(tolua_S, "cancel", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_cancel00);
//    tolua_function(tolua_S, "getState", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getState00);
//    tolua_function(tolua_S, "getResponseStatusCode", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getResponseStatusCode00);
//    tolua_function(tolua_S, "getResponseHeadersString", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getResponseHeadersString00);
//    tolua_function(tolua_S, "getResponseString", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getResponseString00);
//    tolua_function(tolua_S, "getResponseData", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getResponseData00);
//    tolua_function(tolua_S, "getResponseDataLength", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getResponseDataLength00);
//    tolua_function(tolua_S, "saveResponseData", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_saveResponseData00);
//    tolua_function(tolua_S, "getErrorCode", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getErrorCode00);
//    tolua_function(tolua_S, "getErrorMessage", tolua_cocos2dx_httprequest_luabinding_HTTPRequest_getErrorMessage00);
    tolua_endmodule(tolua_S); // HttpRequest
#endif //USE_HTTPREQUEST_UPLOAD
	tolua_endmodule(tolua_S); // cc
	return 1;
}


TOLUA_API int luaopen_cocos2dx_extra_luabinding(lua_State* tolua_S) {
	return tolua_cocos2dx_extra_luabinding_open(tolua_S);
};

