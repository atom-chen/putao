
#include "KKRichText.h"

NS_XIANYOU_BEGIN

struct ColorRect
{
	unsigned int left_top;
	unsigned int right_top;
	unsigned int left_bottom;
	unsigned int right_bottom;
};

map<unsigned int, string>		s_mapFontPath;
map<unsigned int, ColorRect>	s_mapColorTransform;

unsigned int readnum10(const char** s, int n)
{
	unsigned int ret = 0;
	char c;
	for(int i = 0; i < n; i ++)
	{
		c = (*s)[0];
		if( c >= '0' && c <= '9' )
			ret = ( ret * 10 ) + ( c - '0' ); 
		else
			break;
		(*s) += 1;
	}
	return ret;
}

unsigned int readnum16(const char** s, int n)
{
	unsigned int ret = 0;
	char c;
	for(int i = 0; i < n; i ++)
	{
		c = (*s)[0];
		if( c >= '0' && c <= '9' )
			ret = ( ret << 4 ) + ( c - '0' ); 
		else if( c >= 'a' && c <= 'f' )
			ret = ( ret << 4 ) + ( c - 'a' + 10 ); 
		else if( c >= 'A' && c <= 'F' )
			ret = ( ret << 4 ) + ( c - 'A' + 10 ); 
		else
			break;
		(*s) += 1;
	}
	return ret;
}

void set_vertex_posi(cocos2d::V3F_C4B_T2F& vertex, float x, float y)
{
	vertex.vertices.x = x; vertex.vertices.y = y; vertex.vertices.z = 0;
}
void set_vertex_offset(cocos2d::V3F_C4B_T2F& vertex, float ox, float oy)
{
	vertex.vertices.x += ox; vertex.vertices.y += oy;
}
void set_vertex_uv(cocos2d::V3F_C4B_T2F& vertex, float u, float v)
{
	vertex.texCoords.u = u; vertex.texCoords.v = v;
}
void set_vertex_colors(cocos2d::V3F_C4B_T2F& vertex, unsigned int color, float alpha)
{
	vertex.colors.a = color >> 24 & 0xff;
	vertex.colors.r = color >> 16 & 0xff;
	vertex.colors.g = color >> 8 & 0xff;
	vertex.colors.b = color & 0xff;
	if(vertex.colors.a == 0) vertex.colors.a = 0xff;	// alpha 不能为 0
	vertex.colors.a *= alpha;
}

/*
 ******************************************************************************
 ******************************************************************************
 */

void KKRichText::setFontFilePath(unsigned int id, const char* filePath)
{
	s_mapFontPath[id] = filePath;
}

void KKRichText::setColorTransform(unsigned int id, unsigned int c1, unsigned int c2, unsigned int c3, unsigned int c4)
{
	ColorRect cr;
	cr.left_top		= c1;
	cr.right_top	= c2;
	cr.left_bottom	= c3;
	cr.right_bottom	= c4;
	s_mapColorTransform[id] = cr;
}

KKRichText::KKRichText(int w, int h) :width(w), height(h), real_width(0), real_height(0),
word_space(0), line_space(0), line_align(7),
font_name(""), font_size(0), font_italic(false), font_bold(false), font_drawtype(FONTDRAW_NONE), font_color(0), font_colorbg(0),
curfont_unit(NULL),
curfont_name(""), curfont_size(0), curfont_italic(false), curfont_bold(false), curfont_drawtype(FONTDRAW_NONE), curfont_color(0), curfont_colorbg(0)
{

}

KKRichText::~KKRichText()
{
	vector<UnitLine*>::iterator itr = lines.begin();
	for(; itr != lines.end(); itr++)
		delete *itr;
}

void KKRichText::newline()
{
	curfont_unit = NULL;
	UnitLine* line = new UnitLine;
	line->align = line_align;
	lines.push_back(line);
}

void KKRichText::reset()
{
	curfont_unit		= NULL;
	curfont_name		= font_name;
	curfont_size		= font_size;	
	curfont_italic		= font_italic;
	curfont_bold		= font_bold;
	curfont_drawtype	= font_drawtype;
	curfont_color		= font_color;
	curfont_colorbg		= font_colorbg;
}

