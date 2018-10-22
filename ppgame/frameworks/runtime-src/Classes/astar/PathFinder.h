#ifndef __VV_PATHFINDER_H__
#define __VV_PATHFINDER_H__

#include <vector>
#include <stack>
using namespace std;
#include "ftype.h"

#include "cocos2d.h"
#include "../xian_you.h"

NS_XIANYOU_BEGIN

class PathFinder : public cocos2d::Ref
{
private:
	vector<int32> _xlist;	//���Ѱ·���
	vector<int32> _ylist;	//���Ѱ·���
	int32 _end_x;			//Ѱ·Ŀ���
	int32 _end_y;			//Ѱ·Ŀ���
	// MapBlock
	vector<int8> _blocks;			//�赲����
	vector<int16> _blocks_weight;	//��ʾ�õ���Χ���赲�������Ŀ
	vector<int8> _ref_blocks;		//������
	vector<int8> _terrain_blocks;	//��������
	uint32 _ver, _width, _height;	//MapBlock�汾������
	uint32 _bx, _by, _bw, _bh;		//����MapBlockѰ·ʱ�ķ�Χ��Ĭ��Ϊ0,0,_width,_height

	// ���ӽṹ
	struct Seed
	{
		int32 x;
		int32 y;
		Seed(int32 _x, int32 _y) { x = _x; y = _y; }
	};

public:
	static PathFinder* getInstance();
	PathFinder();

	bool findPath(int32 sx, int32 sy, int32 ex, int32 ey, int32 dist);
	uint32 getSize(){ return _xlist.size(); }
	vector<int32>& getXList() { return _xlist; }
	vector<int32>& getYList() { return _ylist; }

	void pushPoint(int32 x, int32 y){ _xlist.push_back(x), _ylist.push_back(y); }
	void getPoint(uint32 i, int32& x, int32& y){ if (i < getSize()) { x = _xlist[i], y = _ylist[i]; } }

	// MapBlock
	void createBlock(uint32 wid, uint32 hei);
	uint32 getWidth(){ return _width; }
	uint32 getHeight(){ return _height; }
	bool saveBlock(const char* path);
	bool loadBlock(const char* path);
	void setBound(uint32 x, uint32 y, uint32 w, uint32 h);
	bool isBlock(int32 x, int32 y);
	bool setBlock(int32 x, int32 y, bool bblock);
	void setTerrain(int32 x, int32 y, int32 terrain);
	int32 getTerrain(int32 x, int32 y);
	bool addBlockRef(int32 x, int32 y, bool bblock);
	int16 getWeight(int32 x, int32 y);

private:
	//A��·���Ż����������(block)�߽�Ѱ·������ֱ����ȴ�����ߵĲ���������;
	void optimizePath(vector<int32>& xlst, vector<int32>& ylst);
	//������赲��ʱ��������Ѱ�ҿɵ���ĵ�;
	bool searchNearCross(int32& ex, int32& ey);
	bool searchNearRect(int32& ex, int32& ey);
	// ��Ϊ��Щ��ͼ����·�����㵽��·ʱ��Ѱ·̫�����������ȼ���Ƿ���·
	bool checkSameArea(int32 sx, int32 sy, int32& ex, int32& ey);

private:
	// �㵽�赲ʱ�������ܱ߿�������
	bool _search_near(int32 sx, int32 sy, int32& ex, int32& ey);
	//��������֮���Ƿ��ֱ����ͨ;
	bool checkStraightPath(int32 sx, int32 sy, int32 ex, int32 ey);
	// ����㷨
	void scanLineSeedFill(int32 x, int32 y, int32 *fill_data);
	// �������
	int fillLineRight(int32 x, int32 y, int32 *fill_data);
	// �������
	int fillLineLeft(int32 x, int32 y, int32 *fill_data);
	// �����µ��������
	void searchLineNewSeed(std::stack<Seed>& stk, int xLeft, int xRight, int y, int32* fill_data);
};

NS_XIANYOU_END

#endif
