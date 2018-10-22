#include "cocos2d.h"
#include "base/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "MessageDispatcher.h"
#include "net/ReceiveThread.h"
#include "net/SocketThread.h"
#include <vector>
#include <string>
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "platform/android/jni/JniHelper.h"
#include "platform/android/jni/Java_org_cocos2dx_lib_Cocos2dxHelper.h"
#endif
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include <windows.h>
#include <stdio.h>
#endif
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <dirent.h>
#include <sys/stat.h>
#endif
using namespace std;
USING_NS_CC;

NS_XIANYOU_BEGIN

static LuaStack* _stack = NULL;
#define BUFFER_SIZE    8192
#define MAX_FILENAME   512

#define LOW_SPEED_LIMIT 1L
#define LOW_SPEED_TIME 60L


MessageDispatcher* MessageDispatcher::getInstance()
{
	static MessageDispatcher* instance = NULL;

	if (instance == NULL)
	{
		instance = new MessageDispatcher();
		memset((int *)(instance->handlerMap), 0, MAX_CALLBACK_NUM);
		_stack = LuaEngine::getInstance()->getLuaStack();
		instance->_netState = ARPG_NET_STATE::CLOSED;
		instance->isInSchedule = false;
		instance->mPacketHelper = new PacketHelper();
	}
	return instance;
}

void MessageDispatcher::registerScriptHandler(int type, int nHandler)
{
	if (type < 0 || type >= MAX_CALLBACK_NUM)
	{
		CCLOG("registerScriptHandler error");
	}
	this->handlerMap[type] = nHandler;
}

void MessageDispatcher::unregisterScriptHandler(int type)
{
	if (type < 0 || type >= MAX_CALLBACK_NUM)
	{
		CCLOG("runegisterScriptHandler error");
	}

	int nHandler = this->handlerMap[type];
	if (nHandler != 0)
	{
		LuaEngine::getInstance()->removeScriptHandler(nHandler);
		this->handlerMap[type] = 0;
	}
}

//------------------------------------------------------------------------------------------

int MessageDispatcher::getNetState()
{
	return _netState;
}

void MessageDispatcher::setNetState(ARPG_NET_STATE state)
{
	_netState = state;

	Director::getInstance()->getScheduler()->performFunctionInCocosThread([=]{
		notifyNetStateToLua(state);
	});
}

void MessageDispatcher::startNetWork(const char* ip, int port)
{
	SocketThread::GetInstance()->setAddr(ip, port);
	if (_netState > ARPG_NET_STATE::CONNECTED && !SocketThread::isRunning)
	{
		SocketThread::GetInstance()->closeSocket();
		SocketThread::GetInstance()->stop();
		SocketThread::GetInstance()->setAddr(ip, port);
		SocketThread::GetInstance()->start();
	}
}

bool MessageDispatcher::closeNetWork()
{
	if (_netState == ARPG_NET_STATE::CONNECTED && !SocketThread::isRunning)
	{
		SocketThread::GetInstance()->closeSocket();
		SocketThread::GetInstance()->stop();
		return true;
	}
	return false;
}

void MessageDispatcher::sendMessageToServer(int len, const char* text)
{
	if (_netState == ARPG_NET_STATE::CONNECTED)
	{
		BSDSocket* csocket = SocketThread::GetInstance()->getSocket();
		if (csocket)
		{
			int cout = csocket->Send(text, len, 0);
			if (cout == -1)
			{
				CCLOG("send fail");
				setNetState(xianyou::ARPG_NET_STATE::SEND_FAIL);
			}
		}
	}
	else{
		CCLOG("send fail: not connected");
	}
}

void MessageDispatcher::sentProtoToLua(int len, int module_id, int method_id, const char* text)
{
	if (this->handlerMap[PROTO_CALLBACK] > 0)
	{
		_stack->pushInt(module_id);
		_stack->pushInt(method_id);
		_stack->pushInt(len);
		if (text)
		{
			_stack->pushString(text, len);
			int ret = _stack->executeFunctionByHandler(this->handlerMap[PROTO_CALLBACK], 4);
		}
		else
		{
			int ret = _stack->executeFunctionByHandler(this->handlerMap[PROTO_CALLBACK], 3);
		}
		_stack->clean();
	}
}

void MessageDispatcher::notifyNetStateToLua(int state)
{
	if (this->handlerMap[NET_STATE_CALLBACK] > 0)
	{
		_stack->pushInt(state);
		int ret = _stack->executeFunctionByHandler(this->handlerMap[NET_STATE_CALLBACK], 1);
		_stack->clean();
	}
}

int MessageDispatcher::getNetDelay()
{
	if (this->handlerMap[NET_DELAY_CALLBACK] > 0)
	{
		int delay = _stack->executeFunctionByHandler(this->handlerMap[NET_DELAY_CALLBACK], 0);
		_stack->clean();
		return delay;
	}
	return 0;
}

int MessageDispatcher::notifySeverList(const char* text, int len)
{
	if (this->handlerMap[GET_SERVER_LISTS] > 0)
	{
		_stack->pushString(text, len);
		int mem = _stack->executeFunctionByHandler(this->handlerMap[GET_SERVER_LISTS], 1);
		_stack->clean();
		return mem;
	}
	return 0;
}

