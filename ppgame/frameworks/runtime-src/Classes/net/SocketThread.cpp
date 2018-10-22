#include "SocketThread.h"
#include "cocos2d.h"
#include "ReceiveThread.h"
#include "MessageDispatcher.h"
USING_NS_CC;

NS_XIANYOU_BEGIN

static std::vector<std::string> strsplit(std::string str,std::string pattern)
{
	std::string::size_type pos;
	std::vector<std::string> result;
	str += pattern;  //扩展字符串以方便操作
	int size = str.size();

	for(int i=0; i<size; i++)
	{
		pos=str.find(pattern,i);
		if(pos<size)
		{
			std::string s=str.substr(i,pos-i);
			result.push_back(s);
			i=pos+pattern.size()-1;
		}
	}
	return result;
}  

static bool isIPAddress(const char *s)  
{  
	const char *pChar;
	bool rv = true;
	int tmp1, tmp2, tmp3, tmp4, i;

	while( true )
	{
		i = sscanf(s, "%d.%d.%d.%d", &tmp1, &tmp2, &tmp3, &tmp4);

		if( i != 4 )
		{
			rv = false;
			break;
		}

		if( (tmp1 > 255) || (tmp2 > 255) || (tmp3 > 255) || (tmp4 > 255) )  
		{  
			rv = false;
			break;
		}  

		for( pChar = s; *pChar != 0; pChar++ )  
		{
			if( (*pChar != '.')
				&& ((*pChar < '0') || (*pChar > '9')) )
			{
				rv = false;
				break;
			}
		}
		break;
	}

	return rv;
}

SocketThread::SocketThread(void) : started(false)
{
}

SocketThread::~SocketThread(void)
{
	if (m_pInstance != NULL){
		delete m_pInstance;
	}
}

int SocketThread::start()
{    	
	int errCode = 0;
	do{
		pthread_attr_t tAttr;
		errCode = pthread_attr_init(&tAttr);
		CC_BREAK_IF(errCode!=0);
		errCode = pthread_attr_setdetachstate(&tAttr, PTHREAD_CREATE_DETACHED);
		if (errCode!=0) {
			pthread_attr_destroy(&tAttr);
			break;
		}		
		errCode = pthread_create(&pid,&tAttr,start_thread,this);
		isRunning = true;
		started = true;
	}while (0);
	return errCode;
} 


void* SocketThread::start_thread(void *arg)
{  
	isRunning = true;
	
	SocketThread* thred = (SocketThread*)arg;
	thred->csocket.Close();
	thred->csocket.Init();
	
	bool iscon = false;
	MessageDispatcher::getInstance()->setNetState(xianyou::ARPG_NET_STATE::CONNECTING);
	
	MessageDispatcher::getInstance()->nowhostip = thred->ip;

	std::vector<std::string> iplist = strsplit(thred->ip,"%%");
	iscon=thred->csocket.ConnectIPV6_IPV4(iplist[0].c_str(),thred->port);

	if(!ReceiveThread::GetInstance()->isRunning)
	{
      ReceiveThread::GetInstance()->start();
	}
	
	if(iscon){
		CCLOG("conection");
		MessageDispatcher::getInstance()->setNetState(xianyou::ARPG_NET_STATE::CONNECTED);
	}else{
		CCLOG("conection fial");
		MessageDispatcher::getInstance()->setNetState(xianyou::ARPG_NET_STATE::FAILED);
	}	
	isRunning = false;
	return NULL;                                                                                    
}

BSDSocket* SocketThread::getSocket()
{
	return &this->csocket;
}

bool SocketThread::isRunning = false;
SocketThread* SocketThread::m_pInstance = new SocketThread; 
SocketThread* SocketThread::GetInstance()
{	
	return m_pInstance;
}

void SocketThread::setAddr(const char *addr,int pt)
{
	this->ip = std::string(addr);
	this->port = pt;
}

void SocketThread::cleanSocket()
{
	this->csocket.Clean();
}

void SocketThread::closeSocket()
{
	this->csocket.Close();
}

void SocketThread::stop()
{
	if(started)
	{
		//pthread_cancel(pid);
		//pthread_detach(pid); 
		started = false;
		xianyou::MessageDispatcher::getInstance()->setNetState(xianyou::ARPG_NET_STATE::CLOSED);
	}
}

NS_XIANYOU_END
