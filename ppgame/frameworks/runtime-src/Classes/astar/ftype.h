#ifndef __FTYPE_H__
#define __FTYPE_H__

#include <string.h>


#if __GNUC__
#include <stdint.h>
#endif

#ifdef _MSC_VER
typedef	__int8				int8;
typedef	__int16				int16;
typedef	__int32				int32;
typedef	__int64				int64;
typedef	unsigned __int8		uint8;
typedef	unsigned __int16	uint16;
typedef	unsigned __int32	uint32;
typedef	unsigned __int64	uint64;
#define ALIGN( b,x ) __declspec(align(b)) x

#else

typedef	char				int8;
typedef	short				int16;
typedef	int					int32;
typedef	long long			int64;
typedef	unsigned char		uint8;
typedef	unsigned short		uint16;
typedef	unsigned int		uint32;
typedef	unsigned long long	uint64;

// typedef long           LONG;
#ifndef FALSE
#define FALSE 0
#define TRUE 1
#endif // !FALSE

#define ALIGN( b,_x )   _x __attribute((aligned(b)))

#endif 

#endif//__FTYPE_H__