bool MessageDispatcher::isNetConnected(std::string name)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	CCLOG("isNetConnected = %s ", name.c_str());
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, "org/cocos2dx/lib/Cocos2dxActivity", name.c_str(), "()Z");
	if (isHave)
	{
		jboolean result = (jboolean)minfo.env->CallStaticBooleanMethod(minfo.classID, minfo.methodID);
		return result;
	}
	return false;
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	return true;
#else
	return false;
#endif
}

int MessageDispatcher::getConnectedType()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	CCLOG("getConnectedType");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, "org/cocos2dx/lib/Cocos2dxActivity", "getConnectedType", "()I");
	if (isHave)
	{
		jint result = (jint)minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID);
		return result;
	}
	return -1;
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	return -1;
#else
	return -1;
#endif
}

//------------------------------------------------------------------------------------------

std::string MessageDispatcher::keyOfSomeThing(std::string key, std::string url)
{
	char buf[256];
	sprintf(buf, "%s%zd", key.c_str(), std::hash<std::string>()(url));
	return buf;
}

std::string MessageDispatcher::callForLua(int type, std::string param)
{
	std::string result = "";
	ssize_t size = 0;
	std::string pathToSave;
	std::vector<std::string> searchPaths;
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
	DIR *pDir = NULL;
#endif

	switch (type)
	{
	case 1:  //获取热更地址
		result = "";  // ConfigParser::getInstance()->getUpdateURL();
		break;

	case 2:  //获取平台
		result = ""; // ConfigParser::getInstance()->getGameplatform();
		break;

	case 3:  //创建本地缓存文件夹
		pathToSave = FileUtils::getInstance()->getWritablePath();
		pathToSave += "xcdata";
		searchPaths = FileUtils::getInstance()->getSearchPaths();

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)

		pDir = opendir(pathToSave.c_str());
		if (pDir)
		{
			searchPaths.insert(searchPaths.begin(), pathToSave);
		}
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		if (sizeof(long) != 4) {
			pathToSave += "/64bit";
			pDir = opendir(pathToSave.c_str());
			if (pDir)
			{
				searchPaths.insert(searchPaths.begin(), pathToSave);
			}
		}
#endif

#else

		if ((GetFileAttributesA(pathToSave.c_str())) != INVALID_FILE_ATTRIBUTES)
		{
			searchPaths.insert(searchPaths.begin(), pathToSave);
		}

#endif

		FileUtils::getInstance()->setSearchPaths(searchPaths);
		break;

	case 4:  //获取本地缓存所在目录
		pathToSave = FileUtils::getInstance()->getWritablePath();
		pathToSave += "xcdata";
		result = "";

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
		pDir = opendir(pathToSave.c_str());
		if (!pDir)
		{
			mkdir(pathToSave.c_str(), S_IRWXU | S_IRWXG | S_IRWXO);
		}
		result = pathToSave;
#else
		if ((GetFileAttributesA(pathToSave.c_str())) != INVALID_FILE_ATTRIBUTES)
		{
			result = pathToSave;
		}
#endif

		break;

	case 5:  //获取本机IP
		result = MessageDispatcher::getInstance()->nowhostip;
		break;

	case 6:  //获取引擎版本
		result = "0";
		break;

	case 7:  //获取Lib库版本
		result = ""; // ConfigParser::getInstance()->getLibVersion();
		break;

	case 8:
	{
			  vector<string> newsearchPath;

			  searchPaths = FileUtils::getInstance()->getSearchPaths();
			  vector<string>::iterator iter = searchPaths.begin();
			  for (; iter != searchPaths.end(); ++iter){
				  if (find(newsearchPath.begin(), newsearchPath.end(), *iter) == newsearchPath.end()){
					  newsearchPath.push_back(*iter);
				  }
			  }

			  FileUtils::getInstance()->setSearchPaths(newsearchPath);
			  break;
	}
	default:
		break;
	}

	return result;
}

static size_t getFileContentCode(void *ptr, size_t size, size_t nmemb, void *userdata)
{
	string *content = (string*)userdata;
	content->append((char*)ptr, size * nmemb);
	return (size * nmemb);
}

inline unsigned char  toHex(const unsigned char  &x)
{
	return x > 9 ? x + 55 : x + 48;
}

inline string URLEncode(const string &sIn)
{
	// cout << "size: " << sIn.size() << endl;
	string sOut;
	for (size_t ix = 0; ix < sIn.size(); ix++)
	{
		unsigned char  buf[4];
		memset(buf, 0, 4);
		if (isalnum((unsigned char)sIn[ix]))
		{
			buf[0] = sIn[ix];
		}
		else if (isspace((unsigned char)sIn[ix]))
		{
			buf[0] = '+';
		}
		else
		{
			buf[0] = '%';
			buf[1] = toHex((unsigned char)sIn[ix] >> 4);
			buf[2] = toHex((unsigned char)sIn[ix] % 16);
		}
		sOut += (char *)buf;
	}
	return sOut;
};

NS_XIANYOU_END
