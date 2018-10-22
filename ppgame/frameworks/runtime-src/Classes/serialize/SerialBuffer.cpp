#include "SerialBuffer.h"
//#include <string>
//
//
//using namespace std;
//

#define MAX_ALLOC_SIZE 1024 * 1024

CSerialBuffer::CSerialBuffer()
{
	InitParams();
	Alloc( BUFFER_MINLENGTH );
}

CSerialBuffer::CSerialBuffer( DWORD len )
{
	InitParams();
	Alloc( len );
}

CSerialBuffer::CSerialBuffer( const BYTE* buf, DWORD len )
{
	InitParams();
	Copy( buf, len );
}

CSerialBuffer::CSerialBuffer( const CSerialBuffer* buf )
{
	InitParams();
	Copy( buf );
}

CSerialBuffer::CSerialBuffer( const CSerialBuffer& buf )
{
	InitParams();
	Copy( buf );
}

CSerialBuffer::~CSerialBuffer()
{
	Free();
}

DWORD CSerialBuffer::Format( const char* format, ... )
{
	va_list al;
	va_start( al, format );

	DWORD size = ::vsnprintf(NULL, 0, format, al)+1;
	//DWORD size = (DWORD)::_vscprintf( format, al ) + 1;
	Relloc( size );
	Clear( FALSE ); // ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?

	int count = ::vsnprintf( (char*)Buffer(), size, format, al );
	va_end( al );

	ForwardTail( size );

	if( count >= 0 && count < (int)Size() )
		WriteBYTE( 0, (DWORD)count );

	return size;
}

void CSerialBuffer::Destroy( BOOL erase )
{
	Clear( erase );
}

//

void CSerialBuffer::Alloc( DWORD len )
{
	assert( 0 != this );

	m_len = BUFFER_MINLENGTH;
	while( m_len < len )
		m_len <<= 1;

	m_buf = new BYTE[m_len];
	//m_buf = MEMORY_ALLOC_NOPARM( BYTE, m_len, "CSerialBuffer" );

	m_tail = 0;
	m_head = 0;
}

void CSerialBuffer::Free()
{
	assert( 0 != this );

	if( 0 != m_buf )
	{
		delete [] m_buf;
		//MEMORY_FREE( BYTE, m_buf, m_len );

		m_buf = 0;
		m_len = 0;
	}
	m_head = 0;
	m_tail = 0;
}

void CSerialBuffer::Relloc( DWORD len )
{
	assert( 0 != this );

	if( m_len >= len )
		return;

	DWORD oldLen = m_len;


	m_len = BUFFER_MINLENGTH;
	while( m_len < len )
		m_len <<= 1;

	BYTE* pTmp = new BYTE[m_len];
	assert(NULL != pTmp);
	//BYTE* pTmp = MEMORY_ALLOC_NOPARM( BYTE, m_len, "CSerialBuffer" );
	if( NULL != m_buf && NULL != pTmp )
	{
		if( oldLen <= m_len )
			memcpy( pTmp, m_buf, oldLen );

		delete [] m_buf;
		//MEMORY_FREE( BYTE, m_buf, oldLen );
	}

	m_buf = pTmp;
}

inline char DigitalToChar(BYTE num)
{
	if(num <= 9)
		return num+'0';
	if(num >= 10 && num <= 15)
		return num-10+'a';
	assert(false);
	return ' ';
}

inline void	ByteToString(BYTE ch, char* strTxt)
{
	strTxt[0] = '0';
	strTxt[1] = 'x';
	strTxt[2] = DigitalToChar(ch & 0x0f);
	strTxt[3] = DigitalToChar((ch >> 4) & 0x0f);
	strTxt[4] = ' ';
	strTxt[5] = 0;
}

std::string CSerialBuffer::ToHexString() const
{
	std::string strHexString;
	BYTE* buf = Buffer();
	DWORD size = Size();

	for(DWORD i = 0; i < size; i++)
	{
		char strTmp[16];
		ByteToString(buf[i], strTmp);

		strHexString += strTmp;

		if(i % 16 == 15)
			strHexString += "\r\n";
	}

	return strHexString;
}

std::string CSerialBuffer::ToString(int radix) const
{
	std::string strString;
	BYTE* buf = Buffer();
	DWORD size = Size();

	for (DWORD i = 0; i < size; i++)
	{
		char strTmp[16];
		sprintf(strTmp, "%03d ", buf[i]);
		strString += strTmp;
		if (i % 16 == 15)
			strString += "\r\n";
	}

	return strString;
}
