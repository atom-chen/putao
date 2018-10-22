#include "auto/lua_xianyou_auto.hpp"
#include "texmerge/TextureMerge.h"
#include "texmerge/KKLabelFT2.h"
#include "astar/PathFinder.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_xianyou_TextureMerge_createSprite(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_createSprite'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        bool arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.TextureMerge:createSprite"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "xianyou.TextureMerge:createSprite");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_createSprite'", nullptr);
            return 0;
        }
        cocos2d::Sprite* ret = cobj->createSprite(arg0, arg1);
        object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite",(cocos2d::Sprite*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:createSprite",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_createSprite'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_addImage(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_addImage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        bool arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.TextureMerge:addImage"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "xianyou.TextureMerge:addImage");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_addImage'", nullptr);
            return 0;
        }
        bool ret = cobj->addImage(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:addImage",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_addImage'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_saveToFile(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_saveToFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.TextureMerge:saveToFile"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_saveToFile'", nullptr);
            return 0;
        }
        bool ret = cobj->saveToFile(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:saveToFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_saveToFile'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_createScale9Sprite(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_createScale9Sprite'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        bool arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.TextureMerge:createScale9Sprite"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "xianyou.TextureMerge:createScale9Sprite");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_createScale9Sprite'", nullptr);
            return 0;
        }
        cocos2d::ui::Scale9Sprite* ret = cobj->createScale9Sprite(arg0, arg1);
        object_to_luaval<cocos2d::ui::Scale9Sprite>(tolua_S, "ccui.Scale9Sprite",(cocos2d::ui::Scale9Sprite*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:createScale9Sprite",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_createScale9Sprite'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_getTexture(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_getTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_getTexture'", nullptr);
            return 0;
        }
        cocos2d::Texture2D* ret = cobj->getTexture();
        object_to_luaval<cocos2d::Texture2D>(tolua_S, "cc.Texture2D",(cocos2d::Texture2D*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:getTexture",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_getTexture'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_setRealHeight(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_setRealHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.TextureMerge:setRealHeight");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_setRealHeight'", nullptr);
            return 0;
        }
        cobj->setRealHeight(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:setRealHeight",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_setRealHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_clear(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_clear'", nullptr);
            return 0;
        }
        cobj->clear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "xianyou.TextureMerge:clear");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_clear'", nullptr);
            return 0;
        }
        cobj->clear(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:clear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_clear'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_addSystemChar(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_addSystemChar'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "xianyou.TextureMerge:addSystemChar");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.TextureMerge:addSystemChar");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_addSystemChar'", nullptr);
            return 0;
        }
        bool ret = cobj->addSystemChar(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:addSystemChar",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_addSystemChar'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_getHeight(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_getHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_getHeight'", nullptr);
            return 0;
        }
        double ret = cobj->getHeight();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:getHeight",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_getHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_getWidth(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_getWidth'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_getWidth'", nullptr);
            return 0;
        }
        double ret = cobj->getWidth();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:getWidth",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_getWidth'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_addString(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::TextureMerge* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::TextureMerge*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_TextureMerge_addString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "xianyou.TextureMerge:addString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_addString'", nullptr);
            return 0;
        }
        bool ret = cobj->addString(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.TextureMerge:addString",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_addString'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_TextureMerge_delInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_delInstance'", nullptr);
            return 0;
        }
        xianyou::TextureMerge::delInstance();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "xianyou.TextureMerge:delInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_delInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_xianyou_TextureMerge_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"xianyou.TextureMerge",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_TextureMerge_getInstance'", nullptr);
            return 0;
        }
        xianyou::TextureMerge* ret = xianyou::TextureMerge::getInstance();
        object_to_luaval<xianyou::TextureMerge>(tolua_S, "xianyou.TextureMerge",(xianyou::TextureMerge*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "xianyou.TextureMerge:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_TextureMerge_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_xianyou_TextureMerge_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (TextureMerge)");
    return 0;
}

