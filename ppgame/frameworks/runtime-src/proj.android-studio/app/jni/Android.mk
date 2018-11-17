LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := curl_lib_static
LOCAL_SRC_FILES := ../../../../cocos2d-x/external/curl/prebuilt/android/$(TARGET_ARCH_ABI)/libcurl.a
include $(PREBUILT_STATIC_LIBRARY)

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
../../../Classes/quick-src/extra/crypto/base64/libbase64.c \
../../../Classes/quick-src/extra/crypto/md5/md5.c \
../../../Classes/quick-src/extra/crypto/CCCrypto.cpp \
../../../Classes/quick-src/extra/platform/android/CCCryptoAndroid.cpp \
../../../Classes/quick-src/extra/luabinding/cocos2dx_extra_luabinding.cpp \
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
../../../Classes/curlhttp/CurlAsset.cpp \
../../../Classes/down/DownAsset.cpp \
../../../Classes/auto/lua_xianyou_auto.cpp \
../../../Classes/manual/lua_xianyou_manual.cpp \
../../../Classes/Gif/Bitmap.cpp \
../../../Classes/Gif/CacheGif.cpp \
../../../Classes/Gif/GifBase.cpp \
../../../Classes/Gif/GifMovie.cpp \
../../../Classes/Gif/InstantGif.cpp \
../../../Classes/Gif/Movie.cpp \
../../../Classes/Gif/gif_lib/dgif_lib.c \
../../../Classes/Gif/gif_lib/gif_err.c \
../../../Classes/Gif/gif_lib/gif_font.c \
../../../Classes/Gif/gif_lib/gif_hash.c \
../../../Classes/Gif/gif_lib/gifalloc.c \
../../../Classes/Gif/gif_lib/quantize.c \
hellolua/main.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes \
$(LOCAL_PATH)/../../../Classes/quick-src/extra \
$(LOCAL_PATH)/../../../Classes/quick-src/extra/luabinding \
$(LOCAL_PATH)/../../../Classes/quick-src/lua_extensions \
$(LOCAL_PATH)/../../../Classes/texmerge \
$(LOCAL_PATH)/../../../Classes/astar \
$(LOCAL_PATH)/../../../Classes/net \
$(LOCAL_PATH)/../../../Classes/auto \
$(LOCAL_PATH)/../../../Classes/manual \
$(LOCAL_PATH)/../../../Classes/curlhttp \
$(LOCAL_PATH)/../../../Classes/down \
$(LOCAL_PATH)/../../../Classes/Gif \
$(LOCAL_PATH)/../../../../cocos2d-x/external/curl/include/android \

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static
LOCAL_STATIC_LIBRARIES += curl_lib_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module, tools/simulator/libsimulator/proj.android)
$(call import-module, external/curl/prebuilt/android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
