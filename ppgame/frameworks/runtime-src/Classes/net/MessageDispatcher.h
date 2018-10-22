#ifndef __CC_MESSAGEDISPATHER_H__
#define __CC_MESSAGEDISPATHER_H__

#include "cocos2d.h"
#include "../xian_you.h"
#include "../serialize/PacketHelper.h"

NS_XIANYOU_BEGIN

#define MAX_CALLBACK_NUM  20
#define PROTO_CALLBACK  0
#define LUA_MEMORY_CALLBACK  1
#define NET_DELAY_CALLBACK  2
#define NET_STATE_CALLBACK  3
#define APK_DOWNLOAD_STATUS  4
#define APK_DOWNLOADIND  5
#define SEG_DOWNLOAD_STATUS  6
#define SEG_DOWNLOADIND  7
#define LUA_TERMINAL_CALL_BACK  8
#define GET_SERVER_LISTS  9

class  MessageDispatcher : public cocos2d::Ref
{
public:
	static MessageDispatcher* getInstance();
	void registerScriptHandler(int type, int nHandler);
	void unregisterScriptHandler(int type);
	// net
	PacketHelper* getPacketHelper(){ return mPacketHelper; }
	bool isNetConnected(std::string name);
	int getConnectedType();
	void startNetWork(const char* ip, int port);
	bool closeNetWork();
	void sentProtoToLua(int len, int module_id, int method_id, const char* text);
	void sendMessageToServer(int len, const char* text);
	int getNetDelay();
	void setNetState(ARPG_NET_STATE state);  //skip lua
	void notifyNetStateToLua(int state);
	int getNetState();
	int notifySeverList(const char* text, int len);
	// others
	std::string callForLua(int type, std::string param); //��Ҫ������дһ�ѽӿڣ�ֱ�ӰѲ����ͷ���������ͬ�Ľӿڷŵ�һ�������ﵼ�����ű�����
	std::string keyOfSomeThing(std::string key, std::string url);

public:
	std::string nowhostip;
private:
	ARPG_NET_STATE _netState;
	int handlerMap[MAX_CALLBACK_NUM];
	bool isInSchedule;
	PacketHelper* mPacketHelper;

};

NS_XIANYOU_END

#endif  //__CC_MESSAGEDISPATHER_H__