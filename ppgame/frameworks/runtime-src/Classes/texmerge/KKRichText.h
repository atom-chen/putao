
#ifndef __KK_RICHTEXT_H__
#define __KK_RICHTEXT_H__

#include <string>
#include <vector>
#include "platform/CCPlatformMacros.h"
#include "TextureMerge.h"
#include "../xian_you.h"

using namespace std;

#define SETTER(T, ATR) \
	T ATR; \
	void set_##ATR(T v) { \
		if(ATR != v) { \
			ATR = v; curfont_unit = NULL; \
		}\
	};

NS_XIANYOU_BEGIN

enum FONTDRAW_TYPE
{
	FONTDRAW_NONE = 0,
	FONTDRAW_SHADOW,
	FONTDRAW_EDGE1,
	FONTDRAW_EDGE2,
	FONTDRAW_EDGE3,
};

struct UnitBase
{
	int								width;
	int								height;
	vector<TMGrid*>	grids;
	UnitBase():width(0), height(0){  };
	virtual ~UnitBase(){  };
	virtual void					make(vector<cocos2d::V3F_C4B_T2F>& vecVertex, int ox, int oy, float alpha){};
};

struct UnitFont : public UnitBase
{
	string							name;
	int								size;
	bool							italic;
	bool							bold;
	FONTDRAW_TYPE					drawtype;
	unsigned int					color;
	unsigned int					colorbg;
	int								word_space;
	virtual void					make(vector<cocos2d::V3F_C4B_T2F>& vecVertex, int ox, int oy, float alpha);
	UnitFont(){  };
	virtual ~UnitFont(){  };
};

struct UnitImage : public UnitBase
{
	virtual void					make(vector<cocos2d::V3F_C4B_T2F>& vecVertex, int ox, int oy, float alpha);
	UnitImage(){  };
	virtual ~UnitImage(){  };
};

struct UnitLine
{
	int								width;
	int								height;
	int								align;
	vector<UnitBase*>				units;
	UnitLine():width(0), height(0), align(0){  };
	~UnitLine()
	{
		vector<UnitBase*>::iterator itr = units.begin();
		for(; itr != units.end(); itr++)
			delete *itr;
	};
};

class KKRichText
{
public:
	int								width;
	int								height;
	vector<UnitLine*>				lines;
	int								real_width;
	int								real_height;
	vector<int>						real_lineY;
	int								word_space;
	int								line_space;
	int								line_align;

	string							font_name;
	int								font_size;
	bool							font_italic;
	bool							font_bold;
	FONTDRAW_TYPE					font_drawtype;
	unsigned int					font_color;
	unsigned int					font_colorbg;

	UnitFont*						curfont_unit;
	SETTER(string,					curfont_name);
	SETTER(int,						curfont_size);
	SETTER(bool,					curfont_italic);
	SETTER(bool,					curfont_bold);
	SETTER(FONTDRAW_TYPE,			curfont_drawtype);
	SETTER(unsigned int,			curfont_color);
	SETTER(unsigned int,			curfont_colorbg);

	KKRichText(int w, int h);
	~KKRichText();
	void newline();
	void reset();
	void addchar(TMGrid* grid);
	void addimage(TMGrid* grid);
	void addempty(int w, int h);
	void make(const std::string& text, vector<cocos2d::V3F_C4B_T2F>& vecVertex, cocos2d::Point& anchor, float alpha);

	static void						setFontFilePath(unsigned int id, const char* filePath);
	static void						setColorTransform(unsigned int id, unsigned int c1, unsigned int c2, unsigned int c3, unsigned int c4);
};

NS_XIANYOU_END

#endif //__KK_RICHTEXT_H__