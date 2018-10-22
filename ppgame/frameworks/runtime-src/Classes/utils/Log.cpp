

#include "Log.h"
#include <map>
#include <string>
#ifndef WIN32
#include <unistd.h> 
#endif
USING_NS_CC;

XLog* XLog::_instance = NULL;
XLog::XLog(){
	isStart = false;
}

XLog::~XLog(){

}

void XLog::start(){
	isStart = true;
	writeLogThread = new std::thread(&XLog::workThread, this);
}

void XLog::saveFile(std::string filepath, std::string filedata)
{
	FILE *file = NULL;
	file = fopen(filepath.c_str(), "w+");
	if (!file)
		return;
	fwrite(filedata.c_str(), filedata.size(), 1, file);
	fclose(file);
}

void XLog::syncSaveFile(std::string filepath, std::string filedata)
{
	std::thread th = std::thread(std::bind(&XLog::saveFile, this, filepath, filedata));
	th.join();
}

void XLog::stop(){
	isStart = true;
}

void XLog::workThread(){
	while (isStart)
	{
		if (logQueue.size() > 0){
			logQueueMutex.lock();
			std::string log = logQueue.front();
			logQueue.pop();
			logQueueMutex.unlock();
			writeLog(log,false);
		}
		else{
#ifdef WIN32 
			_sleep(100);
#else
			usleep(100);
#endif
		}
	}
}

void XLog::writeLog(std::string logTxt,bool isPrint){

	if (isPrint){
	    const char* text = logTxt.c_str();
		log("%s",text);
		//log("test");
	}

	FILE *file = NULL;
	file = fopen(getLogPath().c_str(), "a");
	if (!file)
		return;
	fwrite(logTxt.c_str(), logTxt.size(), 1, file);
	fclose(file);
}

void XLog::pushLog(std::string logTxt,bool isPrint, bool isWrite){

	struct timeval tv;
#ifdef _WIN32
	struct tm tm;
	time_t clock;
	SYSTEMTIME wtm;
	GetLocalTime(&wtm);
	tm.tm_year     = wtm.wYear - 1900;
	tm.tm_mon = wtm.wMonth - 1;
	tm.tm_mday = wtm.wDay;
	tm.tm_hour = wtm.wHour;
	tm.tm_min = wtm.wMinute;
	tm.tm_sec = wtm.wSecond;
	tm.tm_isdst = -1;
	clock = mktime(&tm);
	tv.tv_sec = clock;
	tv.tv_usec = wtm.wMilliseconds * 1000;
#else
	gettimeofday(&tv, NULL);
#endif
	struct tm *tm1;
	time_t totalSec = (time_t)tv.tv_sec;
	tm1 = localtime(&totalSec);
	int year = tm1->tm_year + 1900;
	int month = tm1->tm_mon + 1;
	int day = tm1->tm_mday;
	int hour = tm1->tm_hour;
	int minute = tm1->tm_min;
	int second = tm1->tm_sec;

	std::string szText = StringUtils::format("[%04d-%02d-%02d %02d:%02d:%02d.%d] %s",
		year, month, day, hour, minute, second, tv.tv_usec, logTxt.c_str());
	
	if (isPrint){
		const char* text = szText.c_str();
        log("%s",text);
	}
	
	if (!isStart){
		if (isWrite){
			writeLog(szText, false);
		}
		
	}
	else{
		if (isWrite){
			logQueueMutex.lock();
			logQueue.push(szText);
			logQueueMutex.unlock();
		}
	}
}

std::string XLog::getLogPath(){
	struct tm *tm;
	time_t timer = time(NULL);
	tm = localtime(&timer);
	int year = tm->tm_year + 1900;
	int month = tm->tm_mon + 1;
	int day = tm->tm_mday;
	//int hour = tm->tm_hour;
	//int minute = tm->tm_min;
	//int second = tm->tm_sec;

	char   szPath[512];
	sprintf(szPath, "%s/log-%04d-%02d-%02d.txt",FileUtils::getInstance()->getWritablePath().c_str(), year, month, day);

	return szPath;
}

