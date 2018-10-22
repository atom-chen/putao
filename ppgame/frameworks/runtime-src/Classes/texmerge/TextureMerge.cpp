#include "TextureMerge.h"
#include "platform/CCImage.h"
#include "platform/CCFileUtils.h"
// #include "2d/CCFontFreeType.h"
#include "base/ccUTF8.h"
#include "base/CCDirector.h"
#include "renderer/CCTextureCache.h"
#include "platform/CCFileUtils.h"
#include "cocos2d.h"

USING_NS_CC;

#define SHARE_TEX_W 1024
#define SHARE_TEX_H 1024
#ifndef MAX_PATH
#define MAX_PATH 260
#endif

namespace xianyou{
//	static cocos2d::FontFreeType* _fontFreeType = nullptr;

	TextureMerge* TextureMerge::s_instance = NULL;
	TextureMerge* TextureMerge::getInstance()
	{
		if (s_instance != NULL)
			return s_instance;
		s_instance = new TextureMerge(SHARE_TEX_W, SHARE_TEX_H);
		return s_instance;
	}

	void TextureMerge::delInstance()
	{
		if (s_instance)
		{
			delete s_instance; 
			s_instance = NULL;
		}
	}

	TextureMerge::TextureMerge(size_t w, size_t h)
	{
		m_width = w;
		m_height = h;
		m_buffer = NULL;
		m_bDirty = true;
		m_bIsFull = false;
		m_uDirtyY1 = 0; m_uDirtyY2 = 0;
	//	_fontFreeType = nullptr;

		m_texture = new (std::nothrow) cocos2d::Texture2D;
		initBuffer();
		auto  pixelFormat = cocos2d::Texture2D::PixelFormat::RGBA8888;
		m_texture->initWithData(m_buffer, m_width*m_height*4, pixelFormat, m_width, m_height, cocos2d::Size(m_width, m_height));
	}

	TextureMerge::~TextureMerge()
	{
		vector<TMLine*>::iterator itrLine = m_vecLines.begin();
		for (; itrLine != m_vecLines.end(); itrLine++)
			delete *itrLine;
		m_vecLines.clear();
		m_allGrids.clear();
		if (m_buffer)
		{
			delete m_buffer;
			m_buffer = NULL;
		}
		CC_SAFE_DELETE(m_texture);
	}

	void TextureMerge::initBuffer()
	{
		if (m_buffer == NULL)
			m_buffer = new byte[m_width * m_height * 4];
		memset(m_buffer, 0, m_width * m_height * 4);
	}

	void TextureMerge::setRealHeight(int n)
	{
		m_mapRealHeight[n] = true;
	}

	int TextureMerge::countRealHeight(int n)
	{
		map<int, bool>::iterator itr = m_mapRealHeight.find(n);
		if (itr != m_mapRealHeight.end())
			// 这是外面定义的常用值
			return n;

		if (n < 128)
		{
			// 返回 2 的 n 次方
			int rval = 1;
			while (rval < n) { rval = rval << 1; }
			return rval;
		}

		// 返回 32 的倍数
		return n % 32 ? (n / 32 + 1) * 32 : n;
	}

	TMGrid* TextureMerge::getGrid(const char* key)
	{
		map<string, TMGrid*>::iterator itr = m_allGrids.find(key);
		if (itr != m_allGrids.end())
		{
			assert(itr->second->width > 0);
			assert(itr->second->height > 0);
			return itr->second;
		}
		return NULL;
	}

	TMGrid* TextureMerge::findGrid(const char* key, int width, int height)
	{
		if (m_bIsFull) 
			return NULL;

		int real_h = height;  // countRealHeight(height);
		assert(size_t(width) <= m_width);	// 越界了
		assert(size_t(real_h) <= m_height);	// 越界了

		TMGrid* found_grid = NULL;
		TMLine* found_line = NULL;

		// 从已有行寻找能存放的格子
		for (size_t j = 0; j < m_vecLines.size(); j++)
		{
			TMLine* line = m_vecLines[j];
			if ((line->height >= real_h) && (size_t(line->used + width) < m_width))	// < 是为了隔开 1 像素
			{
				found_line = line;
				break;
			}
		}

		// 没找到则尝试生成新的TMLine
		if (found_line == NULL)
		{
			int y = 0;
			if (!m_vecLines.empty())
			{
				TMLine* line = m_vecLines[m_vecLines.size() - 1];
				y = line->y + line->height + 1;		// 留 1 个像素的空隙
			}
			if (size_t(y + real_h) < m_height)		// < 是为了隔开 1 像素
			{
				found_line = new TMLine;
				m_vecLines.push_back(found_line);
				found_line->y = y;
				found_line->height = real_h;
			}
			else
			{
				m_bIsFull = true;
			}
		}

		//寻找可插入行失败
		if (!found_line)
			return NULL;

		assert(found_line);

		// 设置格子信息
		found_grid = new TMGrid;
		found_grid->width = width;
		found_grid->height = height;
		found_grid->key = key;
		found_grid->line = found_line;
		found_grid->x = found_line->used;
		found_grid->y = found_line->y;

		found_line->grids.push_back(found_grid);
		found_line->used += found_grid->width + 1;	// 留 1 个像素的空隙
		m_allGrids[key] = found_grid;

		return found_grid;
	}

