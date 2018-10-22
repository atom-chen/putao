#ifndef _SERIALBUFFER_H_
#define _SERIALBUFFER_H_


#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <list>
#include <vector>
#include <map>
#include <set>
#include <string>
#include <string.h>
#include <stddef.h>
#include <stdarg.h>
#include <math.h>
#include <algorithm>


#ifdef WIN32
#include <winsock2.h>
#include <windows.h>
#include <process.h>
#else
#include <pthread.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <ctype.h>
#include <sys/time.h>
//#include <sys/dir.h>
//#include <sys/epoll.h>
//#include <uuid/uuid.h>
//#include <iconv.h>
#include <signal.h>
#include <semaphore.h>
#endif

// 数据类型
#ifndef WIN32
typedef unsigned int        DWORD;
typedef int                 BOOL;
typedef unsigned char       BYTE;
typedef unsigned short      WORD;
typedef wchar_t				WCHAR;
typedef unsigned int        UINT;
typedef long long        INT64;
typedef unsigned long long        UINT64;

#endif

#define FALSE   0
#define TRUE    1

using namespace std;

#define BUFFER_MINLENGTH		8


//字符串特殊处理的CSerialBuffer2

class CSerialBuffer
{
public:
	CSerialBuffer();
	CSerialBuffer( DWORD len );
	CSerialBuffer( const BYTE* buf, DWORD len );
	CSerialBuffer( const CSerialBuffer* buf );
	CSerialBuffer( const CSerialBuffer& buf );
	virtual ~CSerialBuffer();

	virtual void Destroy( BOOL erase = FALSE);


	inline DWORD	Size() const;
	inline DWORD	BufferSize() const;


	inline void		Resize( DWORD dwNewSize, BOOL bClearData = TRUE );

	DWORD			Format( const char* format, ... );

	inline void		ForwardHead( DWORD movelen );
	inline void		BackwardHead( DWORD movelen );
	inline void		ForwardTail( DWORD movelen );
	inline void		BackwardTail( DWORD movelen );
	inline DWORD	HeadPos() const;
	inline DWORD	TailPos() const;

	inline DWORD	OrdinalFind( BYTE value, DWORD afterhead = 0 ) const;
	inline DWORD	OrdinalFind( WCHAR value, DWORD afterhead = 0 ) const;


	inline BOOL		Read( BYTE* buf, DWORD len, DWORD afterhead = 0 ) const;
	inline BOOL		Write( BYTE* buf, DWORD len, DWORD afterhead = 0 );
	inline void		Clear( BOOL erase = FALSE );
	inline BYTE*	Buffer() const;

	//template<class T>
	//const T* Fetch( int nPos = 0 ) const
	//{
	//	assert( Size() >= (DWORD)( nPos + sizeof(T) ) ); // ???????????????????????????????????????

	//	if( Size() < (DWORD)( nPos + sizeof(T) ) )
	//		return NULL;

	//	return (T*)( Buffer() + nPos );
	//}

	inline void			Copy( const BYTE* buf, DWORD len );
	inline void			Copy( const char* buf );
	inline void			Copy( const CSerialBuffer* buf );
	inline void			Copy( const CSerialBuffer& buf );

	inline BYTE			ReadBYTE( DWORD afterhead = 0 ) const;
	inline WORD			ReadWORD( DWORD afterhead = 0 ) const;
	inline DWORD		ReadDWORD( DWORD afterhead = 0 ) const;
	inline UINT64		ReadUINT64( DWORD afterhead = 0 ) const;
	inline float		ReadFloat( DWORD afterhead = 0 ) const;
	inline double		ReadDouble( DWORD afterhead = 0 ) const;
	inline string		ReadString( DWORD afterhead = 0 ) const;

