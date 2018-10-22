#include "PacketHelper.h"
#include "utils/NetUtils.h"
#ifndef WIN32
//#include <uuid/uuid.h>
#endif
PacketHelper::PacketHelper(){

}
PacketHelper::~PacketHelper(){
	//log("%s excute", __FUNCTION__);
	m_RecvDataBuffer.Clear();
	for (auto packet : m_RecvPackets){
		packet.Clear();
	}
}


void PacketHelper::pushRecvData(BYTE* dataBuf, DWORD dataSize){
	m_RecvDataBufferMutex.lock();
	/*if (dataSize > 80000){
		log("bufferSize:%d dataSize:%d", m_RecvDataBuffer.Size(), dataSize);
	}*/
	m_RecvDataBuffer.Append(dataBuf,dataSize);
	do{
		int nSize = (int)m_RecvDataBuffer.Size();
		if (nSize < MSG_HEADER_SIZE)
			break;

		BYTE* buf = m_RecvDataBuffer.Buffer();
		WORD bodySize = 0;
		readWord(&buf, &bodySize);
		//log("bufferSize:%d bodySize:%d", nSize, bodySize);
		if (nSize < MSG_HEADER_SIZE + bodySize)
			break;

		CSerialBuffer packet(m_RecvDataBuffer.Buffer(), MSG_HEADER_SIZE + bodySize);
		m_RecvDataBuffer.ForwardHead(MSG_HEADER_SIZE + bodySize);

		
		//Ω‚√‹
		//WORD dwDPacketSize = CrevasseBufferEX(packet.Buffer(), packet.Size());
		buf = packet.Buffer();

		bodySize = 0;
		readWord(&buf, &bodySize);

		
		BYTE bVersion;
		readByte(&buf, &bVersion);
		WORD wCmd = 0;
		readWord(&buf, &wCmd);
		BYTE bKey;
		readByte(&buf, &bKey);

		BYTE* body = packet.Buffer() + MSG_HEADER_SIZE;
		decrypt(body, bodySize, bKey);

		CSerialBuffer DPacket(packet.Buffer(), packet.Size());

		pushRecvPacket(DPacket);
		
	} while (true);
	m_RecvDataBufferMutex.unlock();
	//XLog::getInstance()->pushLog("PacketHelper::pushRecvData end");
	//log("%s->m_RecvDataBuffer:%d", __FUNCTION__, m_RecvDataBuffer.BufferSize());
}

void PacketHelper::pushRecvPacket(CSerialBuffer packet){
	//XLog::getInstance()->pushLog("PacketHelper::pushRecvPacket began");
	m_RecvPacketMutex.lock();
	m_RecvPackets.push_back(packet);
	m_RecvPacketMutex.unlock();
	//XLog::getInstance()->pushLog("PacketHelper::pushRecvPacket end");
}
bool PacketHelper::popRecvPacket(CSerialBuffer& packet){
	//XLog::getInstance()->pushLog("PacketHelper::popRecvPacket began");
	bool ret = false;
	m_RecvPacketMutex.lock();
	if (m_RecvPackets.size() > 0){
		packet.Append(m_RecvPackets.front().Buffer(), m_RecvPackets.front().Size());
		m_RecvPackets.pop_front();
		ret = true;
	}
	m_RecvPacketMutex.unlock();
	//XLog::getInstance()->pushLog("PacketHelper::popRecvPacket end");
	return ret;
}

void PacketHelper::encryptSendPacket(CSerialBuffer& packet){
	//º”√‹
	DWORD dwPacketSize = packet.Size();
	BYTE gamePacket[16*1024];
	memcpy(gamePacket,packet.Buffer(),dwPacketSize);
	
	BYTE* buf = gamePacket;

	WORD bodySize = 0;
	readWord(&buf, &bodySize);
	BYTE bVersion;
	readByte(&buf, &bVersion);
	WORD wCmd = 0;
	readWord(&buf, &wCmd);
	BYTE bKey;
	readByte(&buf, &bKey);

	BYTE* body = gamePacket + MSG_HEADER_SIZE;
	encrypt(body, bodySize, bKey);


	packet.Copy(gamePacket, dwPacketSize);
}
