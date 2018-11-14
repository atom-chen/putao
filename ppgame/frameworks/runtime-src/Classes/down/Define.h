#ifndef _LUA_DEFINE_H_
#define _LUA_DEFINE_H_
#include "platform/CCPlatformConfig.h"
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
extern "C" {
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC
    
#define TRUE	1
#define FALSE	0
    
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    typedef void                VOID;
    typedef unsigned char		BYTE;
    typedef unsigned short		WORD;
    typedef short               SHORT;
    typedef unsigned int		DWORD;
    typedef	long long			LONGLONG;
    typedef unsigned short		TCHAR;
    typedef long long			SCORE;
    typedef double              DOUBLE;
    typedef int                 LONG;
    typedef int                 INT;
    typedef int                 INT_PTR;
    typedef unsigned int        UINT;
    typedef DWORD               COLORREF;
#else
    typedef void                VOID;
    typedef unsigned char		BYTE;
    typedef unsigned short		WORD;
    typedef short               SHORT;
    typedef unsigned long		DWORD;
    typedef	long long			LONGLONG;
    typedef unsigned short		TCHAR;
    typedef long long			SCORE;
    typedef double              DOUBLE;
    typedef long                LONG;
    typedef int                 INT;
    typedef int                 INT_PTR;
    typedef unsigned int        UINT;
    typedef DWORD               COLORREF;
#endif
    
#else
#ifndef WIN32
    typedef void VOID;
    typedef unsigned char BYTE;
    typedef unsigned short WORD;
    typedef short  SHORT;
    typedef int BOOL;
    typedef unsigned int DWORD;
    typedef double DOUBLE;
    typedef float FLOAT;
    typedef long long SCORE;
    typedef long long __time64_t;
    typedef unsigned short TCHAR, WCHAR;
    typedef long LONG;
    typedef DWORD COLORREF;
    typedef unsigned int UINT;
    
#ifdef __x86_64__
    typedef long long INT_PTR;
#else
    typedef int INT_PTR;
#endif
    
#define TRUE	1
#define FALSE	0
#endif
#endif

#ifndef NULL
#ifdef __cplusplus
#define NULL    0
#else
#define NULL    ((void *)0)
#endif
#endif

#ifdef WIN32
#define FILE_SEPARATOR "\\"
#else
#define FILE_SEPARATOR "/"
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef WIN32
#include <winsock2.h>
inline void sleep_ms(int ms)
{
	Sleep(ms*1000);
}


#else
#include <unistd.h>

inline void sleep_ms(int ms)
{
	usleep(ms * 1000 * 1000);
}
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef SAFE_DELETE
#define SAFE_DELETE(p) { if(p) { delete (p); (p)=NULL; } }
#endif
#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(p) { if(p) { delete[] (p); (p)=NULL; } }
#endif
#ifndef SAFE_RELEASE
#define SAFE_RELEASE(p) { if(p) { (p)->Release(); (p)=NULL; } }
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef WIN32
#define _atoi64(val)     						strtoll(val, NULL, 10)
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static DWORD m_random = 0;

#ifdef WIN32
#include <windows.h>
#else
#include <pthread.h>
#endif
inline DWORD PthreadSelf()
{
#ifdef WIN32
	return GetCurrentThreadId();
#else
	return m_random++;
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef interface
#define interface struct
#endif

#define 	LEN_NETWORK_ID							13									//网卡长度
#define 	LEN_MACHINE_ID							33									//序列长度

#define 	LEN_TYPE								32									//种类长度
#define 	LEN_KIND								32									//类型长度
#define 	LEN_NODE								32									//节点长度
#define 	LEN_PAGE								32									//定制长度
#define 	LEN_SERVER								32									//房间长度
#define 	LEN_PROCESS								32									//进程长度

#define 	TASK_MAX_COUNT							128									//任务数量

#define 	DB_ERROR 								-1  								//处理失败
#define 	DB_SUCCESS 								0  									//处理成功
#define 	DB_NEEDMB 								18 									//处理失败
#define 	DB_PASSPORT								19									//处理失败

#define 	INVALID_ITEM							65535								//无效子项
#define 	LEN_TASK_TEXT							320									//任务文本
#define 	MAX_PATH          						260									//地址长度

#define		INVALID_BYTE							((BYTE)(0xff))						//无效数值
#define 	INVALID_WORD							((WORD)(0xffff))					//无效数值
#define 	INVALID_DWORD							((DWORD)(0xffffffff))				//无效数值

#define 	CountArray(Array) 						(sizeof(Array)/sizeof(Array[0]))	//数组个数

#define 	INTERFACE_OF(DST,SRC)			  		( SRC != NULL && NULL!=dynamic_cast<DST *>(SRC))	//转换判断

#define 	EMPTY_CHAR(p)							(p==NULL||p[0]=='\0')				//空字符

#define		LUA_BREAK(cond)							 if(cond) break						//打断

#define 	REV_CONTINUE							0									//保持连接
#define 	REV_CLOSE								-1									//关闭连接


#define 	MSG_SOCKET_CONNECT						1									//网络链接
#define 	MSG_SOCKET_DATA							2									//网络数据
#define		MSG_SOCKET_CLOSED						3									//网络关闭
#define 	MSG_SOCKET_ERROR						4									//网络错误
#define 	MSG_HTTP_DOWN							5 									//网络下载
#define     MSG_UN_ZIP                              6                                   //解压缩

#define 	DOWN_PRO_INFO							1
#define 	DOWN_COMPELETED							3
#define 	DOWN_ERROR_PATH							4 									//路径出错
#define 	DOWN_ERROR_CREATEFILE					5 									//文件创建出错
#define 	DOWN_ERROR_CREATEURL					6 									//创建连接失败
#define 	DOWN_ERROR_NET		 					7 									//下载失败
#define     DOWN_ERROR_UNZIP 						8

#define 	PATH_DIR								"LYGame"

//授权信息
#ifdef 	WIN32
const TCHAR szCompilation[]=TEXT("8C3AC3BC-EB40-462f-B436-4BBB141FC7F9");
#else
#define  szCompilation  "8C3AC3BC-EB40-462f-B436-4BBB141FC7F9" //@compilation
#endif
#ifdef __cplusplus
}
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#endif