	inline BOOL			WriteBYTE( BYTE value, DWORD afterhead = 0 );
	inline BOOL			WriteWORD( WORD value, DWORD afterhead = 0 );
	inline BOOL			WriteDWORD( DWORD value, DWORD afterhead = 0 );
	inline BOOL			WriteUINT64( UINT64 value, DWORD afterhead = 0 );
	inline BOOL			WriteFloat( float value, DWORD afterhead = 0 );
	inline BOOL			WriteDouble( double value, DWORD afterhead = 0 );
	inline BOOL			WriteString( const string& value, DWORD afterhead = 0 );


	inline CSerialBuffer&	Append( const BYTE* buf, DWORD len );
	inline CSerialBuffer&	Append( const CSerialBuffer* buf );
	inline CSerialBuffer&	Append( const CSerialBuffer& buf );
	inline CSerialBuffer&	Append( const char* buf );


	inline DWORD			Popup( BYTE* buf, DWORD len );

	inline int		Compare(const BYTE* buf, DWORD dwBufLen);


	inline BOOL				operator==( const CSerialBuffer& buf );
	inline BOOL				operator!=( const CSerialBuffer& buf );

	inline CSerialBuffer&	operator=( const CSerialBuffer* buf );
	inline CSerialBuffer&	operator=( const CSerialBuffer& buf );
	inline CSerialBuffer&	operator=( const char* buf );

	inline CSerialBuffer&	operator+=( const CSerialBuffer* buf );
	inline CSerialBuffer&	operator+=( const CSerialBuffer& buf );
	inline CSerialBuffer&	operator+=( const char* buf );

	inline CSerialBuffer&	operator-=( DWORD len );


	inline CSerialBuffer&	operator<<( BYTE value );
	inline CSerialBuffer&	operator<<( WORD value );
	inline CSerialBuffer&	operator<<( long value );
	inline CSerialBuffer&	operator<<( DWORD value );
	inline CSerialBuffer&	operator<<( UINT64 value );
	inline CSerialBuffer&	operator<<( float value );
	inline CSerialBuffer&	operator<<( double value );
	inline CSerialBuffer&	operator<<( int value );
	inline CSerialBuffer&	operator<<( bool value );
	inline CSerialBuffer&	operator<<( const string& value );
	inline CSerialBuffer&	operator<<( INT64 value );

	inline CSerialBuffer&	operator<<( const char* value );

	inline CSerialBuffer&	operator<<( const CSerialBuffer& value );
	inline CSerialBuffer&	operator<<( const CSerialBuffer* value );

	// popup????????????
	inline CSerialBuffer&	operator>>( char& value );
	inline CSerialBuffer&	operator>>( short& value );
	inline CSerialBuffer&	operator>>( BYTE& value );
	inline CSerialBuffer&	operator>>( WORD& value );
	inline CSerialBuffer&	operator>>( long& value );
	inline CSerialBuffer&	operator>>( DWORD& value );
	inline CSerialBuffer&	operator>>( UINT64& value );
	inline CSerialBuffer&	operator>>( float& value );
	inline CSerialBuffer&	operator>>( double& value );
	inline CSerialBuffer&	operator>>( string& value );
	inline CSerialBuffer&   operator>>( int&  value );
	inline CSerialBuffer&   operator>>( bool&  value );
	inline CSerialBuffer&   operator>>( CSerialBuffer& buf );
	inline CSerialBuffer&	operator>>( INT64& value );

	/*template<class _Ty>
	inline CSerialBuffer&	operator>>( std::list<_Ty>& value)
	{
		DWORD dwSize;
		_Ty temp;
		*this>>dwSize;
		for( DWORD i = 0; i < dwSize; i++)
		{
			*this>>temp;
			value.push_back(temp);
		}
		return *this;
	}

	template<class _Ty>
	inline CSerialBuffer&	operator>>( std::vector<_Ty>& value)
	{
		DWORD dwSize;
		_Ty temp;
		*this>>dwSize;
		for( DWORD i = 0; i < dwSize; i++)
		{
			*this>>temp;
			value.push_back(temp);
		}
		return *this;
	}

	template<class _Key, class _Ty>
	inline CSerialBuffer&	operator>>( std::map<_Key, _Ty>& value)
	{
		DWORD dwCount = 0;
		*this>>dwCount;
		for(DWORD i = 0; i < dwCount; i++)
		{
			_Key k;
			_Ty t;
			*this>>k;
			*this>>t;

			value[k] = t;
		}
		return *this;
	}*/

