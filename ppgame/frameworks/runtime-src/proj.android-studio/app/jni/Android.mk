LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := \
../../../Classes/AppDelegate.cpp \
../../../Classes/quick-src/lua_extensions/filesystem/lfs.c \
../../../Classes/quick-src/lua_extensions/lpack/lpack.c \
../../../Classes/quick-src/lua_extensions/lsqlite3/lsqlite3.c \
../../../Classes/quick-src/lua_extensions/lsqlite3/sqlite3.c \
../../../Classes/quick-src/lua_extensions/lua_extensions_more.c \
../../../Classes/quick-src/lua_extensions/protobuf/pb.c \
../../../Classes/quick-src/lua_extensions/zlib/lua_zlib.c \
../../../Classes/quick-src/lua_extensions/cjson/lua_cjson.c \
../../../Classes/quick-src/lua_extensions/cjson/strbuf.c \
../../../Classes/quick-src/lua_extensions/cjson/fpconv.c \
../../../Classes/quick-src/extra/apptools/HelperFunc.cpp \
../../../Classes/quick-src/extra/crypto/base64/libbase64.c \
../../../Classes/quick-src/extra/crypto/md5/md5.c \
../../../Classes/quick-src/extra/crypto/CCCrypto.cpp \
../../../Classes/quick-src/extra/platform/android/CCCryptoAndroid.cpp \
../../../Classes/quick-src/extra/luabinding/cocos2dx_extra_luabinding.cpp \
../../../Classes/quick-src/extra/luabinding/HelperFunc_luabinding.cpp \
../../../Classes/serialize/PacketHelper.cpp \
../../../Classes/serialize/SerialBuffer.cpp \
../../../Classes/utils/Log.cpp \
../../../Classes/utils/int64.cpp \
../../../Classes/utils/NetUtils.cpp \
../../../Classes/texmerge/TextureMerge.cpp \
../../../Classes/texmerge/KKRichText.cpp \
../../../Classes/texmerge/KKLabelFT2.cpp \
../../../Classes/astar/PathFinder.cpp \
../../../Classes/net/BSDSocket.cpp \
../../../Classes/net/MessageDispatcher.cpp \
../../../Classes/net/ReceiveThread.cpp \
../../../Classes/net/SocketThread.cpp \
../../../Classes/auto/lua_xianyou_auto.cpp \
../../../Classes/manual/lua_xianyou_manual.cpp \
hellolua/main.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes \
$(LOCAL_PATH)/../../../Classes/quick-src/extra \
$(LOCAL_PATH)/../../../Classes/quick-src/extra/luabinding \
$(LOCAL_PATH)/../../../Classes/quick-src/lua_extensions \
$(LOCAL_PATH)/../../../Classes/texmerge \
$(LOCAL_PATH)/../../../Classes/astar \
$(LOCAL_PATH)/../../../Classes/net \
$(LOCAL_PATH)/../../../Classes/auto \
$(LOCAL_PATH)/../../../Classes/manual

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
