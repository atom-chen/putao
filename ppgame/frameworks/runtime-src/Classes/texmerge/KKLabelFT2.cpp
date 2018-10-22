#include "KKLabelFT2.h"
#include "renderer/CCRenderer.h"
#include "renderer/ccGLStateCache.h"
#include "base/CCDirector.h"
#include "base/CCEventListenerCustom.h"
#include "base/CCEventDispatcher.h"
#include "base/CCEventCustom.h"
//#include "KKFreeType2.h"
#include "base/ccMacros.h"


NS_XIANYOU_BEGIN


KKLabelFT2* KKLabelFT2::create(const char *fontName, int fontSize, bool bold, bool italic)
{
	KKLabelFT2* p = new KKLabelFT2(fontName, fontSize);
	p->setBold(bold);
	p->setItalic(italic);
	p->autorelease();
	return p;
}

KKLabelFT2::KKLabelFT2(const char *fontName, float fontSize) :m_strFontName(fontName), m_iFontSize(fontSize),
m_bBold(false),
m_bItalic(false),
m_eDrawType(FONTDRAW_NONE),
m_iFontColor(0xff000000),
m_iFontColorBg(0xff000000),
m_iWordSpace(0),
m_iLineSpace(0),
m_iLineAlign(7),
m_iRealWidth(0),
m_iRealHeigh(0)
{
	setGLProgram(cocos2d::GLProgramCache::getInstance()->getGLProgram(cocos2d::GLProgram::SHADER_NAME_POSITION_TEXTURE_COLOR));
//	setGLProgramState(cocos2d::GLProgramState::getOrCreateWithGLProgramName(cocos2d::GLProgram::SHADER_NAME_POSITION_TEXTURE_COLOR_NO_MVP));
	setContentSize(cocos2d::Size(128, 64));
}

KKLabelFT2::~KKLabelFT2()
{
}

cocos2d::Array* KKLabelFT2::getRealLineY()
{
	reflesh();
	cocos2d::Array* ary = cocos2d::Array::create();
	vector<int>::iterator itr = m_vecRealLineY.begin();
	for( ; itr != m_vecRealLineY.end(); itr ++)
		ary->addObject(cocos2d::Integer::create(*itr));
	return ary;
}

void KKLabelFT2::onDraw(const cocos2d::Mat4& transform, bool transformUpdated)
{
	auto glprogram = getGLProgram();
	glprogram->use();

	cocos2d::GL::blendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glprogram->setUniformsForBuiltins(transform);
	cocos2d::GL::bindTexture2D(TextureMerge::getInstance()->getTexture()->getName());

	cocos2d::GL::enableVertexAttribs(cocos2d::GL::VERTEX_ATTRIB_FLAG_POS_COLOR_TEX);

	cocos2d::V3F_C4B_T2F& start = m_vecVertex[0];
	size_t size = sizeof(cocos2d::V3F_C4B_T2F);
	glVertexAttribPointer(cocos2d::GLProgram::VERTEX_ATTRIB_POSITION, 3, GL_FLOAT, GL_FALSE, size, (void*)(&start.vertices));
	glVertexAttribPointer(cocos2d::GLProgram::VERTEX_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, size, (void*)(&start.texCoords));
	glVertexAttribPointer(cocos2d::GLProgram::VERTEX_ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE, size, (void*)(&start.colors));
	glDrawArrays(GL_TRIANGLES, 0, m_vecVertex.size());

	CHECK_GL_ERROR_DEBUG();
	CC_INCREMENT_GL_DRAWS(1);
}

void KKLabelFT2::draw(cocos2d::Renderer *renderer, const cocos2d::Mat4& transform, uint32_t flags)
{
	reflesh();
	if(m_vecVertex.size() <= 0) return;

	bool transformUpdated = flags & FLAGS_TRANSFORM_DIRTY;
	_customCommand.init(_globalZOrder, transform, flags);
	_customCommand.func = CC_CALLBACK_0(KKLabelFT2::onDraw, this, transform, transformUpdated);

	renderer->addCommand(&_customCommand);
}

void KKLabelFT2::reflesh(bool force)
{
	if(!isDirty() && !force) return;
	setUndirty();
	m_vecVertex.clear();

	KKRichText richtext(_contentSize.width, _contentSize.height);
	richtext.word_space		= m_iWordSpace;
	richtext.line_space		= m_iLineSpace;
	richtext.line_align		= m_iLineAlign;
	richtext.font_name		= m_strFontName;
	richtext.font_size		= m_iFontSize;
	richtext.font_italic	= m_bItalic;
	richtext.font_bold		= m_bBold;
	richtext.font_drawtype	= m_eDrawType;
	richtext.font_color		= m_iFontColor;
	richtext.font_colorbg	= m_iFontColorBg;
	richtext.make(m_strText, m_vecVertex, _anchorPoint, float(getDisplayedOpacity())/255.f);
	m_iRealWidth = richtext.real_width;
	m_iRealHeigh = richtext.real_height;
	m_vecRealLineY = richtext.real_lineY;
}

NS_XIANYOU_END