	std::string	ToHexString() const;		// ???????????????×a????????????6????????????????·???
	std::string	ToString(int radix) const;		// ???????????????×a????????????6????????????????·???
private:
	inline void			InitParams();		// ??????ê??????????????±????????????
	void				Alloc( DWORD len ); // ?????????????????
	void				Free();				// ???????????????????????
	void				Relloc( DWORD len );// ??????????·???????????????????????????-??????????????????
	inline void			CheckRemainder();	// ?????????í·?2????·???????μ?????????????μ????????????????????????

private:
	DWORD			m_len;	// buffer???ü3?????????
	DWORD			m_head; // ?′ê1????μ?????????????????,???óμ???0???????????ú????ê?????????????
	DWORD			m_tail;	// ??????ê1????μ?????????????????
	BYTE*			m_buf;	// ?????????????????????×μ????·
};


inline DWORD CSerialBuffer::Size() const
{
	if(m_tail < m_head)
		return 0;

	return m_tail - m_head;
}

inline DWORD CSerialBuffer::BufferSize() const
{
	return m_len;
}

inline void CSerialBuffer::BackwardHead( DWORD movelen )
{
	if( movelen >= m_head )
		m_head = 0;
	else
		m_head -= movelen;
}

inline void CSerialBuffer::ForwardTail( DWORD movelen )
{
	if( movelen > m_len - m_tail )
		m_tail = m_len;
	else
		m_tail += movelen;
}

inline void CSerialBuffer::ForwardHead( DWORD movelen )
{
	if( movelen >= Size() )
		Clear( FALSE );
	else
		m_head += movelen;
}

inline void CSerialBuffer::BackwardTail( DWORD movelen )
{
	if( movelen >= Size() )
		Clear( FALSE );
	else
		m_tail -= movelen;
}

inline DWORD CSerialBuffer::OrdinalFind( BYTE value, DWORD afterhead/*=0*/  ) const
{
	DWORD index = afterhead;
	DWORD size = Size();
	BYTE* tmp = Buffer();
	for( ; index < size; ++index  )
	{
		if( value == tmp[index] )
			return index;
	}

	return (DWORD)-1;
}

inline DWORD CSerialBuffer::OrdinalFind( WCHAR value, DWORD afterhead ) const
{
	DWORD index = 0;
	DWORD size = (Size()-afterhead)/sizeof(WCHAR);
	WCHAR* tmp = (WCHAR*)(Buffer()+afterhead);
	for( index = 0; index < size; ++index  )
	{
		if( value == tmp[index] )
			return index*sizeof(WCHAR)+afterhead;
	}

	return (DWORD)-1;
}

inline DWORD CSerialBuffer::HeadPos() const
{
	return m_head;
}

inline DWORD CSerialBuffer::TailPos() const
{
	return m_tail;
}

inline BOOL CSerialBuffer::Read( BYTE* buf, DWORD len, DWORD afterhead/*=0*/ ) const
{
	assert( NULL != buf );

	if( afterhead + len > Size() )
		return FALSE;

	BYTE* readed = m_buf + m_head + afterhead;
	memcpy( buf, readed, len );

	return TRUE;
}

inline BOOL CSerialBuffer::Write( BYTE* buf, DWORD len, DWORD afterhead/*=0*/ )
{
	assert( NULL != buf );

	if( afterhead + len > Size() )
		return FALSE;

	BYTE* writed = m_buf + m_head + afterhead;
	memcpy( writed, buf, len );

	return TRUE;
}

inline BYTE* CSerialBuffer::Buffer() const
{
	return m_buf + m_head;
}

inline BYTE CSerialBuffer::ReadBYTE( DWORD afterhead/*=0*/ ) const
{
	BYTE value = (BYTE)-1;
	Read( (BYTE*)&value, sizeof(BYTE), afterhead );

	return value;
}