	void TextureMerge::mergeDirtyRect(size_t y, size_t h)
	{
		// 上下取多 1 行
		y = y > 0 ? y - 2 : y;
		h += 4;

		if (m_uDirtyY1 == 0 && m_uDirtyY2 == 0)
		{
			m_uDirtyY1 = y;
			m_uDirtyY2 = y + h;
		}
		else
		{
			if (y < m_uDirtyY1) m_uDirtyY1 = y;
			if (y + h > m_uDirtyY2) m_uDirtyY2 = y + h;
		}
		if (m_uDirtyY2 >= m_height) m_uDirtyY2 = m_height - 1;
	}

	TMGrid* TextureMerge::insertGrid(const char* key, int fontSize, byte* buffer, int width, int height, int ox, int oy)
	{
		// 获取存放的格子
		TMGrid* found_grid = findGrid(key, width + ox, max(height + oy, fontSize));
		if (found_grid == NULL) return NULL;
		if (m_bIsFull) return found_grid;	// 既然已经满了就不需要 copy 了

		// 拷贝数据到贴图
		for (int j = 0; j < height; j++)
		{
			for (int i = 0; i < width; i++)
			{
				if (j + oy >= 0 && i + ox >= 0)
				{
					int idx = ((found_grid->y + j + oy) * m_width + (found_grid->x + i + ox)) * 4;
					int v = buffer[j * width + i];
					m_buffer[idx + 0] = 255;
					m_buffer[idx + 1] = 255;
					m_buffer[idx + 2] = 255;
					m_buffer[idx + 3] = v;
				}
			}
		}
		
		m_bDirty = true;
		mergeDirtyRect(found_grid->y, found_grid->height);
		return found_grid;
	}

	TMGrid* TextureMerge::insertGrid(const char* key, const byte* buffer, int width, int height, bool gray, bool hasAlpha)
	{
		// 获取存放的格子
		TMGrid* found_grid = findGrid(key, width, height);
		if (found_grid == NULL) return NULL;
		if (m_bIsFull) return NULL;	// 既然已经满了就不需要 copy 了

		// 拷贝数据到贴图
		if (gray)
		{
			// 灰化处理
			if (hasAlpha)
			{
				for (int j = 0; j < height; j++)
				for (int i = 0; i < width; i++)
				{
					int idx1 = ((found_grid->y + j) * m_width + (found_grid->x + i)) * 4;
					int idx2 = (j * width + i) * 4;
					unsigned char c = float(buffer[idx2 + 0]) * 0.299f + float(buffer[idx2 + 1]) * 0.587f + float(buffer[idx2 + 2]) * 0.114f;
					m_buffer[idx1 + 0] = c;
					m_buffer[idx1 + 1] = c;
					m_buffer[idx1 + 2] = c;
					m_buffer[idx1 + 3] = buffer[idx2 + 3];
				}
			}
			else
			{
				for (int j = 0; j < height; j++)
				for (int i = 0; i < width; i++)
				{
					int idx1 = ((found_grid->y + j) * m_width + (found_grid->x + i)) * 4;
					int idx2 = (j * width + i) * 3;
					unsigned char c = float(buffer[idx2 + 0]) * 0.299f + float(buffer[idx2 + 1]) * 0.587f + float(buffer[idx2 + 2]) * 0.114f;
					m_buffer[idx1 + 0] = c;
					m_buffer[idx1 + 1] = c;
					m_buffer[idx1 + 2] = c;
					m_buffer[idx1 + 3] = 0xff;
				}
			}
		}
		else
		{
			if (hasAlpha)
			{
				for (int j = 0; j < height; j++)
					memcpy(m_buffer + (found_grid->y + j) * m_width * 4 + found_grid->x * 4, buffer + j * width * 4, width * 4);
			}
			else
			{
				for (int j = 0; j < height; j++)
				for (int i = 0; i < width; i++)
				{
					int idx1 = ((found_grid->y + j) * m_width + (found_grid->x + i)) * 4;
					int idx2 = (j * width + i) * 3;
					unsigned char c = float(buffer[idx2 + 0]) * 0.299f + float(buffer[idx2 + 1]) * 0.587f + float(buffer[idx2 + 2]) * 0.114f;
					m_buffer[idx1 + 0] = buffer[idx2 + 0];
					m_buffer[idx1 + 1] = buffer[idx2 + 1];
					m_buffer[idx1 + 2] = buffer[idx2 + 2];
					m_buffer[idx1 + 3] = 0xff;
				}
			}
		}
		m_bDirty = true;
		mergeDirtyRect(found_grid->y, found_grid->height);
		return found_grid;
	}

