#ifndef __TEXTUREMERGE_H__
#define __TEXTUREMERGE_H__

#include <string>
#include <vector>
#include <map>
#include "platform/CCPlatformMacros.h"
#include "cocos2d.h"
#include "2d/CCSprite.h"
#include "ui/UIScale9Sprite.h"
//#include "2d/CCFontFreeType.h"
#include "base/ccUTF8.h"
#include "../xian_you.h"

using namespace std;

#ifndef byte
typedef unsigned char byte;
#endif

NS_XIANYOU_BEGIN
struct TMLine;

struct TMGrid
{
	string key;
	int x;
	int y;
	int width;
	int height;
	TMLine* line;

	TMGrid() : key(""), x(0), y(0), width(0), height(0), line(NULL){};
	~TMGrid(){};
};

struct TMLine
{
	int y;
	int height;
	int used;
	vector<TMGrid*> grids;

	TMLine() : y(0), height(0), used(0){};
	~TMLine(){
		for (vector<TMGrid*>::iterator itr = grids.begin(); itr != grids.end(); itr++) delete *itr;
	};
};


class TextureMerge
{
private:
	size_t m_width;
	size_t m_height;
	byte* m_buffer;
	cocos2d::Texture2D* m_texture;
	size_t m_uDirtyY1;
	size_t m_uDirtyY2;
	bool m_bDirty;
	bool m_bIsFull;
	vector<TMLine*> m_vecLines;
	map<string, TMGrid*> m_allGrids;
	map<int, bool> m_mapRealHeight;
	static TextureMerge* s_instance;
	//		cocos2d::FontFreeType* _fontFreeType;

private:
	TextureMerge(size_t w, size_t h);
	void mergeDirtyRect(size_t y, size_t h);
	void initBuffer();
	int countRealHeight(int n);
	TMGrid* findGrid(const char* key, int width, int height);
	TMGrid* insertGrid(const char* key, int fontSize, byte* buffer, int width, int height, int ox, int oy);		// copy 字体
	TMGrid* insertGrid(const char* key, const byte* buffer, int width, int height, bool gray, bool hasAlpha);	// copy 图片
	bool prepareLetterDefinitions(const std::u16string& utf16String);
	void findNewCharacters(const std::u16string& u16Text, std::unordered_map<unsigned short, unsigned short>& charCodeMap);

public:
	~TextureMerge();

	static TextureMerge* getInstance();
	static void delInstance();
	void setRealHeight(int n);	// 设置图片合并的常用值
	cocos2d::Texture2D* getTexture(){ return m_texture; };
	float getWidth(){ return float(m_width); };
	float getHeight(){ return float(m_height); };
	TMGrid* getGrid(const char* key);
	TMGrid* getCharUV(const char* fontPath, int fontSize, unsigned short u16char, bool bold, bool italic);
	TMGrid* getImageUV(const char* filePath, bool gray);
	void clear(bool bClearAll = false);
	bool saveToFile(const char* fileName);
	bool addImage(const char* filePath, bool gray);
	cocos2d::Sprite* createSprite(const char* filePath, bool gray);
	cocos2d::ui::Scale9Sprite* createScale9Sprite(const char* filePath, bool gray);
	bool addString(const std::string& utf8Text);
	bool addSystemChar(const std::string& utf8Text, int fontSize);
	TMGrid* addSystemString(const std::string& utf8Text, int fontSize);
	void submit();
};

NS_XIANYOU_END

#endif