int lua_register_xianyou_TextureMerge(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"xianyou.TextureMerge");
    tolua_cclass(tolua_S,"TextureMerge","xianyou.TextureMerge","",nullptr);

    tolua_beginmodule(tolua_S,"TextureMerge");
        tolua_function(tolua_S,"createSprite",lua_xianyou_TextureMerge_createSprite);
        tolua_function(tolua_S,"addImage",lua_xianyou_TextureMerge_addImage);
        tolua_function(tolua_S,"saveToFile",lua_xianyou_TextureMerge_saveToFile);
        tolua_function(tolua_S,"createScale9Sprite",lua_xianyou_TextureMerge_createScale9Sprite);
        tolua_function(tolua_S,"getTexture",lua_xianyou_TextureMerge_getTexture);
        tolua_function(tolua_S,"setRealHeight",lua_xianyou_TextureMerge_setRealHeight);
        tolua_function(tolua_S,"clear",lua_xianyou_TextureMerge_clear);
        tolua_function(tolua_S,"addSystemChar",lua_xianyou_TextureMerge_addSystemChar);
        tolua_function(tolua_S,"getHeight",lua_xianyou_TextureMerge_getHeight);
        tolua_function(tolua_S,"getWidth",lua_xianyou_TextureMerge_getWidth);
        tolua_function(tolua_S,"addString",lua_xianyou_TextureMerge_addString);
        tolua_function(tolua_S,"delInstance", lua_xianyou_TextureMerge_delInstance);
        tolua_function(tolua_S,"getInstance", lua_xianyou_TextureMerge_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(xianyou::TextureMerge).name();
    g_luaType[typeName] = "xianyou.TextureMerge";
    g_typeCast["TextureMerge"] = "xianyou.TextureMerge";
    return 1;
}

int lua_xianyou_KKLabelFT2_setLineSpace(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setLineSpace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.KKLabelFT2:setLineSpace");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setLineSpace'", nullptr);
            return 0;
        }
        cobj->setLineSpace(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setLineSpace",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setLineSpace'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setAnchorPoint(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setAnchorPoint'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Point arg0;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "xianyou.KKLabelFT2:setAnchorPoint");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setAnchorPoint'", nullptr);
            return 0;
        }
        cobj->setAnchorPoint(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setAnchorPoint",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setAnchorPoint'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getFontSize(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getFontSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getFontSize'", nullptr);
            return 0;
        }
        int ret = cobj->getFontSize();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getFontSize",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getFontSize'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getString(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getString'", nullptr);
            return 0;
        }
        const std::string& ret = cobj->getString();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getString",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getString'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_isBold(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_isBold'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_isBold'", nullptr);
            return 0;
        }
        bool ret = cobj->isBold();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:isBold",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_isBold'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setItalic(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setItalic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "xianyou.KKLabelFT2:setItalic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setItalic'", nullptr);
            return 0;
        }
        cobj->setItalic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setItalic",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setItalic'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setFontColorBg(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setFontColorBg'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "xianyou.KKLabelFT2:setFontColorBg");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setFontColorBg'", nullptr);
            return 0;
        }
        cobj->setFontColorBg(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setFontColorBg",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setFontColorBg'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setBold(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setBold'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "xianyou.KKLabelFT2:setBold");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setBold'", nullptr);
            return 0;
        }
        cobj->setBold(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setBold",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setBold'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setString(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "xianyou.KKLabelFT2:setString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setString'", nullptr);
            return 0;
        }
        cobj->setString(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setString",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setString'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setOpacity(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setOpacity'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        uint16_t arg0;

        ok &= luaval_to_uint16(tolua_S, 2,&arg0, "xianyou.KKLabelFT2:setOpacity");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setOpacity'", nullptr);
            return 0;
        }
        cobj->setOpacity(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setOpacity",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setOpacity'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getLineSpace(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getLineSpace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getLineSpace'", nullptr);
            return 0;
        }
        int ret = cobj->getLineSpace();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getLineSpace",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getLineSpace'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setLineAlign(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setLineAlign'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.KKLabelFT2:setLineAlign");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setLineAlign'", nullptr);
            return 0;
        }
        cobj->setLineAlign(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setLineAlign",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setLineAlign'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getFontName(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getFontName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getFontName'", nullptr);
            return 0;
        }
        const std::string& ret = cobj->getFontName();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getFontName",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getFontName'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_isItalic(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_isItalic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_isItalic'", nullptr);
            return 0;
        }
        bool ret = cobj->isItalic();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:isItalic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_isItalic'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getFontColorBg(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getFontColorBg'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getFontColorBg'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getFontColorBg();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getFontColorBg",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getFontColorBg'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getFontColor(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getFontColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getFontColor'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getFontColor();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getFontColor",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getFontColor'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setWordSpace(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setWordSpace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.KKLabelFT2:setWordSpace");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setWordSpace'", nullptr);
            return 0;
        }
        cobj->setWordSpace(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setWordSpace",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setWordSpace'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getRealWidth(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getRealWidth'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getRealWidth'", nullptr);
            return 0;
        }
        int ret = cobj->getRealWidth();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getRealWidth",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getRealWidth'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getWordSpace(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getWordSpace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getWordSpace'", nullptr);
            return 0;
        }
        int ret = cobj->getWordSpace();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getWordSpace",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getWordSpace'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setContentSize(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setContentSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Size arg0;

        ok &= luaval_to_size(tolua_S, 2, &arg0, "xianyou.KKLabelFT2:setContentSize");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setContentSize'", nullptr);
            return 0;
        }
        cobj->setContentSize(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setContentSize",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setContentSize'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getLineAlign(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getLineAlign'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getLineAlign'", nullptr);
            return 0;
        }
        int ret = cobj->getLineAlign();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getLineAlign",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getLineAlign'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setFontColor(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setFontColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "xianyou.KKLabelFT2:setFontColor");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setFontColor'", nullptr);
            return 0;
        }
        cobj->setFontColor(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setFontColor",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setFontColor'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_getRealHeight(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_getRealHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_getRealHeight'", nullptr);
            return 0;
        }
        int ret = cobj->getRealHeight();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:getRealHeight",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_getRealHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_setFont(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::KKLabelFT2*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_KKLabelFT2_setFont'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        int arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.KKLabelFT2:setFont"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.KKLabelFT2:setFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_setFont'", nullptr);
            return 0;
        }
        cobj->setFont(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:setFont",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_setFont'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_KKLabelFT2_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"xianyou.KKLabelFT2",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        const char* arg0;
        int arg1;
        bool arg2;
        bool arg3;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.KKLabelFT2:create"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.KKLabelFT2:create");
        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "xianyou.KKLabelFT2:create");
        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "xianyou.KKLabelFT2:create");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_create'", nullptr);
            return 0;
        }
        xianyou::KKLabelFT2* ret = xianyou::KKLabelFT2::create(arg0, arg1, arg2, arg3);
        object_to_luaval<xianyou::KKLabelFT2>(tolua_S, "xianyou.KKLabelFT2",(xianyou::KKLabelFT2*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "xianyou.KKLabelFT2:create",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_create'.",&tolua_err);
#endif
    return 0;
}
int lua_xianyou_KKLabelFT2_constructor(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::KKLabelFT2* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        double arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.KKLabelFT2:KKLabelFT2"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_number(tolua_S, 3,&arg1, "xianyou.KKLabelFT2:KKLabelFT2");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_KKLabelFT2_constructor'", nullptr);
            return 0;
        }
        cobj = new xianyou::KKLabelFT2(arg0, arg1);
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"xianyou.KKLabelFT2");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.KKLabelFT2:KKLabelFT2",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_KKLabelFT2_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_xianyou_KKLabelFT2_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (KKLabelFT2)");
    return 0;
}