inline WORD CSerialBuffer::ReadWORD( DWORD afterhead/*=0*/ ) const
{
	WORD value = (WORD)-1;
	Read( (BYTE*)&value, sizeof(WORD), afterhead );

	return value;
}

inline DWORD CSerialBuffer::ReadDWORD( DWORD afterhead/*=0*/ ) const
{
	DWORD value = (DWORD)-1;
	Read( (BYTE*)&value, sizeof(DWORD), afterhead );

	return value;
}

inline UINT64 CSerialBuffer::ReadUINT64( DWORD afterhead/*=0*/ ) const
{
	UINT64 value = (UINT64)-1;
	Read( (BYTE*)&value, sizeof(UINT64), afterhead );

	return value;
}

inline float CSerialBuffer::ReadFloat( DWORD afterhead/*=0*/ ) const
{
	float value = 0.0f;
	Read( (BYTE*)&value, sizeof(float), afterhead );

	return value;
}

inline double CSerialBuffer::ReadDouble( DWORD afterhead/*=0*/ ) const
{
	double value = 0.0;
	Read( (BYTE*)&value, sizeof(double), afterhead );

	return value;
}

inline string CSerialBuffer::ReadString( DWORD afterhead/*=0*/ ) const
{
	// ????????????'\0'????????
	/*if( OrdinalFind( (BYTE)0, afterhead ) >= Size() )
		return "";*/

	WORD wlen = 0;
	Read( (BYTE*)&wlen, sizeof(WORD), afterhead );
	if(wlen == 0)
		return "";
	else
	{
		string value( (char*)( Buffer() + sizeof(WORD) + afterhead ) );
		return value;
	}
}

inline BOOL CSerialBuffer::WriteBYTE( BYTE value, DWORD afterhead/*=0*/ )
{
	return Write( (BYTE*)&value, sizeof(BYTE), afterhead );
}

inline BOOL CSerialBuffer::WriteWORD( WORD value, DWORD afterhead/*=0*/ )
{
	return Write( (BYTE*)&value, sizeof(WORD), afterhead );
}

inline BOOL CSerialBuffer::WriteDWORD( DWORD value, DWORD afterhead/*=0*/ )
{
	return Write( (BYTE*)&value, sizeof(DWORD), afterhead );
}

inline BOOL CSerialBuffer::WriteUINT64( UINT64 value, DWORD afterhead/*=0*/ )
{
	return Write( (BYTE*)&value, sizeof(UINT64), afterhead );
}

inline BOOL CSerialBuffer::WriteFloat( float value, DWORD afterhead/*=0*/ )
{
	return Write( (BYTE*)&value, sizeof(float), afterhead );
}

inline BOOL CSerialBuffer::WriteDouble( double value, DWORD afterhead/*=0*/ )
{
	return Write( (BYTE*)&value, sizeof(double), afterhead );
}

inline BOOL CSerialBuffer::WriteString( const string& value, DWORD afterhead/*=0*/ )
{
	WORD wlen = value.size();
	if(!Write((BYTE*)&wlen, sizeof(WORD), afterhead))
		return FALSE;

	return Write( (BYTE*)value.c_str(), (DWORD)value.size() + 1, afterhead+sizeof(WORD) );
}

