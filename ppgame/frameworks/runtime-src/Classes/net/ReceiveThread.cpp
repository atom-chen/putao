#include "ReceiveThread.h"
#include "MessageDispatcher.h"
#include "cocos2d.h"
#include "SocketThread.h"
#include "zlib.h"

NS_XIANYOU_BEGIN

#define RECV_LEN 2048

ReceiveThread* ReceiveThread::m_pInstance = new ReceiveThread; 

ReceiveThread* ReceiveThread::GetInstance(){	
	return m_pInstance;
}

ReceiveThread::ReceiveThread(void)
{
	this->m_msglistener = NULL;
	started = false;
	detached = false;
	isRunning = false;
}

ReceiveThread::~ReceiveThread(void)
{
	stop();
}

int ReceiveThread::start(void * param){    	
	int errCode = 0;
	do{
		pthread_attr_t attributes;
		errCode = pthread_attr_init(&attributes);
		CC_BREAK_IF(errCode!=0);
		errCode = pthread_attr_setdetachstate(&attributes, PTHREAD_CREATE_DETACHED);
		if (errCode!=0) {
			pthread_attr_destroy(&attributes);
			break;
		}		
		errCode = pthread_create(&handle, &attributes,threadFunc,this);
		started = true; 
	}while (0);
	return errCode;
} 

void* ReceiveThread::threadFunc(void *arg){
	//pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);        
	//pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS,   NULL);   
	ReceiveThread* thred = (ReceiveThread*)arg;
	BSDSocket* csocket = SocketThread::GetInstance()->getSocket();
	csocket->signal_opt();
	MessageDispatcher* msd = MessageDispatcher::getInstance();
	struct timeval timeout = { 18, 0 };
	struct timeval timeoutse = { 1 ,0 };
	bool result;
	int selectResult = 0;
	thred->isRunning = true;
	//CCLOG("threadFunc");

	while (true){
	threadStartPos:
		if (msd->getNetState() == xianyou::ARPG_NET_STATE::CONNECTED)
		{
			selectResult = csocket->Select(&timeout);

			if (selectResult == -2)
			{
				char recvBuf[RECV_LEN];
				int recvLen = csocket->Recv(recvBuf, RECV_LEN, 0);
				if (recvLen <= 0)
				{
					CCLOG("disconnect: recv len <= 0");
					msd->setNetState(xianyou::ARPG_NET_STATE::ERROR_RECV);
					goto threadStartPos;
				}
				msd->getPacketHelper()->pushRecvData((BYTE*)recvBuf, recvLen);
			}
			else if (selectResult <= 0)
			{
				CCLOG("disconnect: selectResult == %d", selectResult);
				msd->setNetState(xianyou::ARPG_NET_STATE::CLOSED_BY_SERVER);
				goto threadStartPos;
			}
		}
		else
		{
			CCLOG("not connected");
			select(0, NULL, NULL, NULL, &timeoutse);
		}
	}

	thred->isRunning = false;
	return NULL;
}

void ReceiveThread::stop(){
	if (started && !detached) { 
		CCLOG("stop");
		//pthread_cancel(handle);
		//pthread_detach(handle); 
		detached = true; 
		isRunning = false;
	}
}

/*
void * ReceiveThread::wait()
{
	void * status = NULL;
	if (started && !detached) { 
		pthread_join(handle, &status); 
	}
	return status;
}

void ReceiveThread::sleep(int secstr)
{
	timeval timeout = { secstr/1000, secstr%1000 }; 
	select(0, NULL, NULL, NULL, &timeout);
}

void ReceiveThread::detach()
{
	if (started && !detached) {
		pthread_detach(handle);
	} 
	detached = true;
}
*/

NS_XIANYOU_END
