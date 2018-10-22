#ifndef __XIAN_YOU_H__
#define __XIAN_YOU_H__

#include "platform/CCPlatformMacros.h"

#ifdef _MSC_VER
typedef	signed		__int8		kk_int8;
typedef	unsigned	__int8		kk_uint8;
typedef	signed		__int16		kk_int16;
typedef	unsigned	__int16		kk_uint16;
typedef	signed		__int32		kk_int32;
typedef	unsigned	__int32		kk_uint32;
typedef	signed		__int64		kk_int64;
typedef	unsigned	__int64		kk_uint64;
#else
#include <stdint.h>
typedef	int8_t		kk_int8;
typedef	uint8_t		kk_uint8;
typedef	int16_t		kk_int16;
typedef	uint16_t	kk_uint16;
typedef	int32_t		kk_int32;
typedef	uint32_t	kk_uint32;
typedef	int64_t		kk_int64;
typedef	uint64_t	kk_uint64;
#endif

#ifdef __cplusplus
#define NS_XIANYOU_BEGIN	namespace xianyou {
#define NS_XIANYOU_END		}
#define USING_NS_XIANYOU	using namespace xianyou
#else
#define NS_XIANYOU_BEGIN 
#define NS_XIANYOU_END 
#define USING_NS_XIANYOU 
#endif 

namespace xianyou{
	enum ARPG_NET_STATE {
		CONNECTING,
		CONNECTED,
		FAILED,
		CLOSED_BY_SERVER,
		CLOSED,
		TIMEOUT,
		
		ERROR_RECV,
		SEND_FAIL,
	};
}


#endif  // __XIAN_YOU_H__

