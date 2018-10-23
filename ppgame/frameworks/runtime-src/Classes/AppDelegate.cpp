#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"

// #define USE_AUDIO_ENGINE 1
 #define USE_SIMPLE_AUDIO_ENGINE 1

#if USE_AUDIO_ENGINE && USE_SIMPLE_AUDIO_ENGINE
#error "Don't use AudioEngine and SimpleAudioEngine at the same time. Please just select one in your game!"
#endif

#if USE_AUDIO_ENGINE
#include "audio/include/AudioEngine.h"
using namespace cocos2d::experimental;
#elif USE_SIMPLE_AUDIO_ENGINE
#include "audio/include/SimpleAudioEngine.h"
using namespace CocosDenshion;
#endif

#include "cocos2dx_extra.h"

#include "luabinding/cocos2dx_extra_luabinding.h"
//#include "luabinding/HelperFunc_luabinding.h"
#include "lua_extensions_more.h"
#include "auto/lua_xianyou_auto.hpp"
#include "manual/lua_xianyou_manual.h"

#include "serialize/PacketHelper.h"
#include "utils/Log.h"
#include "utils/int64.h"

USING_NS_CC;
using namespace std;


static int tolua_Cocos2d_Function_loadChunksFromZIP(lua_State* tolua_S)
{
	return LuaEngine::getInstance()->getLuaStack()->luaLoadChunksFromZIP(tolua_S);
}

void extendFunctions(lua_State* tolua_S)
{
	tolua_module(tolua_S, "cc", 0);
	tolua_beginmodule(tolua_S, "cc");
	tolua_function(tolua_S, "LuaLoadChunksFromZIP", tolua_Cocos2d_Function_loadChunksFromZIP);
	tolua_endmodule(tolua_S);
}

static void quick_module_register(lua_State *L)
{
	luaopen_lua_extensions_more(L);
	lua_getglobal(L, "_G");
	if (lua_istable(L, -1))//stack:...,_G,
	{
		tolua_int64_open(L);
		extendFunctions(L);
		luaopen_cocos2dx_extra_luabinding(L);
		register_all_xianyou(L);
	}
	lua_pop(L, 1);
}


AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
#if USE_AUDIO_ENGINE
    AudioEngine::end();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::end();
#endif

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
    return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);

	quick_module_register(L);
	register_packet_helper_manual(L);
	register_Custom_XLog(L);
	register_manual_MessageDispatcher(L);

    register_all_packages();

	std::string k = "LHPxyou520";
	std::string s = "xxtea";
	FileUtils::getInstance()->setXXTEAKeyAndSign(k, s);
    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign( k.c_str(), k.size(), s.c_str(), s.size() );

    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());
    
	FileUtils::getInstance()->addSearchPath("Assets");
#if CC_64BITS
    FileUtils::getInstance()->addSearchPath("Assets/src/64bit");
#endif
    FileUtils::getInstance()->addSearchPath("Assets/src");
    FileUtils::getInstance()->addSearchPath("Assets/res");
    if (engine->executeScriptFile("src/main.lua"))
    {
        return false;
    }

    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

#if USE_AUDIO_ENGINE
    AudioEngine::pauseAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
    SimpleAudioEngine::getInstance()->pauseAllEffects();
#endif
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

#if USE_AUDIO_ENGINE
    AudioEngine::resumeAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    SimpleAudioEngine::getInstance()->resumeAllEffects();
#endif
}