inline CSerialBuffer& CSerialBuffer::Append( const BYTE* buf, DWORD len )
{
	if( 0 == len )
		return *this;

	// ??????ê￡?????????2????????????????????1?????????????????????
	if( m_len - m_tail < len )
	{
		int nSize = (int)Size();
		if(m_len-nSize < len)
		{
			// ????????????
			Resize( m_len + len, FALSE );
		}
		else
		{
			// ????????
			memmove(m_buf, Buffer(), nSize);
			m_head = 0;
			m_tail = nSize;
		}
	}

	// ??????????????????????????????
	memcpy( m_buf + m_tail, buf, len );
	m_tail += len; // ????????????±???

	assert( m_tail <= m_len );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::Append( const CSerialBuffer* buf )
{
	assert( NULL != buf );

	if( NULL == buf )
		return *this;

	return Append( *buf );
}

inline CSerialBuffer& CSerialBuffer::Append( const CSerialBuffer& buf )
{
	return Append( buf.Buffer(), buf.Size() );
}

inline CSerialBuffer& CSerialBuffer::Append( const char* buf )
{
	assert( NULL != buf );

	if( NULL == buf )
		return *this;

	WORD wlen = strlen( buf );
	Append((BYTE*)&wlen, sizeof(WORD));

	return Append( (BYTE*)buf, (DWORD)::strlen( buf ) + 1 );
}

inline DWORD CSerialBuffer::Popup( BYTE* buf, DWORD len )
{
	if( len > Size() )
		return 0;

	if( NULL != buf )
		memcpy( buf, Buffer(), len );
	m_head += len;

	CheckRemainder();

	return len;
}

inline void CSerialBuffer::Copy( const BYTE* buf, DWORD len )
{
//	assert( NULL != buf );
	if(buf == NULL || len == 0)
	{
		Clear();
		return;
	}

	Resize( len, TRUE );
	memcpy( m_buf, buf, len );
	ForwardTail( len );
}

inline void CSerialBuffer::Copy( const char* buf )
{
	assert( NULL != buf );

	if( NULL == buf )
		return;

	Copy( (BYTE*)buf, (DWORD)::strlen( buf ) + 1 );
}

inline void CSerialBuffer::Copy( const CSerialBuffer* buf )
{
	assert( NULL != buf );

	if( NULL == buf )
		return;

	Copy( *buf );
}

inline void CSerialBuffer::Copy( const CSerialBuffer& buf )
{
	Copy( buf.Buffer(), buf.Size() );
}

inline void CSerialBuffer::InitParams()
{
	m_len = 0;
	m_head = 0;
	m_tail = 0;
	m_buf = 0;
}

inline void CSerialBuffer::CheckRemainder()
{
	assert( 0 != this );

	if( m_head >= m_tail )
		Clear();
}

inline void CSerialBuffer::Clear( BOOL erase/*=FALSE*/ )
{
	if(erase)
	{
		Free();
	}
	else
	{
		m_head = m_tail = 0 ;
	}
}


inline void CSerialBuffer::Resize( DWORD dwNewSize, BOOL bClearData )
{
	if( bClearData )
		Clear( FALSE );

	Relloc( dwNewSize );
}

inline int CSerialBuffer::Compare(const BYTE* buf, DWORD dwBufLen)
{
	DWORD dwSize = Size();
	if(buf == NULL && dwSize == 0)
		return 0;

	if(dwSize == dwBufLen)
		return memcmp(Buffer(), buf, dwSize);

	if(dwSize > dwBufLen)
		return 1;

	return -1;
}

inline BOOL	CSerialBuffer::operator==( const CSerialBuffer& buf )
{
	return Compare(buf.Buffer(), buf.Size()) == 0;
}

inline BOOL CSerialBuffer::operator!=( const CSerialBuffer& buf )
{
	return Compare(buf.Buffer(), buf.Size()) != 0;
}

inline CSerialBuffer& CSerialBuffer::operator=( const CSerialBuffer* buf )
{
	assert( NULL != buf );

	Copy( buf );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator=( const CSerialBuffer& buf )
{
	Copy( buf );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator=( const char* buf )
{
	assert( NULL != buf );

	Copy( buf );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator+=( const CSerialBuffer* buf )
{
	assert( NULL != buf );

	return Append( buf );
}

inline CSerialBuffer& CSerialBuffer::operator+=( const CSerialBuffer& buf )
{
	return Append( buf );
}

inline CSerialBuffer& CSerialBuffer::operator+=( const char* buf )
{
	assert( NULL != buf );

	return Append( buf );
}

inline CSerialBuffer& CSerialBuffer::operator-=( DWORD len )
{
	m_head += len;
	CheckRemainder();

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator<<( BYTE value )
{
	return Append( (BYTE*)&value, sizeof(BYTE) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( WORD value )
{
	return Append( (BYTE*)&value, sizeof(WORD) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( long value )
{
	return Append( (BYTE*)&value, sizeof(long) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( DWORD value )
{
	return Append( (BYTE*)&value, sizeof(DWORD) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( UINT64 value )
{
	return Append( (BYTE*)&value, sizeof(UINT64) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( float value )
{
	return Append( (BYTE*)&value, sizeof(float) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( double value )
{
	return Append( (BYTE*)&value, sizeof(double) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( int  value )
{
	return Append( (BYTE*)&value, sizeof(int) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( bool value )
{
	return Append( (BYTE*)&value, sizeof(bool) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( const string& value )
{
	WORD wlen = value.size();
	Append((BYTE*)&wlen, sizeof(WORD));

	if(wlen == 0)
		return *this;

	return Append( (BYTE*)value.c_str(), (DWORD)value.size() + 1 );
}

inline CSerialBuffer& CSerialBuffer::operator<<( const char* value )
{
	if( NULL == value )
	{
	    WORD wlen = 0;
	    Append((BYTE*)&wlen, sizeof(WORD));
	    return *this;
	}

	WORD wlen = strlen(value);
	if(wlen == 0)
	{
		Append((BYTE*)&wlen, sizeof(WORD));
		return *this;
	}

	Append((BYTE*)&wlen, sizeof(WORD));

	return Append( (BYTE*)value, (DWORD)::strlen( value )+1);
}

inline CSerialBuffer& CSerialBuffer::operator<<( INT64 value )
{
	return Append( (BYTE*)&value, sizeof(INT64) );
}

inline CSerialBuffer& CSerialBuffer::operator<<( const CSerialBuffer& value )
{
	return Append( value );
}

inline CSerialBuffer& CSerialBuffer::operator<<( const CSerialBuffer* value )
{
	assert( NULL != value );

	return Append( value );
}

inline CSerialBuffer& CSerialBuffer::operator>>( char& value )
{
	Popup( (BYTE*)&value, sizeof( BYTE ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( short& value )
{
	Popup( (BYTE*)&value, sizeof( WORD ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( BYTE& value )
{
	Popup( (BYTE*)&value, sizeof( BYTE ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( WORD& value )
{
	Popup( (BYTE*)&value, sizeof( WORD ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( long& value )
{
	Popup( (BYTE*)&value, sizeof( long ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( DWORD& value )
{
	Popup( (BYTE*)&value, sizeof( DWORD ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( UINT64& value )
{
	Popup( (BYTE*)&value, sizeof( UINT64 ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( int&  value )
{
	Popup( (BYTE*)&value, sizeof( int ) );

	return *this;
}

inline CSerialBuffer&   CSerialBuffer::operator>>( bool&  value )
{
	Popup( (BYTE*)&value, sizeof( bool ) );

	return *this;

}

inline CSerialBuffer& CSerialBuffer::operator>>( float& value )
{
	Popup( (BYTE*)&value, sizeof( float ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( double& value )
{
	Popup( (BYTE*)&value, sizeof( double ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( string& value )
{
	// ????????????'\0'????????
	/*DWORD dwStrEndPos = OrdinalFind( (BYTE)0, 0 );
	if( dwStrEndPos < Size() )
	{
		value = (char*)Buffer();
		ForwardHead( dwStrEndPos + 1 );
	}*/

	WORD wlen = 0;
	Popup((BYTE*)&wlen, sizeof(WORD));
	if(wlen > 0 && wlen+1 <= Size())
	{
		value = (char*)Buffer();
		ForwardHead(wlen+1);
		//assert(wlen == value.size());
	}

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( INT64& value )
{
	Popup( (BYTE*)&value, sizeof( INT64 ) );

	return *this;
}

inline CSerialBuffer& CSerialBuffer::operator>>( CSerialBuffer& buf )
{
	buf = *this;
	return *this;
}

#endif
