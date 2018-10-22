#ifndef __CC_NET_SOCKET_THREAD_H__
#define __CC_NET_SOCKET_THREAD_H__
#include <string> 
#include "BSDSocket.h"
#include "pthread.h"
#include "../xian_you.h"

NS_XIANYOU_BEGIN
class SocketThread
{
public:	
	~SocketThread(void);
	static SocketThread* GetInstance();
	static bool isRunning;

	int start();
	void stop();
	void cleanSocket();
	void closeSocket();
	void setAddr(const char *addr, int pt);
	BSDSocket* getSocket();
	
public:
	BSDSocket csocket;
	std::string ip;
	int port;
	
private:
	pthread_t pid;	
	bool started;
	static void* start_thread(void *);	
	SocketThread(void);
private:
	static SocketThread* m_pInstance;	
};
NS_XIANYOU_END

#endif