int lua_register_xianyou_KKLabelFT2(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"xianyou.KKLabelFT2");
    tolua_cclass(tolua_S,"KKLabelFT2","xianyou.KKLabelFT2","cc.Node",nullptr);

    tolua_beginmodule(tolua_S,"KKLabelFT2");
        tolua_function(tolua_S,"new",lua_xianyou_KKLabelFT2_constructor);
        tolua_function(tolua_S,"setLineSpace",lua_xianyou_KKLabelFT2_setLineSpace);
        tolua_function(tolua_S,"setAnchorPoint",lua_xianyou_KKLabelFT2_setAnchorPoint);
        tolua_function(tolua_S,"getFontSize",lua_xianyou_KKLabelFT2_getFontSize);
        tolua_function(tolua_S,"getString",lua_xianyou_KKLabelFT2_getString);
        tolua_function(tolua_S,"isBold",lua_xianyou_KKLabelFT2_isBold);
        tolua_function(tolua_S,"setItalic",lua_xianyou_KKLabelFT2_setItalic);
        tolua_function(tolua_S,"setFontColorBg",lua_xianyou_KKLabelFT2_setFontColorBg);
        tolua_function(tolua_S,"setBold",lua_xianyou_KKLabelFT2_setBold);
        tolua_function(tolua_S,"setString",lua_xianyou_KKLabelFT2_setString);
        tolua_function(tolua_S,"setOpacity",lua_xianyou_KKLabelFT2_setOpacity);
        tolua_function(tolua_S,"getLineSpace",lua_xianyou_KKLabelFT2_getLineSpace);
        tolua_function(tolua_S,"setLineAlign",lua_xianyou_KKLabelFT2_setLineAlign);
        tolua_function(tolua_S,"getFontName",lua_xianyou_KKLabelFT2_getFontName);
        tolua_function(tolua_S,"isItalic",lua_xianyou_KKLabelFT2_isItalic);
        tolua_function(tolua_S,"getFontColorBg",lua_xianyou_KKLabelFT2_getFontColorBg);
        tolua_function(tolua_S,"getFontColor",lua_xianyou_KKLabelFT2_getFontColor);
        tolua_function(tolua_S,"setWordSpace",lua_xianyou_KKLabelFT2_setWordSpace);
        tolua_function(tolua_S,"getRealWidth",lua_xianyou_KKLabelFT2_getRealWidth);
        tolua_function(tolua_S,"getWordSpace",lua_xianyou_KKLabelFT2_getWordSpace);
        tolua_function(tolua_S,"setContentSize",lua_xianyou_KKLabelFT2_setContentSize);
        tolua_function(tolua_S,"getLineAlign",lua_xianyou_KKLabelFT2_getLineAlign);
        tolua_function(tolua_S,"setFontColor",lua_xianyou_KKLabelFT2_setFontColor);
        tolua_function(tolua_S,"getRealHeight",lua_xianyou_KKLabelFT2_getRealHeight);
        tolua_function(tolua_S,"setFont",lua_xianyou_KKLabelFT2_setFont);
        tolua_function(tolua_S,"create", lua_xianyou_KKLabelFT2_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(xianyou::KKLabelFT2).name();
    g_luaType[typeName] = "xianyou.KKLabelFT2";
    g_typeCast["KKLabelFT2"] = "xianyou.KKLabelFT2";
    return 1;
}