void KKRichText::addchar(TMGrid* grid)
{
	UnitLine* line = lines.back();
	if(line->width + grid->width > width)
	{
		newline();
		line = lines.back();
	}
	UnitFont* unit = curfont_unit;
	if(unit == NULL)
	{
		unit				= new UnitFont;
		unit->name			= curfont_name;
		unit->size			= curfont_size;
		unit->italic		= curfont_italic;
		unit->bold			= curfont_bold;
		unit->drawtype		= curfont_drawtype;
		unit->color			= curfont_color;
		unit->colorbg		= curfont_colorbg;
		unit->word_space	= word_space;
		line->units.push_back(unit);
		curfont_unit = unit;
	}
	unit->width += grid->width + unit->word_space;
	unit->height = max(unit->height, grid->height);
	unit->grids.push_back(grid);
	line->width += grid->width + unit->word_space;
	line->height = max(line->height, unit->height + line_space);
}

void KKRichText::addimage(TMGrid* grid)
{
	UnitLine* line = lines.back();
	if(line->width + grid->width > width)
	{
		newline();
		line = lines.back();
	}
	curfont_unit = NULL;	// 清空上一个 Text

	UnitImage* unit = new UnitImage;
	unit->width += grid->width;
	unit->height = max(unit->height, grid->height);
	unit->grids.push_back(grid);
	line->units.push_back(unit);
	line->width += grid->width;
	line->height = max(line->height, unit->height);
}

void KKRichText::addempty(int w, int h)
{
	UnitLine* line = lines.back();
	if(line->width + w > width)
	{
		newline();
		line = lines.back();
	}
	curfont_unit = NULL;	// 清空上一个 Text

	UnitBase* unit = new UnitBase;
	unit->width += w;
	unit->height = max(unit->height, h);
	line->units.push_back(unit);
	line->width += w;
	line->height = max(line->height, unit->height);
}

void KKRichText::make(const std::string& text, vector<cocos2d::V3F_C4B_T2F>& vecVertex, cocos2d::Point& anchor, float alpha)
{
	reset();
	newline();

	TMGrid* grid = NULL;
	auto InstMerger = TextureMerge::getInstance();
	grid = InstMerger->addSystemString(text, font_size);
	if (grid)
	{
		addchar(grid);
	}
	InstMerger->submit();

	vector<TMGrid*>::iterator itr_grid;
	vector<UnitBase*>::iterator itr_unit;
	vector<UnitLine*>::iterator itr_line;

	// 计算总高度
	real_width = 0;
	real_height = 0;
	for(itr_line = lines.begin(); itr_line != lines.end(); itr_line ++)
	{
		UnitLine* line = *itr_line;
		real_width = max(real_width, line->width);
		real_height += line->height;
	}
	// 记录实际的宽度和高度
	real_lineY.clear();

	// 计算 UV
	/**/
	int ox = -anchor.x * width, oy = real_height * (1 - anchor.y);
	int cur_y = 0;
	for(itr_line = lines.begin(); itr_line != lines.end(); itr_line ++)
	{
		UnitLine* line = *itr_line;
		int line_ox = 0, line_oy = cur_y;
		switch(line->align)
		{
		case 1: case 4: case 7: break;
		case 2: case 5: case 8: line_ox = (width - line->width) / 2; break;
		case 3: case 6: case 9: line_ox = width - line->width; break;
		}
		int cur_x = 0;
		for(itr_unit = line->units.begin(); itr_unit != line->units.end(); itr_unit ++)
		{
			UnitBase* unit = *itr_unit;
			int unit_ox = cur_x, unit_oy = 0;
			switch(line->align)
			{
			case 1: case 2: case 3: break;
			case 4: case 5: case 6: unit_oy = -(line->height - unit->height) / 2; break;
			case 7: case 8: case 9: unit_oy = -(line->height - unit->height); break;
			}
			unit->make(vecVertex, ox + line_ox + unit_ox, oy + line_oy + unit_oy, alpha);
			cur_x += unit->width;
		}
		cur_y -= line->height;

		// 记录实际的宽度和高度
		//real_width = max(real_width, line_ox + line->width);
		real_lineY.push_back(cur_y + oy);
	}
}

