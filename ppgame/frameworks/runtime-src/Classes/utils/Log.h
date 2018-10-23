#ifndef __XLog_H__
#define __XLog_H__

#include "cocos2d.h"
#include <map>
#include <string>

class XLog
{
public:
	XLog();
	~XLog();

	static XLog* getInstance(){
		if(_instance == NULL){
			_instance = new XLog();
		}
		return _instance;
	}

	void saveFile(std::string filepath, std::string filedata);
	void syncSaveFile(std::string filepath, std::string filedata);

	void start();
	void stop();


	void pushLog(std::string log,bool isPrint,bool isWrite);
	void writeLog(std::string log, bool isPrint);
    
protected:
	void workThread();

	std::string getLogPath();
private:
	static XLog* _instance;

	bool isStart;
	std::mutex   logQueueMutex;
	std::thread* writeLogThread;
	std::queue<std::string> logQueue;
};

#endif // __XLog_H__