	TMGrid* TextureMerge::getCharUV(const char* fontPath, int fontSize, unsigned short u16char, bool bold, bool italic)
	{
		//生成Key
		const size_t KEYBUFF_SIZE = MAX_PATH + 128;
		char szKEYBUFF[KEYBUFF_SIZE];
		snprintf(szKEYBUFF, KEYBUFF_SIZE, "%s_%d_%d_%d_%d", fontPath, fontSize, u16char, bold, italic);

		// 读取缓存数据
		TMGrid* grid = getGrid(szKEYBUFF);
		if (grid) return grid;

		// 读取图片信息
		int w = fontSize;
		int h = fontSize;
		byte* img_data = new byte[w * h * 4];
		if (!img_data) return NULL;
		memset(img_data, 255, w * h * 4);
		grid = insertGrid(szKEYBUFF, img_data, w, h, false, true);
		delete[] img_data;
		assert(grid);
		return grid;
	}

	TMGrid* TextureMerge::getImageUV(const char* filePath, bool gray)
	{
		//生成Key
		static const size_t KEYBUFF_SIZE = MAX_PATH + 128;
		static char szKEYBUFF[KEYBUFF_SIZE];
		snprintf(szKEYBUFF, KEYBUFF_SIZE, "%s_%d", filePath, gray);

		// 读取缓存数据
		TMGrid* grid = TextureMerge::getInstance()->getGrid(szKEYBUFF);
		if (grid) return grid;

		// 读取图片信息
		cocos2d::Image::Format eImageFormat = cocos2d::Image::Format::UNKNOWN;
		cocos2d::Image* image = new (std::nothrow) cocos2d::Image();  // cocos2d::Image::create(filePath, &eImageFormat);
		if (image == NULL)
		{
			printf("load image file failed: %s", filePath);
			return NULL;
		}
		bool bRet = image->initWithImageFile(filePath);
		grid = insertGrid(szKEYBUFF, image->getData(), image->getWidth(), image->getHeight(), gray, image->hasAlpha());
		if (!grid)
		{
			std::string fullpath = cocos2d::FileUtils::getInstance()->fullPathForFilename(filePath);
			cocos2d::Director::getInstance()->getTextureCache()->addImage(image, fullpath);
		}
		CC_SAFE_RELEASE(image);
		return grid;
	}

	bool TextureMerge::addImage(const char* filePath, bool gray)
	{
		TMGrid* grid = NULL;
		grid = getImageUV(filePath, gray);
		return grid ? true : false;
	}

	cocos2d::Sprite* TextureMerge::createSprite(const char* filePath, bool gray)
	{
		TMGrid* grid = getImageUV(filePath, gray);
		if (!grid) return cocos2d::Sprite::create(filePath);;
		submit();
		cocos2d::Sprite* spr = cocos2d::Sprite::createWithTexture(m_texture, cocos2d::Rect(grid->x, grid->y, grid->width, grid->height));
		if (!spr)
			spr = cocos2d::Sprite::create(filePath);
		return spr;
	}

	cocos2d::ui::Scale9Sprite* TextureMerge::createScale9Sprite(const char* filePath, bool gray)
	{
		auto spr = TextureMerge::getInstance()->createSprite(filePath, gray);
		if (!spr) return nullptr;
		cocos2d::ui::Scale9Sprite* pSpr9 = cocos2d::ui::Scale9Sprite::create();
		if (!pSpr9) return nullptr;
		TMGrid* grid = getImageUV(filePath, gray);
		if (!grid) return nullptr;
		if(pSpr9->updateWithSprite(spr,cocos2d::Rect(grid->x,grid->y,grid->width,grid->height),false,pSpr9->getCapInsets()))
			return pSpr9;
		return nullptr;
	}