int lua_xianyou_PathFinder_setBound(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_setBound'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        unsigned int arg0;
        unsigned int arg1;
        unsigned int arg2;
        unsigned int arg3;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "xianyou.PathFinder:setBound");

        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "xianyou.PathFinder:setBound");

        ok &= luaval_to_uint32(tolua_S, 4,&arg2, "xianyou.PathFinder:setBound");

        ok &= luaval_to_uint32(tolua_S, 5,&arg3, "xianyou.PathFinder:setBound");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_setBound'", nullptr);
            return 0;
        }
        cobj->setBound(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:setBound",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_setBound'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getWidth(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_getWidth'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getWidth'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getWidth();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:getWidth",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getWidth'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_setTerrain(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_setTerrain'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        int arg1;
        int arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.PathFinder:setTerrain");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.PathFinder:setTerrain");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "xianyou.PathFinder:setTerrain");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_setTerrain'", nullptr);
            return 0;
        }
        cobj->setTerrain(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:setTerrain",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_setTerrain'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_isBlock(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_isBlock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.PathFinder:isBlock");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.PathFinder:isBlock");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_isBlock'", nullptr);
            return 0;
        }
        bool ret = cobj->isBlock(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:isBlock",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_isBlock'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_saveBlock(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_saveBlock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.PathFinder:saveBlock"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_saveBlock'", nullptr);
            return 0;
        }
        bool ret = cobj->saveBlock(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:saveBlock",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_saveBlock'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getHeight(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_getHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getHeight'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getHeight();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:getHeight",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_addBlockRef(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_addBlockRef'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        int arg1;
        bool arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.PathFinder:addBlockRef");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.PathFinder:addBlockRef");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "xianyou.PathFinder:addBlockRef");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_addBlockRef'", nullptr);
            return 0;
        }
        bool ret = cobj->addBlockRef(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:addBlockRef",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_addBlockRef'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_findPath(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_findPath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 5) 
    {
        int arg0;
        int arg1;
        int arg2;
        int arg3;
        int arg4;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.PathFinder:findPath");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.PathFinder:findPath");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "xianyou.PathFinder:findPath");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "xianyou.PathFinder:findPath");

        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "xianyou.PathFinder:findPath");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_findPath'", nullptr);
            return 0;
        }
        bool ret = cobj->findPath(arg0, arg1, arg2, arg3, arg4);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:findPath",argc, 5);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_findPath'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getSize(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_getSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getSize'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getSize();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:getSize",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getSize'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_setBlock(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_setBlock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        int arg1;
        bool arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.PathFinder:setBlock");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.PathFinder:setBlock");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "xianyou.PathFinder:setBlock");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_setBlock'", nullptr);
            return 0;
        }
        bool ret = cobj->setBlock(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:setBlock",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_setBlock'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getXList(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_getXList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getXList'", nullptr);
            return 0;
        }
        std::vector<int>& ret = cobj->getXList();
        ccvector_int_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:getXList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getXList'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getYList(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_getYList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getYList'", nullptr);
            return 0;
        }
        std::vector<int>& ret = cobj->getYList();
        ccvector_int_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:getYList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getYList'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_createBlock(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_createBlock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        unsigned int arg0;
        unsigned int arg1;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "xianyou.PathFinder:createBlock");

        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "xianyou.PathFinder:createBlock");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_createBlock'", nullptr);
            return 0;
        }
        cobj->createBlock(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:createBlock",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_createBlock'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getWeight(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_getWeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.PathFinder:getWeight");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.PathFinder:getWeight");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getWeight'", nullptr);
            return 0;
        }
        int32_t ret = cobj->getWeight(arg0, arg1);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:getWeight",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getWeight'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_loadBlock(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_loadBlock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "xianyou.PathFinder:loadBlock"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_loadBlock'", nullptr);
            return 0;
        }
        bool ret = cobj->loadBlock(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:loadBlock",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_loadBlock'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getTerrain(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (xianyou::PathFinder*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xianyou_PathFinder_getTerrain'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "xianyou.PathFinder:getTerrain");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "xianyou.PathFinder:getTerrain");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getTerrain'", nullptr);
            return 0;
        }
        int ret = cobj->getTerrain(arg0, arg1);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:getTerrain",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getTerrain'.",&tolua_err);
