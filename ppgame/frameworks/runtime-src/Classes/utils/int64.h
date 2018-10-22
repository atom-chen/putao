#ifndef __INT64_H__
#define __INT64_H__
extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}
#include "tolua_fix.h"
#include "cocos2d.h"
#include "CCLuaStack.h"
#include "CCLuaValue.h"
#include "CCLuaEngine.h"
#include "utils/Log.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

class Int64{
public:
	Int64(){

	}
	~Int64(){
		//log("%s excute", __FUNCTION__);
	}
private:
	long long value;
public:
	void setValue(long long value){
		this->value = value;
	}
	long long  getValue(){
		return this->value;
	}
};

extern int tolua_int64_open(lua_State *L);
#endif