void UnitFont::make(vector<cocos2d::V3F_C4B_T2F>& vecVertex, int ox, int oy, float alpha)
{
	vector<TMGrid*>::iterator itr_grid;
	float TEXWIDTH = TextureMerge::getInstance()->getWidth();
	float TEXHEIGHT = TextureMerge::getInstance()->getHeight();
	// 计算顶点色
	unsigned int color_lt = color, color_rt = color, color_lb = color, color_rb = color;
	map<unsigned int, ColorRect>::iterator itr = s_mapColorTransform.find(color);
	if(itr != s_mapColorTransform.end())
	{
		color_lt = itr->second.left_top; color_rt = itr->second.right_top;
		color_lb = itr->second.left_bottom; color_rb = itr->second.right_bottom;
	}
	// 生成顶点信息
	cocos2d::V3F_C4B_T2F vertex;
	for(itr_grid = grids.begin(); itr_grid != grids.end(); itr_grid ++)
	{
		TMGrid* grid = *itr_grid;
		int x = ox;
		int y = oy;
		set_vertex_posi(vertex, x, y); set_vertex_uv(vertex, grid->x / TEXWIDTH, grid->y / TEXHEIGHT); set_vertex_colors(vertex, color_lt, alpha);
		vecVertex.push_back(vertex);
		set_vertex_posi(vertex, x, y - grid->height); set_vertex_uv(vertex, grid->x / TEXWIDTH, (grid->y + grid->height) / TEXHEIGHT); set_vertex_colors(vertex, color_rb, alpha);
		vecVertex.push_back(vertex);
		set_vertex_posi(vertex, x + grid->width, y - grid->height); set_vertex_uv(vertex, (grid->x + grid->width) / TEXWIDTH, (grid->y + grid->height) / TEXHEIGHT); set_vertex_colors(vertex, color_rb, alpha);
		vecVertex.push_back(vertex);
		set_vertex_posi(vertex, x + grid->width, y); set_vertex_uv(vertex, (grid->x + grid->width) / TEXWIDTH, grid->y / TEXHEIGHT); set_vertex_colors(vertex, color_rt, alpha);
		vecVertex.push_back(vertex);
		vecVertex.push_back(vecVertex[vecVertex.size() - 2]);
		vecVertex.push_back(vecVertex[vecVertex.size() - 5]);
		ox += grid->width + word_space;
	}

	int iSumCount = grids.size() * 6;
	int iStartIdx = vecVertex.size() - iSumCount;
	int iEndIdx = vecVertex.size();
	switch(drawtype)
	{
		// 绘制阴影
	case FONTDRAW_SHADOW:
		// 复制顶点
		for(int i = iStartIdx; i < iEndIdx; i ++)
			vecVertex.push_back(vecVertex[i]);
		// 像素偏移
		for(int i = iStartIdx; i < iEndIdx; i ++)
		{
			cocos2d::V3F_C4B_T2F& vertex = vecVertex[i];
			set_vertex_offset(vertex, 1, -1);
			set_vertex_colors(vertex, colorbg, 1.f * alpha);
		}
		break;
	case FONTDRAW_EDGE1:
		{
			const int t = 8;
			float offset[t][3] = {	{-1,-1,1.0f},	{ 0,-1, 1.0f},	{ 1,-1,1.0f},
									{-1, 0,1.0f},					{ 1, 0,1.0f},
									{-1, 1,1.0f},	{ 0, 1, 1.0f},	{ 1, 1,1.0f},};
			// 复制顶点
			for(int j = 0; j < t; j ++)
				for(int i = iStartIdx; i < iEndIdx; i ++)
					vecVertex.push_back(vecVertex[i]);
			// 像素偏移
			for(int j = 0; j < t; j ++)
				for(int i = 0; i < iSumCount; i ++)
				{
					cocos2d::V3F_C4B_T2F& vertex = vecVertex[iStartIdx + j * iSumCount + i];
					set_vertex_offset(vertex, offset[j][0], offset[j][1]);
					set_vertex_colors(vertex, colorbg, offset[j][2] * alpha*alpha);
				}
		} break;
	case FONTDRAW_EDGE2:
		{
			// 复制顶点
			const int t = 12;
			const float a1 = 1.0f, a2 = 0.7f;
			float offset[t][3] = {	{-2,-2,a2},				{ 0,-2,a2},				{ 2,-2,a2},
												{-1,-1, a1},			{ 1,-1,a1},
									{-2, 0,a2},										{ 2, 0,a2},
												{-1, 1, a1},			{ 1, 1,a1},
									{-2, 2,a2},				{ 0, 2,a2},				{ 2, 2,a2},};
			for(int j = 0; j < t; j ++)
				for(int i = iStartIdx; i < iEndIdx; i ++)
					vecVertex.push_back(vecVertex[i]);
			// 像素偏移
			for(int j = 0; j < t; j ++)
				for(int i = 0; i < iSumCount; i ++)
				{
					cocos2d::V3F_C4B_T2F& vertex = vecVertex[iStartIdx + j * iSumCount + i];
					set_vertex_offset(vertex, offset[j][0], offset[j][1]);
					set_vertex_colors(vertex, colorbg, offset[j][2] * alpha*alpha);
				}
		} break;
	case FONTDRAW_EDGE3:
		{
			// 复制顶点
			const int t = 24;
			const float a1 = 1.0f, a2 = 1.0f, a3 = 0.6f;
			float offset[t][3] = {				
				{-2,-3,a3},		{0,-3,a3},		{ 2,-3,a3},
				{-3,-2,a3},		{-1,-2,a2},		{ 1,-2,a2},		{ 3,-2,a3},
				{-2,-1,a2},		{0,-1,a1},		{ 2,-1,a2},
				{-3, 0,a3},		{-1, 0,a1},		{ 1, 0,a1},		{ 3, 0,a3},
				{-2, 1,a2},		{0, 1,a1},		{ 2, 1,a2},
				{-3, 2,a3},		{-1, 2,a2},		{ 1, 2,a2},		{ 3, 2,a2},
				{-2, 3,a3},		{0, 3,a3},		{ 2, 3,a3},
			};
			for(int j = 0; j < t; j ++)
				for(int i = iStartIdx; i < iEndIdx; i ++)
					vecVertex.push_back(vecVertex[i]);
			// 像素偏移
			for(int j = 0; j < t; j ++)
				for(int i = 0; i < iSumCount; i ++)
				{
					cocos2d::V3F_C4B_T2F& vertex = vecVertex[iStartIdx + j * iSumCount + i];
					set_vertex_offset(vertex, offset[j][0], offset[j][1]);
					set_vertex_colors(vertex, colorbg, offset[j][2] * alpha*alpha);
				}
		} break;
	}
}

