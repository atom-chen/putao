#ifndef _PACKETHELPER_H_
#define _PACKETHELPER_H_

#include "../serialize/SerialBuffer.h"
#include "cocos2d.h"
#include <map>
#include <string>
#include "../utils/Log.h"

#define MSG_HEADER_SIZE 11

class PacketHelper
{

public:
	PacketHelper();
	~PacketHelper();
public:

	void pushRecvData(BYTE* dataBuf, DWORD dataSize);
	
	void pushRecvPacket(CSerialBuffer packet);
	bool popRecvPacket(CSerialBuffer& packet);

	void encryptSendPacket(CSerialBuffer& packet);

	void encrypt(unsigned char *pBuffer, int nSize, unsigned char bKey)
	{
		int i;
		for (i = 0; i<nSize; ++i)
			pBuffer[i] = ((pBuffer[i]) ^ bKey) + bKey;
	}

	void decrypt(unsigned char *pBuffer, int nSize, unsigned char bKey)
	{
		int i;
		for (i = 0; i<nSize; ++i)
			pBuffer[i] = (pBuffer[i] - bKey) ^ bKey;
	}

	

private:
	BYTE	m_cbSendRound;
	BYTE	m_cbRecvRound;
	WORD	m_dwSendXorKey;
	WORD	m_dwSendPacketCount;
	WORD	m_dwRecvPacketCount;
	WORD	m_dwRecvXorKey;

	std::list<CSerialBuffer>	m_RecvPackets;
	CSerialBuffer	m_RecvDataBuffer;

	std::mutex   m_RecvDataBufferMutex;
	std::mutex   m_RecvPacketMutex;

};

#endif
