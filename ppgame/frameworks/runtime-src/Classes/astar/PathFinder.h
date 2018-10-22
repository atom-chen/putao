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
	vector<int32> _xlist;	//存放寻路结果
	vector<int32> _ylist;	//存放寻路结果
	int32 _end_x;			//寻路目标点
	int32 _end_y;			//寻路目标点
	// MapBlock
	vector<int8> _blocks;			//阻挡数据
	vector<int16> _blocks_weight;	//表示该点周围的阻挡点的总数目
	vector<int8> _ref_blocks;		//？？？
	vector<int8> _terrain_blocks;	//地形数据
	uint32 _ver, _width, _height;	//MapBlock版本，宽，高
	uint32 _bx, _by, _bw, _bh;		//设置MapBlock寻路时的范围，默认为0,0,_width,_height

	// 种子结构
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
	//A星路径优化，解决掩码(block)边界寻路抖动，直连点却绕弯走的不合理现象;
	void optimizePath(vector<int32>& xlst, vector<int32>& ylst);
	//点击到阻挡点时，向四周寻找可到达的点;
	bool searchNearCross(int32& ex, int32& ey);
	bool searchNearRect(int32& ex, int32& ey);
	// 因为有些地图有死路，当点到死路时，寻路太卡，在这里先检测是否死路
	bool checkSameArea(int32 sx, int32 sy, int32& ex, int32& ey);

private:
	// 点到阻挡时，搜索周边可走区域
	bool _search_near(int32 sx, int32 sy, int32& ex, int32& ey);
	//测试两点之间是否可直线相通;
	bool checkStraightPath(int32 sx, int32 sy, int32 ex, int32 ey);
	// 填充算法
	void scanLineSeedFill(int32 x, int32 y, int32 *fill_data);
	// 向右填充
	int fillLineRight(int32 x, int32 y, int32 *fill_data);
	// 向左填充
	int fillLineLeft(int32 x, int32 y, int32 *fill_data);
	// 搜索新的填充种子
	void searchLineNewSeed(std::stack<Seed>& stk, int xLeft, int xRight, int y, int32* fill_data);
};

NS_XIANYOU_END

#endif