#endif

    return 0;
}
int lua_xianyou_PathFinder_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"xianyou.PathFinder",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_getInstance'", nullptr);
            return 0;
        }
        xianyou::PathFinder* ret = xianyou::PathFinder::getInstance();
        object_to_luaval<xianyou::PathFinder>(tolua_S, "xianyou.PathFinder",(xianyou::PathFinder*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "xianyou.PathFinder:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_xianyou_PathFinder_constructor(lua_State* tolua_S)
{
    int argc = 0;
    xianyou::PathFinder* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_xianyou_PathFinder_constructor'", nullptr);
            return 0;
        }
        cobj = new xianyou::PathFinder();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"xianyou.PathFinder");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "xianyou.PathFinder:PathFinder",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_xianyou_PathFinder_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_xianyou_PathFinder_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (PathFinder)");
    return 0;
}

int lua_register_xianyou_PathFinder(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"xianyou.PathFinder");
    tolua_cclass(tolua_S,"PathFinder","xianyou.PathFinder","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"PathFinder");
        tolua_function(tolua_S,"new",lua_xianyou_PathFinder_constructor);
        tolua_function(tolua_S,"setBound",lua_xianyou_PathFinder_setBound);
        tolua_function(tolua_S,"getWidth",lua_xianyou_PathFinder_getWidth);
        tolua_function(tolua_S,"setTerrain",lua_xianyou_PathFinder_setTerrain);
        tolua_function(tolua_S,"isBlock",lua_xianyou_PathFinder_isBlock);
        tolua_function(tolua_S,"saveBlock",lua_xianyou_PathFinder_saveBlock);
        tolua_function(tolua_S,"getHeight",lua_xianyou_PathFinder_getHeight);
        tolua_function(tolua_S,"addBlockRef",lua_xianyou_PathFinder_addBlockRef);
        tolua_function(tolua_S,"findPath",lua_xianyou_PathFinder_findPath);
        tolua_function(tolua_S,"getSize",lua_xianyou_PathFinder_getSize);
        tolua_function(tolua_S,"setBlock",lua_xianyou_PathFinder_setBlock);
        tolua_function(tolua_S,"getXList",lua_xianyou_PathFinder_getXList);
        tolua_function(tolua_S,"getYList",lua_xianyou_PathFinder_getYList);
        tolua_function(tolua_S,"createBlock",lua_xianyou_PathFinder_createBlock);
        tolua_function(tolua_S,"getWeight",lua_xianyou_PathFinder_getWeight);
        tolua_function(tolua_S,"loadBlock",lua_xianyou_PathFinder_loadBlock);
        tolua_function(tolua_S,"getTerrain",lua_xianyou_PathFinder_getTerrain);
        tolua_function(tolua_S,"getInstance", lua_xianyou_PathFinder_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(xianyou::PathFinder).name();
    g_luaType[typeName] = "xianyou.PathFinder";
    g_typeCast["PathFinder"] = "xianyou.PathFinder";
    return 1;
}
TOLUA_API int register_all_xianyou(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"xianyou",0);
	tolua_beginmodule(tolua_S,"xianyou");

	lua_register_xianyou_PathFinder(tolua_S);
	lua_register_xianyou_KKLabelFT2(tolua_S);
	lua_register_xianyou_TextureMerge(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

