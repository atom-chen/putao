#include "int64.h"

#include <stdint.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>
#include "NetUtils.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

static int64_t int64(lua_State *L, int index){
	int type = lua_type(L, index);
	int64_t n = 0;
	switch (type) {
	case LUA_TNUMBER: {
		lua_Number d = lua_tonumber(L, index);
		n = (int64_t)d;
		break;
	}
	case LUA_TSTRING: {
		size_t len = 0;
		const uint8_t * str = (const uint8_t *)lua_tolstring(L, index, &len);
		if (len>8) {
			return luaL_error(L, "The string (length = %d) is not an int64 string", len);
		}
		int i = 0;
		uint64_t n64 = 0;
		for (i = 0; i<(int)len; i++) {
			n64 |= (uint64_t)str[i] << (i * 8);
		}
		n = (int64_t)n64;
		break;
	}
	case LUA_TUSERDATA:{
		Int64* cobj = (Int64*)tolua_tousertype(L, index, 0);
		n = cobj->getValue();
		break;
	}
	default:
		return luaL_error(L, "argument %d error type %s", index, lua_typename(L, type));
	}
	return n;
}

static inline void
_pushint64(lua_State *L, int64_t n) {
	void * p = (void *)n;
	lua_pushlightuserdata(L, p);
}

static int
int64_add(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() + cobj2->getValue());
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() + num);
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_add'.", &tolua_err);
	return 0;
#endif
}

static int
int64_self_add(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			cobj1->setValue(cobj1->getValue() + cobj2->getValue());
			tolua_pushusertype(L, (void*)cobj1, "cc.Int64");
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			cobj1->setValue(cobj1->getValue() + num);
			tolua_pushusertype(L, (void*)cobj1, "cc.Int64");
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_self_add'.", &tolua_err);
	return 0;
#endif
}

static int
int64_sub(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() - cobj2->getValue());
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() - num);
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_sub'.", &tolua_err);
	return 0;
#endif
}

static int
int64_self_sub(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			cobj1->setValue(cobj1->getValue() - cobj2->getValue());
			tolua_pushusertype(L, (void*)cobj1, "cc.Int64");
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			cobj1->setValue(cobj1->getValue() - num);
			tolua_pushusertype(L, (void*)cobj1, "cc.Int64");
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_self_sub'.", &tolua_err);
	return 0;
#endif
}

static int
int64_mul(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() * cobj2->getValue());
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() * num);
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_mul'.", &tolua_err);
	return 0;
#endif
}

static int
int64_self_mul(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			cobj1->setValue(cobj1->getValue() * cobj2->getValue());
			tolua_pushusertype(L, (void*)cobj1, "cc.Int64");
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			cobj1->setValue(cobj1->getValue() * num);
			tolua_pushusertype(L, (void*)cobj1, "cc.Int64");
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_self_mul'.", &tolua_err);
	return 0;
#endif
}

static int
int64_div(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() / cobj2->getValue());
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() / num);
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}

		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_div'.", &tolua_err);
	return 0;
#endif
}

static int
int64_mod(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() % cobj2->getValue());
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			Int64* cobj = new Int64();
			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
			cobj->setValue(cobj1->getValue() % (int64_t)num);
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}

		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_mod'.", &tolua_err);
	return 0;
#endif
}

static int64_t
_pow64(int64_t a, int64_t b) {
	if (b == 1) {
		return a;
	}
	int64_t a2 = a * a;
	if (b % 2 == 1) {
		return _pow64(a2, b / 2) * a;
	}
	else {
		return _pow64(a2, b / 2);
	}
}

