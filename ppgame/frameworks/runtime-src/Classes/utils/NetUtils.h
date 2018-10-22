#ifndef __NETUTILS_H__
#define __NETUTILS_H__

#ifndef HTONS
#if 0
#define HTONS(A) (A)
#define NTOHS(a) (a) 
#define HTONL(A) (A)
#define NTOHL(a) (a)
#else
#define HTONS(A)  ((((A) & 0xff00) >> 8) | ((A) & 0x00ff) << 8)   
#define NTOHS(a)    mf_htons(a)
#define HTONL(A)  ((((A) & 0xff000000) >> 24) | (((A) & 0x00ff0000) >> 8) | (((A) & 0x0000ff00) << 8) | (((A) & 0x000000ff) << 24))
#define NTOHL(a)     mf_htonl(a)
#endif
#endif

bool isEndianLittle();
void readByte(unsigned char** pBuffer, unsigned char* d);
void readWord(unsigned char** pBuffer, unsigned short* d);
void readDword(unsigned char** pBuffer, unsigned int* d);
void readString(unsigned char** pBuffer, char** pStr);
void readBuffer(unsigned char** pBuffer, unsigned char*dest, int size);

void writeByte(unsigned char** pBuffer, unsigned char d);
void writeWord(unsigned char** pBuffer, unsigned short d);
void writeDword(unsigned char** pBuffer, unsigned int d);
void writeString(unsigned char** pBuffer, const char* str);
void writeBuffer(unsigned char** pBuffer, unsigned char* p, int size);

unsigned int transToAddrFromIP(char* szIP);
char* transToIPFromAddr(unsigned int dwIP);


#endif


