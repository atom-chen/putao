
#ifndef __KK_LABELFT2_H__
#define __KK_LABELFT2_H__

#include <string>
#include <vector>
#include <map>
#include "2d/CCLayer.h"
#include "../xian_you.h"
#include "TextureMerge.h"
#include "KKRichText.h"

using namespace std;

#define UPDATE_ATTR(A, B) if(A != B) { A = B; setDirty(); }

NS_XIANYOU_BEGIN

class KKLabelFT2 : public cocos2d::Node, public cocos2d::LabelProtocol
{
protected:
	bool							m_bDirty;  // for TextureMerge

	string								m_strFontName;
	int									m_iFontSize;
	bool								m_bBold;
	bool								m_bItalic;
	unsigned int						m_iFontColor;
	unsigned int						m_iFontColorBg;
	FONTDRAW_TYPE						m_eDrawType;
	int									m_iWordSpace;
	int									m_iLineSpace;
	int									m_iLineAlign;
	vector<cocos2d::V3F_C4B_T2F>		m_vecVertex;
	string								m_strText;
	int									m_iRealWidth;		// 实际宽度
	int									m_iRealHeigh;		// 实际高度
	vector<int>							m_vecRealLineY;		// 实际每一行的高度

	cocos2d::CustomCommand _customCommand;

public:
	virtual bool						isDirty(){ return m_bDirty; };
	virtual void						setDirty() { m_bDirty = true; };
	virtual void						setUndirty(){ m_bDirty = false; };
	virtual void						reflesh(bool force = false);
	virtual bool						isEyeable(){ return isRunning(); };
	
public:
	static KKLabelFT2*					create(const char *fontName, int fontSize, bool bold, bool italic);

	KKLabelFT2(const char *fontName, float fontSize);
	virtual ~KKLabelFT2();
	void onDraw(const cocos2d::Mat4& transform, bool transformUpdated);
	virtual void						draw(cocos2d::Renderer *renderer, const cocos2d::Mat4& transform, uint32_t flags);
	virtual void						onEnter(){ cocos2d::Node::onEnter(); setDirty(); };
	virtual void						setContentSize(const cocos2d::Size& contentSize){ cocos2d::Node::setContentSize(contentSize); setDirty(); };
	virtual void						setOpacity(GLubyte opacity){ cocos2d::Node::setOpacity(opacity); setDirty(); }
	virtual void						updateDisplayedOpacity(GLubyte opacity){ cocos2d::Node::updateDisplayedOpacity(opacity); setDirty(); };
	virtual void						setAnchorPoint(const cocos2d::Point& anchorPoint){ cocos2d::Node::setAnchorPoint(anchorPoint); setDirty(); };

public:
	virtual const string&				getFontName(){ return m_strFontName; };
	virtual int							getFontSize(){ return m_iFontSize; };
	virtual void						setFont(const char* name, int size){ UPDATE_ATTR(m_strFontName, name); UPDATE_ATTR(m_iFontSize, size); };
	virtual bool						isBold(){ return m_bBold; };
	virtual void						setBold(bool bold){ UPDATE_ATTR(m_bBold, bold); };
	virtual bool						isItalic(){ return m_bItalic; };
	virtual void						setItalic(bool italic){ UPDATE_ATTR(m_bItalic, italic); };
	virtual const std::string&			getString() const override { return m_strText; };
	virtual void						setString(const std::string& text) override { UPDATE_ATTR(m_strText, text); };
	virtual FONTDRAW_TYPE				getDrawType(){ return m_eDrawType; };
	virtual void						setDrawType(FONTDRAW_TYPE e){ UPDATE_ATTR(m_eDrawType, e); };
	virtual unsigned int				getFontColor(){ return m_iFontColor; };
	virtual void						setFontColor(unsigned int color){ UPDATE_ATTR(m_iFontColor, color); };
	virtual unsigned int				getFontColorBg(){ return m_iFontColorBg; };
	virtual void						setFontColorBg(unsigned int color){ UPDATE_ATTR(m_iFontColorBg, color); };

	virtual int							getWordSpace(){ return m_iWordSpace; };
	virtual void						setWordSpace(int w){ UPDATE_ATTR(m_iWordSpace, w); };
	virtual int							getLineSpace(){ return m_iLineSpace; };
	virtual void						setLineSpace(int w){ UPDATE_ATTR(m_iLineSpace, w); };
	virtual int							getLineAlign(){ return m_iLineAlign; };
	virtual void						setLineAlign(int l){ UPDATE_ATTR(m_iLineAlign, l); };

	virtual int							getRealWidth(){ reflesh(); return m_iRealWidth; };
	virtual int							getRealHeight(){ reflesh(); return m_iRealHeigh; };
	virtual cocos2d::Array*				getRealLineY();
};

NS_XIANYOU_END

#endif //__KK_LABELFT2_H__