	void TextureMerge::submit()
	{
		if (m_bDirty)
			m_texture->updateWithData(m_buffer, 0, m_uDirtyY1, m_width, m_uDirtyY2 - m_uDirtyY1);
	}

	void TextureMerge::clear(bool bClearAll)
	{
		if (bClearAll && m_texture) { 
			CC_SAFE_RELEASE(m_texture);
		}

		initBuffer();
		m_bDirty = true;
		m_uDirtyY1 = 0; 
		m_uDirtyY2 = 0;
		m_bIsFull = false;
		vector<TMLine*>::iterator itrLine = m_vecLines.begin();
		for (; itrLine != m_vecLines.end(); itrLine++)
			delete *itrLine;
		m_vecLines.clear();
		m_allGrids.clear();
	}

	bool TextureMerge::saveToFile(const char* fileName)
	{
		cocos2d::Image image;
		if (image.initWithRawData(m_buffer, m_width*m_height*4, m_width, m_height, 8))
		{
			image.saveToFile(fileName, false);
			printf("save merge succ\n");
			return true;
		}
		printf("save merge fail\n");
		return false;
	}


	////////////////////
	//
	////////////////////
	void TextureMerge::findNewCharacters(const std::u16string& u16Text, std::unordered_map<unsigned short, unsigned short>& charCodeMap)
	{
		//find new characters
		auto length = u16Text.length();
		for (size_t i = 0; i < length; ++i)
		{
			auto outIterator = getCharUV("fonts/FZY4JW.TTF", 24, u16Text[i], false, false);
		}
	}

	bool TextureMerge::prepareLetterDefinitions(const std::u16string& utf16Text)
	{
// 		if (!_fontFreeType)
// 			_fontFreeType = cocos2d::FontFreeType::create("fonts/FZY4JW.TTF", 24, cocos2d::GlyphCollection::DYNAMIC, nullptr, false, 0);
// 		if (_fontFreeType == nullptr)
// 			return false;
// 
// 		std::unordered_map<unsigned short, unsigned short> codeMapOfNewChar;
// 		findNewCharacters(utf16Text, codeMapOfNewChar);
		return false;
	}

	bool TextureMerge::addString(const std::string& utf8Text)
	{
		std::u16string utf16String;
		if (cocos2d::StringUtils::UTF8ToUTF16(utf8Text, utf16String))
		{
			return prepareLetterDefinitions(utf16String);
		}
		return false;
	}

	bool TextureMerge::addSystemChar(const std::string& utf8Text, int fontSize)
	{
		return addSystemString(utf8Text, fontSize) != NULL;
	}

	TMGrid* TextureMerge::addSystemString(const std::string& utf8Text, int fontSize)
	{
		//生成Key
		const size_t KEYBUFF_SIZE = MAX_PATH + 128;
		char szKEYBUFF[KEYBUFF_SIZE];
		snprintf(szKEYBUFF, KEYBUFF_SIZE, "%s_%d_%s_%d_%d", "nil_system_font", fontSize, utf8Text.c_str(), false, false);

		// 读取缓存数据
		TMGrid* grid = getGrid(szKEYBUFF);
		if (grid) return grid;

		// 读取图片信息
		int imageWidth;
		int imageHeight;
		bool hasPremultipliedAlpha;
		Device::TextAlign align = Device::TextAlign::CENTER;
		cocos2d::FontDefinition textDef;
		textDef._fontSize = fontSize;
		auto contentScaleFactor = CC_CONTENT_SCALE_FACTOR();
		textDef._fontSize *= contentScaleFactor;
		textDef._dimensions.width *= contentScaleFactor;
		textDef._dimensions.height *= contentScaleFactor;
		textDef._stroke._strokeSize *= contentScaleFactor;
		textDef._shadow._shadowEnabled = false;

		cocos2d::Data outData = cocos2d::Device::getTextureDataForText(utf8Text.c_str(), textDef, align, imageWidth, imageHeight, hasPremultipliedAlpha);
		if (outData.isNull()) return NULL;

		int w = imageWidth;
		int h = imageHeight;
		byte* img_data = outData.getBytes();
		grid = insertGrid(szKEYBUFF, img_data, w, h, false, true);
		//delete[] img_data;
		assert(grid);
		return grid;
	}
}