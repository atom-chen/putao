#include "NetUtils.h"
#include<string.h>
#include <stdio.h>
#include <stdlib.h>

bool isEndianLittle()
{
	int x = 1;
	if (*(char*)&x == 1)
	{
		return true;
	}
	else
	{
		return false;
	}
}
void readByte(unsigned char** pBuffer, unsigned char* d)
{
	memcpy(d, *pBuffer, 1);
	*pBuffer += 1;
}

void readWord(unsigned char** pBuffer, unsigned short* d)
{
	memcpy(d, *pBuffer, 2);
	if (!isEndianLittle()){
		*d = HTONS(*d);
	}
	*pBuffer += 2;
	
}

void readDword(unsigned char** pBuffer, unsigned int* d)
{
	memcpy(d, *pBuffer, 4);
	if (!isEndianLittle()){
		*d = HTONL(*d);
	}
	*pBuffer += 4;
}

void readString(unsigned char** pBuffer, char** pStr)
{
	*pStr = (char*)*pBuffer;
	*pBuffer += strlen(*pStr) + 1;
}

void readBuffer(unsigned char** pBuffer, unsigned char*dest, int size)
{
	memcpy(dest, *pBuffer, size);
	*pBuffer += size;
}

void writeByte(unsigned char** pBuffer, unsigned char d)
{
	memcpy(*pBuffer, &d, 1);
	*pBuffer += 1;
}

void writeWord(unsigned char** pBuffer, unsigned short d2)
{
	if (!isEndianLittle()){
		d2 = HTONS(d2);
	}
	memcpy(*pBuffer, &d2, 2);
	*pBuffer += 2;
}

void writeDword(unsigned char** pBuffer, unsigned int d4)
{
	if (!isEndianLittle()){
		d4 = HTONL(d4);
	}
	
	memcpy(*pBuffer, &d4, 4);
	*pBuffer += 4;
}

void writeString(unsigned char** pBuffer, const char* str)
{
	int len = strlen(str) + 1;
	memcpy(*pBuffer, str, len);
	*pBuffer += len;
}

void writeBuffer(unsigned char** pBuffer, unsigned char* p, int size)
{
	memcpy(*pBuffer, pBuffer, size);
	*pBuffer += size;
}

unsigned int transToAddrFromIP(char* szIP)
{
	char szSrc[16];
	char *p1, *p2;
	unsigned int n = 3, dwRet;
	unsigned char *p = (unsigned char*)&dwRet;
	strcpy(szSrc, szIP);
	p1 = szSrc;
	p2 = szSrc;
	while(*p2)
	{
		if(*p2 == '.')
		{
			*p2 = 0;
			p[n--] = (unsigned char)atol(p1);
			p1 = p2 + 1;
		}
		++p2;
	}
	p[n] = (unsigned char)atol(p1);
	return dwRet;
}


char* transToIPFromAddr(unsigned int dwIP)
{
	static char szIP[16];
	unsigned char *pIP = NULL;
	pIP = (unsigned char*)&dwIP;
	sprintf(szIP, "%d.%d.%d.%d", pIP[0], pIP[1], pIP[2], pIP[3]);
	return szIP;
}