static int
int64_pow(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{

		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		if (lua_isuserdata(L, 2)){
			Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
			Int64* cobj = new Int64();

			int64_t a = cobj1->getValue();
			int64_t b = cobj2->getValue();
			int64_t p;
			if (b > 0) {
				p = _pow64(a, b);
			}
			else if (b == 0) {
				p = 1;
			}
			else {
				return luaL_error(L, "pow by nagtive number %d", (int)b);
			}
			cobj->setValue(p);

			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
		}
		else if (lua_isnumber(L, 2)){
			lua_Number num = tolua_tonumber(L, 2, 0);
			Int64* cobj = new Int64();

			int64_t a = cobj1->getValue();
			int64_t b = num;
			int64_t p;
			if (b > 0) {
				p = _pow64(a, b);
			}
			else if (b == 0) {
				p = 1;
			}
			else {
				return luaL_error(L, "pow by nagtive number %d", (int)b);
			}
			cobj->setValue(p);

			tolua_pushusertype(L, (void*)cobj, "cc.Int64");
			tolua_register_gc(L, lua_gettop(L));
		}
		else{
			if (
				!tolua_isuserdata(L, 2, 0, &tolua_err) ||
				!tolua_isnumber(L, 2, 0, &tolua_err)
				)
				goto tolua_lerror;

		}
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_pow'.", &tolua_err);
	return 0;
#endif
}

static int
int64_unm(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err) ||
		!tolua_isnoobj(L, 2, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj = (Int64*)tolua_tousertype(L, 1, 0);

		tolua_pushusertype(L, (void*)cobj, "cc.Int64");
		tolua_register_gc(L, lua_gettop(L));

		cobj->setValue(-cobj->getValue());

		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_unm'.", &tolua_err);
	return 0;
#endif
}

static int
int64_new(lua_State *L) {

#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	/*if (!tolua_isusertable(L, 1, "cc.Int64", 0, &tolua_err))
	goto tolua_lerror;
	else*/
#endif
	{
		Int64* cobj = new Int64();

		int top = lua_gettop(L);
		int64_t n;
		switch (top) {
		case 0:
			cobj->setValue(0);
			break;
		case 1:
			n = int64(L, 1);
			cobj->setValue(n);
			break;
		case 2: {
			int base = luaL_checkinteger(L, 2);
			if (base < 2) {
				luaL_error(L, "base must be >= 2");
			}
			const char * str = luaL_checkstring(L, 1);
			n = strtoll(str, NULL, base);
			cobj->setValue(n);
			break;
		}
		}
		tolua_pushusertype(L, (void*)cobj, "cc.Int64");
		tolua_register_gc(L, lua_gettop(L));
		return 1;
	}
	return 1;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'create'.", &tolua_err);
	return 0;
#endif
}

static int
int64_eq(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err) ||
		!tolua_isuserdata(L, 2, 0, &tolua_err) ||
		!tolua_isnoobj(L, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
		lua_pushboolean(L, cobj1->getValue() == cobj2->getValue());
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_eq'.", &tolua_err);
	return 0;
#endif
}

static int
int64_lt(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err) ||
		!tolua_isuserdata(L, 2, 0, &tolua_err) ||
		!tolua_isnoobj(L, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
		lua_pushboolean(L, cobj1->getValue() < cobj2->getValue());
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_lt'.", &tolua_err);
	return 0;
#endif
}

static int
int64_le(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err) ||
		!tolua_isuserdata(L, 2, 0, &tolua_err) ||
		!tolua_isnoobj(L, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		Int64* cobj2 = (Int64*)tolua_tousertype(L, 2, 0);
		lua_pushboolean(L, cobj1->getValue() <= cobj2->getValue());
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_le'.", &tolua_err);
	return 0;
#endif
}

static int
int64_get(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj1 = (Int64*)tolua_tousertype(L, 1, 0);
		lua_pushnumber(L, (lua_Number)cobj1->getValue());
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_len'.", &tolua_err);
	return 0;
#endif
}

static int
int64_set(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj = (Int64*)tolua_tousertype(L, 1, 0);
		int top = lua_gettop(L) - 1;
		int64_t n;
		switch (top) {
		case 0:
			cobj->setValue(0);
			break;
		case 1:

			n = int64(L, 2);
			cobj->setValue(n);
			break;
		case 2: {
			int base = luaL_checkinteger(L, 3);
			if (base < 2) {
				luaL_error(L, "base must be >= 2");
			}
			const char * str = luaL_checkstring(L, 1);
			n = strtoll(str, NULL, base);
			cobj->setValue(n);
			break;
		}
		}
		tolua_pushusertype(L, (void*)cobj, "cc.Int64");
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'int64_len'.", &tolua_err);
	return 0;
#endif
}

static int
tostring(lua_State *L) {
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(L, 1, 0, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj = (Int64*)tolua_tousertype(L, 1, 0);

		static char *hex = "0123456789ABCDEF";
		int64_t n = cobj->getValue();
		int base = 10;
		if (lua_gettop(L) == 1) {

		}
		else {
			base = luaL_checkinteger(L, 2);
		}
		int shift, mask;
		switch (base) {
		case 0: {
			unsigned char buffer[8];
			int i;
			for (i = 0; i<8; i++) {
				buffer[i] = (n >> (i * 8)) & 0xff;
			}
			lua_pushlstring(L, (const char *)buffer, 8);
			return 1;
		}
		case 10: {
			int64_t dec = (int64_t)n;
			luaL_Buffer b;
			luaL_buffinit(L, &b);
			if (dec<0) {
				luaL_addchar(&b, '-');
				dec = -dec;
			}
			int buffer[32];
			int i;
			for (i = 0; i<32; i++) {
				buffer[i] = dec % 10;
				dec /= 10;
				if (dec == 0)
					break;
			}
			while (i >= 0) {
				luaL_addchar(&b, hex[buffer[i]]);
				--i;
			}
			luaL_pushresult(&b);
			return 1;
		}
		case 2:
			shift = 1;
			mask = 1;
			break;
		case 8:
			shift = 3;
			mask = 7;
			break;
		case 16:
			shift = 4;
			mask = 0xf;
			break;
		default:
			luaL_error(L, "Unsupport base %d", base);
			break;
		}
		int i;
		char buffer[64];
		for (i = 0; i<64; i += shift) {
			buffer[i / shift] = hex[(n >> (64 - shift - i)) & mask];
		}
		lua_pushlstring(L, buffer, 64 / shift);
		return 1;
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(L, "#ferror in function 'tostring'.", &tolua_err);
	return 0;
#endif

}



static int readInt64(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(tolua_S, 1, 0, &tolua_err) ||
		!tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 3, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 4, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj = (Int64*)tolua_tousertype(tolua_S, 1, 0);

		size_t size = 0;
		unsigned char *data = (unsigned char *)lua_tolstring(tolua_S, 2, &size);
		if (data != NULL && size == 8){
			int endian = lua_tointeger(tolua_S, 3);//传进来的buf 是否为小端
			long long value = 0;

			if (endian == 0){//小端
				if (isEndianLittle()){
					memcpy(&value, data, size);
				}
				else{
					for (int i = 0; i < size; i++){
						char* tmp = (char*)&value;
						tmp[i] = data[size - i - 1];

					}
				}

			}
			else{//大端
				if (!isEndianLittle()){
					memcpy(&value, data, size);
				}
				else{
					for (int i = 0; i < size; i++){
						char* tmp = (char*)&value;
						tmp[i] = data[size - i - 1];

					}
				}
			}
			cobj->setValue(value);
			tolua_pushusertype(tolua_S, (void*)cobj, "cc.Int64");
			return 1;
		}
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'readInt64'.", &tolua_err);
	return 0;
#endif

}
static int writeInt64(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isuserdata(tolua_S, 1, 0, &tolua_err) ||
		!tolua_isnumber(tolua_S, 2, 0, &tolua_err) ||
		!tolua_isnoobj(tolua_S, 3, &tolua_err)
		)
		goto tolua_lerror;
	else
#endif
	{
		Int64* cobj = (Int64*)tolua_tousertype(tolua_S, 1, 0);
		int64_t value = cobj->getValue();
		int endian = lua_tointeger(tolua_S, 2);//传进来的buf 是否为小端
		unsigned char p[8];
		if (endian == 0){//小端
			if (isEndianLittle()){
				for (int i = 0; i < 8; i++){
					p[i] = (value >> i * 8) & 0xFF;
				}

			}
			else{
				for (int i = 0; i < 8; i++){
					p[i] = (value >> ((8 - i - 1) * 8)) & 0xFF;
				}
			}

		}
		else{//大端
			if (!isEndianLittle()){
				for (int i = 0; i < 8; i++){
					p[i] = (value >> i * 8) & 0xFF;
				}
			}
			else{

				for (int i = 0; i < 8; i++){
					p[i] = (value >> (8 - i - 1) * 8) & 0xFF;
				}
			}
		}
		lua_pushlstring(tolua_S, (const char *)p, 8);
		return 1;
		/*p[0] = (value >> 56) & 0xFF;
		p[1] = (value >> 48) & 0xFF;
		p[2] = (value >> 40) & 0xFF;
		p[3] = (value >> 32) & 0xFF;
		p[4] = (value >> 24) & 0xFF;
		p[5] = (value >> 16) & 0xFF;
		p[6] = (value >> 8) & 0xFF;
		p[7] = (value >> 0) & 0xFF;*/
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror :
	tolua_error(tolua_S, "#ferror in function 'writeInt64'.", &tolua_err);
	return 0;
#endif


}


static void
make_mt(lua_State *L) {
	luaL_Reg lib[] = {
		{ "__add", int64_add },
		{ "__sub", int64_sub },
		{ "__mul", int64_mul },
		{ "__div", int64_div },
		{ "__mod", int64_mod },
		{ "__unm", int64_unm },
		{ "__pow", int64_pow },
		{ "__eq", int64_eq },
		{ "__lt", int64_lt },
		{ "__le", int64_le },
		//{ "__len", int64_len },
		{ "__tostring", tostring },
		{ NULL, NULL },
	};
	lua_newtable(L);
	luaL_register(L, NULL, lib);
}

int
luaopen_int64(lua_State *L) {
	/*if (sizeof(intptr_t)!=sizeof(int64_t)) {
	return luaL_error(L, "Only support 64bit architecture");
	}*/
	lua_pushlightuserdata(L, NULL);
	make_mt(L);
	lua_setmetatable(L, -2);
	lua_pop(L, 1);

	lua_newtable(L);
	lua_pushcfunction(L, int64_new);
	lua_setfield(L, -2, "new");
	lua_pushcfunction(L, tostring);
	lua_setfield(L, -2, "tostring");
	lua_pushcfunction(L, readInt64);
	lua_setfield(L, -2, "read");
	lua_pushcfunction(L, writeInt64);
	lua_setfield(L, -2, "write");

	lua_setglobal(L, "my_int64");
	return 1;
}

static int tolua_collect_Int64(lua_State* tolua_S)
{
	Int64* self = (Int64*)tolua_tousertype(tolua_S, 1, 0);
	Mtolua_delete(self);
	return 0;
}
TOLUA_API int tolua_int64_open(lua_State* tolua_S){
	tolua_open(tolua_S);
	tolua_module(tolua_S, "cc", 0);
	tolua_beginmodule(tolua_S, "cc");
	tolua_usertype(tolua_S, "cc.Int64");
	tolua_cclass(tolua_S, "Int64", "cc.Int64", "", tolua_collect_Int64);
	tolua_beginmodule(tolua_S, "Int64");
	tolua_function(tolua_S, "new", int64_new);
	tolua_function(tolua_S, "get", int64_get);
	tolua_function(tolua_S, "set", int64_set);
	tolua_function(tolua_S, "add", int64_self_add);
	tolua_function(tolua_S, "sub", int64_self_sub);
	tolua_function(tolua_S, "mul", int64_self_mul);
	tolua_function(tolua_S, "tostring", tostring);
	tolua_function(tolua_S, "read", readInt64);
	tolua_function(tolua_S, "write", writeInt64);

	luaL_Reg lib[] = {
		{ "__add", int64_add },
		{ "__sub", int64_sub },
		{ "__mul", int64_mul },
		{ "__div", int64_div },
		{ "__mod", int64_mod },
		{ "__unm", int64_unm },
		{ "__pow", int64_pow },
		{ "__eq", int64_eq },
		{ "__lt", int64_lt },
		{ "__le", int64_le },
		{ "__tostring", tostring },
		{ NULL, NULL },
	};
	for (int i = 0; i < 11; i++){
		tolua_function(tolua_S, lib[i].name, lib[i].func);
	}

	tolua_endmodule(tolua_S);
	std::string typeName = typeid(Int64).name();
	g_luaType[typeName] = "cc.Int64";
	g_typeCast["Int64"] = "cc.Int64";
	tolua_endmodule(tolua_S);
	return 1;
}