void UnitImage::make(vector<cocos2d::V3F_C4B_T2F>& vecVertex, int ox, int oy, float alpha)
{
	float TEXWIDTH = TextureMerge::getInstance()->getWidth();
	float TEXHEIGHT = TextureMerge::getInstance()->getHeight();
	
	TMGrid* grid = grids.back();
	cocos2d::V3F_C4B_T2F vertex;
	set_vertex_colors(vertex, 0xffffffff, alpha);
	int x = ox; int y = oy;
	set_vertex_posi(vertex, x, y); set_vertex_uv(vertex, grid->x / TEXWIDTH, grid->y / TEXHEIGHT);
	vecVertex.push_back(vertex);
	set_vertex_posi(vertex, x, y - grid->height); set_vertex_uv(vertex, grid->x / TEXWIDTH, (grid->y + grid->height) / TEXHEIGHT);
	vecVertex.push_back(vertex);
	set_vertex_posi(vertex, x + grid->width, y - grid->height); set_vertex_uv(vertex, (grid->x + grid->width) / TEXWIDTH, (grid->y + grid->height) / TEXHEIGHT);
	vecVertex.push_back(vertex);
	set_vertex_posi(vertex, x + grid->width, y); set_vertex_uv(vertex, (grid->x + grid->width) / TEXWIDTH, grid->y / TEXHEIGHT);
	vecVertex.push_back(vertex);
	vecVertex.push_back(vecVertex[vecVertex.size() - 2]);
	vecVertex.push_back(vecVertex[vecVertex.size() - 5]);
}

NS_XIANYOU_END