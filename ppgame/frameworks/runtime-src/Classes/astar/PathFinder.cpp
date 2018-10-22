#include "PathFinder.h"
//#include "stlastar.h"
#include "AStarSearch.hpp"
#include "cocos2d.h"
#include <fstream>
using namespace std;

NS_XIANYOU_BEGIN

#define MAP_CELL_SIZE 16

PathFinder* current_pf = NULL;

class MapSearchNode
{
public:

	unsigned int x;	 // the (x,y) positions of the node
	unsigned int y;

	int32 weight;

	MapSearchNode() { x = y = 0; weight = 0; }
	MapSearchNode(unsigned int px, unsigned int py, int32 pw) { x = px; y = py; weight = pw; }

	int32 GoalDistanceEstimate(const MapSearchNode &nodeGoal) const;
	bool IsGoal(const MapSearchNode &nodeGoal) const;
	bool GetSuccessors(AStarSearch<MapSearchNode> *astarsearch, MapSearchNode *parent_node);
	int32 GetCost(const MapSearchNode &successor) const;
	bool IsSameState(const MapSearchNode &rhs) const;

	uint32 getHashCode() const {
		return x + y * current_pf->getWidth();
	};

	int GetMap(int x, int y) const
	{
		if (x < 0 || x >= current_pf->getWidth() || y < 0 || y >= current_pf->getHeight())
		{
			return 1;
		}
		return current_pf->isBlock(x, y) ? 1 : 0;
	}
};

bool MapSearchNode::IsSameState(const MapSearchNode &rhs) const
{
	return (x == rhs.x) && (y == rhs.y);
}

bool MapSearchNode::IsGoal(const MapSearchNode &nodeGoal) const
{
	return (x == nodeGoal.x) && (y == nodeGoal.y);
}

int32 MapSearchNode::GetCost(const MapSearchNode &successor) const
{
	int c = GetMap(successor.x, successor.y);
	if (c == 1)
		return 65535;	//�赲��;

	if (current_pf->getWeight(successor.x, successor.y) > 1)
		return 65535 / 2; //�������赲
	else if (successor.x == x || successor.y == y)
		return 10;		//�ݺ�ֱ��
	else
		return 14;		//�Խ���
}

//����
int32 MapSearchNode::GoalDistanceEstimate(const MapSearchNode &nodeGoal) const
{
	int xd = x - nodeGoal.x;
	int yd = y - nodeGoal.y;
	return (abs(xd) + abs(yd)) * 14;
}


// This generates the successors to the given Node. It uses a helper function called
// AddSuccessor to give the successors to the AStar class. The A* specific initialisation
// is done for each node internally, so here you just set the state information that
// is specific to the application
bool MapSearchNode::GetSuccessors(AStarSearch<MapSearchNode> *astarsearch, MapSearchNode *parent_node)
{
	int parent_x = parent_node ? parent_node->x : -1;
	int parent_y = parent_node ? parent_node->y : -1;

#define CHECK_NEXT(X,Y) if( (GetMap(X,Y)==0) && !((parent_x == X) && (parent_y == Y)) ) astarsearch->AddSuccessor( MapSearchNode( X, Y, current_pf->getWeight(X, Y) ) );

	CHECK_NEXT(x - 1, y - 1);
	CHECK_NEXT(x - 1, y);
	CHECK_NEXT(x - 1, y + 1);
	CHECK_NEXT(x, y + 1);
	CHECK_NEXT(x + 1, y + 1);
	CHECK_NEXT(x + 1, y);
	CHECK_NEXT(x + 1, y - 1);
	CHECK_NEXT(x, y - 1);

	return true;
}

//----------------------------------------------------------------------------------------------------------

PathFinder* PathFinder::getInstance()
{
	if (current_pf == NULL)
	{
		current_pf = new PathFinder();
	}

	return current_pf;
}

PathFinder::PathFinder() : _bx(0), _by(0), _bw(0), _bh(0)
{

}

int16 PathFinder::getWeight(int32 x, int32 y)
{
	//�����Ŀ��㣬����Ȩ������Ϊ0�����õ㸽�����赲ʱ���ִ���ᷢ������;
	//��ΪȨֲ�ǳ����Ŀ���(����)���ᵼ��A·���㼱�����࣬���ֿ�������;
	if (x == _end_x && y == _end_y)
	{
		return 0;
	}

	if (x >= _width || y >= _height)
		return 0;

#ifdef LEFT_TOP
	y = _height - 1 - y;
#endif

	int16& weight = _blocks_weight[y*_width + x];

	//��������ͼ�߽��򷵻ز�����;
	if (x<2 || x>_width - 3 || y<2 || y>_height - 3)
		return 65535;

	//���ݸ��Ӹ������赲��������������ӵ�Ȩ�أ�Ȩ��Խ�󣬱�A��ѡ������ȼ�Խ��;
	if (weight == 0)
	{
#define CHECK_BLOCK(i, j) { if (_blocks[(y+j)*_width + x + i] == '1') weight++; }

		//CHECK_BLOCK(-1, 1);
		CHECK_BLOCK(0, 1);
		//CHECK_BLOCK(1, 1);
		CHECK_BLOCK(-1, 0);
		CHECK_BLOCK(1, 0);
		//CHECK_BLOCK(-1, -1);
		CHECK_BLOCK(0, -1);
		//CHECK_BLOCK(1, -1);

		weight++;
	}

	//printf("get weight:%d:%d -> %d\n", x, y, weight);
	return weight;
}

void PathFinder::createBlock(uint32 wid, uint32 hei)
{
	_ver = 1;
	_width = wid;
	_height = hei;

	printf("create_block ver=%d width=%d height=%d\n", _ver, _width, _height);

	setBound(0, 0, _width, _height);

	uint32 size = _width * _height;

	_blocks.resize(size);
	memset(&_blocks[0], '0', size*sizeof(int8));

	_ref_blocks.resize(size);
	memset(&_ref_blocks[0], 0, size*sizeof(int8));

	_blocks_weight.resize(size);
	memset(&_blocks_weight[0], 0, size*sizeof(int16));

	_terrain_blocks.resize(size);
	memset(&_terrain_blocks[0], 0, size*sizeof(int8));
}

bool PathFinder::loadBlock(const char* path)
{
	std::string fullpath = cocos2d::FileUtils::getInstance()->fullPathForFilename(path);
	ssize_t filesize;
	unsigned char *content = cocos2d::FileUtils::getInstance()->getFileData(path, "rb", &filesize);
	if (content == nullptr)
	{
		_width = 0;
		_height = 0;
		return false;
	}

	_ver = *(uint32 *)(content);
	content += 4;
	_width = *(uint32 *)(content);
	content += 4;
	_height = *(uint32 *)(content);
	content += 4;

	printf("load_block ver=%d width=%d height=%d\n", _ver, _width, _height);

	setBound(0, 0, _width, _height);

	uint32 size = _width * _height;

	_blocks.resize(size);
	memcpy(&_blocks[0], content, size*sizeof(int8));

	_ref_blocks.resize(size);
	memset(&_ref_blocks[0], 0, size*sizeof(int8));

	_blocks_weight.resize(size);
	memset(&_blocks_weight[0], 0, size*sizeof(int16));

	_terrain_blocks.resize(size);
	memset(&_terrain_blocks[0], 0, size*sizeof(int8));

	return true;
}

bool PathFinder::saveBlock(const char* path)
{
	std::ofstream f(path, std::ios::binary);
	if (!f)
		return false;

	uint32 ver = 1;
	f.write((char*)&ver, sizeof(uint32));
	f.write((char*)&_width, sizeof(_width));
	f.write((char*)&_height, sizeof(_height));
	f.write(&_blocks[0], _width*_height*sizeof(int8));
	f.close();
	return true;
}

void PathFinder::setBound(uint32 x, uint32 y, uint32 w, uint32 h)
{
	_bx = x;
	_by = y;
	_bw = (x + w) > _width ? _width : (x + w);
	_bh = (y + h) > _height ? _height : (y + h);
}

// �赲�ļ������Ͻ�Ϊԭ�㣬����������Ϊԭ�㣬������Ҫתһ��;
bool PathFinder::isBlock(int32 x, int32 y)
{
	if (x < _bx || x >= _bw)
		return true;

	if (y < _by || y >= _bh)
		return true;

#ifdef LEFT_TOP
	y = _height - 1 - y;
#endif

	int32 index = y*_width + x;

	return _blocks[index] == '1' || _ref_blocks[index] > 0;
}

bool PathFinder::setBlock(int32 x, int32 y, bool bblock)
{
	if (x < 0 || x >= _width)
		return false;

	if (y < 0 || y >= _height)
		return false;

#ifdef LEFT_TOP
	y = _height - 1 - y;
#endif

	_blocks[y*_width + x] = bblock ? '1' : '0';
	return true;
}

void PathFinder::setTerrain(int32 x, int32 y, int32 terrain)
{
	if (x < 0 || x >= _width)
		return;

	if (y < 0 || y >= _height)
		return;

#ifdef LEFT_TOP
	y = _height - 1 - y;
#endif

	_terrain_blocks[y*_width + x] = terrain;
}

int32 PathFinder::getTerrain(int32 x, int32 y)
{
	if (x < 0 || x >= _width)
		return 0;

	if (y < 0 || y >= _height)
		return 0;

#ifdef LEFT_TOP
	y = _height - 1 - y;
#endif

	return _terrain_blocks[y*_width + x];
}

bool PathFinder::addBlockRef(int32 x, int32 y, bool bblock)
{
	if (x < 0 || x >= _width)
		return false;

	if (y < 0 || y >= _height)
		return false;

#ifdef LEFT_TOP
	y = _height - 1 - y;
#endif

	int8 ref = _ref_blocks[y*_width + x];
	_ref_blocks[y*_width + x] += (bblock) ? 1 : -1;

	return true;
}

//dist��λΪ����;
bool PathFinder::findPath(int32 sx, int32 sy, int32 ex, int32 ey, int32 dist)
{
	//�ȿ����Ƿ�Ϊ�赲�㣬������Ѱ�Ҹ���һ�����е㣬��������Χû�ҵ���Ѱ·;
	if (!_search_near(sx, sy, ex, ey))
		return false;

	float t_ex = ex, t_ey = ey;

	if (ex < 0 || ey < 0 || ex > _width - 1 || ey > _height - 1)
		return false;

	_xlist.clear();
	_ylist.clear();

	//�����Ȼû�ҵ����е���ֱ�ӷ��أ���Ҫ��һ���������A��Ѱ·������Ῠһ��;
	if (isBlock(ex, ey))
		return false;

	//*****************************************************************
	//�������赲��Ѱ·ʱ��������;
	//��¼�±���Ѱ·��Ŀ��㣬��getWeight()�н�Ŀ����Ȩ�ط���0;
	//�����赲�ĸ��ӱ������˺ܴ��Ȩ�أ���65535/2����ᵼ�¸�Ŀ��㸽��;
	//����������Ȩ�ض���Ŀ���ͣ����A�ǻ�������Ŀ���֮�伸�����е�;
	//·�����������ѡ��Ŀ��㣬���ܺ�ʱ�����ǿ���ԭ������;
	_end_x = ex;
	_end_y = ey;

	AStarSearch<MapSearchNode> astarsearch;
	astarsearch.SetStartAndGoalStates(MapSearchNode(sx, sy, getWeight(sx, sy)), MapSearchNode(ex, ey, getWeight(ex, ey)));

	unsigned int SearchState;
	//	unsigned int SearchSteps = 0;

	do
	{
		SearchState = astarsearch.SearchStep();
		//		SearchSteps++;
	} while (SearchState == AStarSearch<MapSearchNode>::SEARCH_STATE_SEARCHING);

	if (SearchState == AStarSearch<MapSearchNode>::SEARCH_STATE_SUCCEEDED)
	{
		for (MapSearchNode *node = astarsearch.GetSolutionStart(); node; node = astarsearch.GetSolutionNext())
		{
			_xlist.push_back(node->x);
			_ylist.push_back(node->y);
		};

		//astarsearch.FreeSolutionNodes();
		//astarsearch.EnsureMemoryFreed();

		if (_xlist.size() > 0)
			optimizePath(_xlist, _ylist);

		return true;

	}
	else
	{
		::printf("Search terminated. Did not find goal state\n");
		//astarsearch.EnsureMemoryFreed();
		return false;

	}
}

bool PathFinder::_search_near(int32 sx, int32 sy, int32& ex, int32& ey)
{
	//��������赲�ϣ�����Ѱ��һ������Ŀ��е�;
	if (isBlock(ex, ey))
	{
		//return search_near_cross(sx, sy, ex, ey);
		return searchNearRect(ex, ey);
	}
	return true;
}

//ʮ��Ѱ���赲������Ŀ��е�;
bool PathFinder::searchNearCross(int32& ex, int32& ey)
{
	uint32 uwid = getWidth();
	uint32 uht = getHeight();
	int32 N = 30; //ʮ�ַ�������������̽Ѱ30������;
	int32 inear = INT_MAX;
	int32 xnear = INT_MAX, ynear = INT_MAX;
	int32 ict1 = 0, ict2 = 0;
	bool bs = false;
	for (int32 i = 1; i < N; ++i)
	{
		if (ey + i < uht && !isBlock(ex, ey + i))
		{
			ict1++;
			//ע�⣺���ӵ�Ȩ��Խ��A�Ƕ���Ѱ·ʱ��costԽ���Ż��ȼ�Խ��;
			//���赲Զһ�㣬��Ϊ�赲��Χ�ĵ�Ȩ�ؽϴ���A��ʱ���ܵ�һ���̶ȵġ�Ѱ·������;
			//��Զ2�����ӿ��Ա����������֡���������ǰ����Ŀ����Ȩ�غ�С����0;
			if (ict1 > 2)
			{
				if (i < inear)
				{
					inear = i;
					xnear = ex;
					ynear = ey + i;
					bs = true;
					break;
				}

			}
		}
	}
	for (int32 i = 1; i < N; ++i)
	{
		if (ey - i>0 && !isBlock(ex, ey - i))
		{
			ict2++;
			if (ict2 > 2)
			{
				if (i < inear){
					inear = i;
					xnear = ex;
					ynear = ey - i;
					bs = true;
					break;
				}

			}
		}
	}
	ict1 = 0; ict2 = 0;
	for (int32 i = 1; i < N; ++i)
	{
		if (ex - i > 0 && !isBlock(ex - i, ey))
		{
			ict1++;
			if (ict1 > 2)
			{
				if (i < inear)
				{
					inear = i;
					xnear = ex - i;
					ynear = ey;
					bs = true;
					break;
				}
			}
		}
	}
	for (int32 i = 1; i < N; ++i)
	{
		if (ex + i < uwid && !isBlock(ex + i, ey))
		{
			ict2++;
			if (ict2 > 2)
			{
				if (i < inear)
				{
					inear = i;
					xnear = ex + i;
					ynear = ey;
					bs = true;
					break;
				}
			}
		}
	}

	ex = xnear;
	ey = ynear;
	return bs;
}

bool PathFinder::searchNearRect(int32& ex, int32& ey)
{
	bool is_ok = false;

	int i = 1;

	// ��ex, eyΪ���ģ�����ѰʮȦ���Σ���Ȼ�Ѳ�������Ϊʧ�ܡ�
	while (i<10)
	{
		for (int k = -i; k <= i; k += 2)
		{
			for (int j = -i; j <= i; j += 2)
			{
				if (!isBlock(ex + k, ey + j))
				{
					ex += k;
					ey += j;
					is_ok = true;
					goto fixed;
				}
			}
		}

		i++;
	}
fixed:
	printf("adjust \n");

	return is_ok;
}

void PathFinder::optimizePath(vector<int32>& xlst, vector<int32>& ylst)
{
	vector<int32> path_x_op;
	vector<int32> path_y_op;
	path_x_op.push_back(xlst[0]);
	path_y_op.push_back(ylst[0]);
	int32 i0 = 0;


	if (xlst.size() == 2)
	{
		path_x_op.push_back(xlst[1]);
		path_y_op.push_back(ylst[1]);
	}

	for (int32 i = 2; i<xlst.size(); ++i)
	{
		//��ֹ��ѭ���ı�ʶ����;
		bool bsteped = false;

		while (i<xlst.size() && checkStraightPath(xlst[i0], ylst[i0], xlst[i], ylst[i]))
		{
			//���������յ��Ƿ����ֱ�����������п���ֱ���ĵ㣬ֱ���ҵ�һ������ֱ���ģ���ʱ���ҵ���һ�ο�ֱ�����·��;
			//Ȼ�����Դ�·�ε��յ�Ϊ���Ѱ����һ�����ֱ��·��;
			i++;
			bsteped = true;
		}

		//�ű��м������ﳯ����㷨�ǣ���·�������е㣬���μ�����������������,�ɴ˵õ�һ���Ƕ�;
		//·�������õĶ��Ǹ������꣬������������ݺ���ֵ��ת��������ʵ������ʱ�ǰ�������������;
		//����ԭʼ��A��·����ÿ�����ӵ���һ������һ���������ھŹ���İ˸���Χ����֮һ;
		//��ˣ���ԭʼ·������õ����������ﳯ��ֻ�а˸�����·���Ż���������и��෽�򣬵��������⳯���;
		//·���Ż�����Ҫ���ְ˷�������ֻ�뱣֤·����������㲻�Ż�����;

		//******************************************************************************
		//�����в�ע�����������ճ���ֻ�а˸�����;
		//path_x_op.push_back(xlst[i-2]);
		//path_y_op.push_back(ylst[i-2]);
		//******************************************************************************

		path_x_op.push_back(xlst[i - 1]);
		path_y_op.push_back(ylst[i - 1]);

		i0 = i - 1;

		if (bsteped)i--;
	}

	xlst.clear();
	ylst.clear();

	xlst = path_x_op;
	ylst = path_y_op;
}

//(sx, sy)Ϊ��������ϵ�µĸ�������(ÿ���ӳ���Ϊ��λ1),��ͼ���½�Ϊԭ�㣬������������;
bool PathFinder::checkStraightPath(int32 sx, int32 sy, int32 ex, int32 ey)
{
	//��0.5ת������������;��Ϊʵ��Ѱ·ʱ���߸������ĵ�
	float fsx = sx + 0.5f;
	float fsy = sy + 0.5f;
	float fex = ex + 0.5f;
	float fey = ey + 0.5f;

	float fdx = fex - fsx;
	float fdy = fey - fsy;

	int32 dx = abs(ex - sx);
	int32 dy = abs(ey - sy);

	int32 W = current_pf->getWidth();
	int32 H = current_pf->getHeight();

	//�ж�ֱ�߾����ĸ����Ƿ����赲;
	if (dx == dy)	//����ȡ����dx=dy�����Ҫ�����ж�;
	{
		if (sx < ex)
		{
			if (sy < ey)
			{
				for (int32 ix = sx, iy = sy; ix <= ex; ++ix, ++iy)
				{
					if (isBlock(ix, iy)) return false;
				}
			}
			else
			{
				for (int32 ix = sx, iy = sy; ix <= ex; ++ix, --iy)
				{
					if (isBlock(ix, iy)) return false;
				}
			}
		}
		else
		{
			if (sy < ey)
			{
				for (int32 ix = sx, iy = sy; ix >= ex; --ix, ++iy)
				{
					if (isBlock(ix, iy)) return false;
				}
			}
			else
			{
				for (int32 ix = sx, iy = sy; ix >= ex; --ix, --iy)
				{
					if (isBlock(ix, iy)) return false;
				}
			}
		}
	}
	else if (dx > dy)
	{
		//ֱ�߹�ʽ: y = fk * x + fb
		float fk = fdy / fdx;
		float fb = fsy - fsx*fk;
		int32 t_iy;

		if (sx < ex)
		{
			for (int32 ix = sx + 1; ix <= ex; ++ix)
			{
				t_iy = (int32)(fk * ix + fb);
				if (ix - 1 >= 0 && t_iy - 1 >= 0 && t_iy + 1 < H)
				{//��ֱ�߸����������ز��������ֻ����ֱ���ϵĵ��ز�������ĳЩ����²ɵ����赲�ĸ���;
					//����Ҳ����ʹ��ɫ��ת��ʱ��ΪԲת�������Եú���Ӳ;
					if ((isBlock(ix - 1, t_iy) || isBlock(ix, t_iy)) ||
						isBlock(ix - 1, t_iy + 1) || isBlock(ix, t_iy + 1) ||
						isBlock(ix - 1, t_iy - 1) || isBlock(ix, t_iy - 1))
					{
						return false;
					}
				}

			}
		}
		else
		{
			for (int32 ix = sx; ix>ex; --ix)
			{
				t_iy = (int32)(fk * ix + fb);
				if (ix - 1 >= 0 && t_iy - 1 >= 0 && t_iy + 1 < H)
				{//���ز���;
					if (isBlock(ix - 1, t_iy) || isBlock(ix, t_iy) ||
						isBlock(ix - 1, t_iy + 1) || isBlock(ix, t_iy + 1) ||
						isBlock(ix - 1, t_iy - 1) || isBlock(ix, t_iy - 1))
					{
						return false;
					}
				}
			}
		}
	}
	else
	{
		float fk = fdx / fdy;
		float fb = fsx - fsy*fk;
		int32 t_ix;

		if (sy < ey)
		{
			for (int32 iy = sy + 1; iy <= ey; ++iy)
			{
				t_ix = (int32)(fk * iy + fb);

				if (iy - 1 >= 0 && t_ix - 1 >= 0 && t_ix + 1 < W)
				{//���ز���;
					if (isBlock(t_ix, iy - 1) || isBlock(t_ix, iy) ||
						isBlock(t_ix + 1, iy - 1) || isBlock(t_ix + 1, iy) ||
						isBlock(t_ix - 1, iy - 1) || isBlock(t_ix - 1, iy))
					{
						return false;
					}
				}
			}
		}
		else
		{
			for (int32 iy = sy; iy>ey; --iy)
			{
				t_ix = (int32)(fk * iy + fb);
				if (iy - 1 >= 0 && t_ix - 1 >= 0 && t_ix + 1 < W)
				{//���ز���;
					if (isBlock(t_ix, iy - 1) || isBlock(t_ix, iy) ||
						isBlock(t_ix + 1, iy - 1) || isBlock(t_ix + 1, iy) ||
						isBlock(t_ix - 1, iy - 1) || isBlock(t_ix - 1, iy))
					{
						return false;
					}
				}
			}
		}
	}
	return true;
}

bool PathFinder::checkSameArea(int32 sx, int32 sy, int32& ex, int32& ey)
{
	// Խ���ˣ�����Ѱ·�㷨����
	if (ex < 0 || ey < 0 || ex > _width - 1 || ey > _height - 1)
		return true;

	if (sx < 0 || sy < 0 || sx > _width - 1 || sy > _height - 1)
		return true;

	// �㵽�赲��
	_search_near(sx, sy, ex, ey);
	if (isBlock(ex, ey)) return false;

	int32 *fill_data = new int32[_width*_height];
	memset(fill_data, 0, sizeof(int32)*_width*_height);
	scanLineSeedFill(ex, ey, fill_data);

	bool is_same = true;
	if (fill_data[sy*_width + sx] != fill_data[ey*_width + ex])
		is_same = false;

	if (fill_data)
		delete[]fill_data;

	return is_same;
}

void PathFinder::scanLineSeedFill(int32 x, int32 y, int32 *fill_data)
{
	std::stack<Seed> stk;		// ��������ջ
	stk.push(Seed(x, y));		// ������ջ

	while (!stk.empty())
	{
		Seed seed = stk.top();	// ȡ��ǰ����
		stk.pop();

		// �������
		int count = fillLineRight(seed.x, seed.y, fill_data);
		// �����������
		int xRight = seed.x + count - 1;

		// �������
		count = fillLineLeft(seed.x - 1, seed.y, fill_data);
		// �����������
		int xLeft = seed.x - count;

		// �������ڵ�����ɨ����
		if (seed.y - 1 >= 0)
			searchLineNewSeed(stk, xLeft, xRight, seed.y - 1, fill_data);
		if (seed.y + 1 <= _height - 1)
			searchLineNewSeed(stk, xLeft, xRight, seed.y + 1, fill_data);
	}
}

int PathFinder::fillLineLeft(int32 x, int32 y, int32 *fill_data)
{
	// Խ����
	if (x < 0 || x > _width - 1 || y < 0 || y > _height - 1)
		return 0;

	int p_x = x;
	int p_y = y;
	int count = 0;
	bool is_block_temp = isBlock(p_x, p_y);
	int32 _fill_data = fill_data[p_y*_width + p_x];

	while (_fill_data == 0 && !is_block_temp)
	{
		fill_data[p_y*_width + p_x] = 1;
		count++;
		p_x--;
		if (p_x < 0)
			break;
		_fill_data = fill_data[p_y*_width + p_x];
		is_block_temp = isBlock(p_x, p_y);
	}
	return count;
}

int PathFinder::fillLineRight(int32 x, int32 y, int32 *fill_data)
{
	// Խ����
	if (x < 0 || x > _width - 1 || y < 0 || y > _height - 1)
		return 0;

	int p_x = x;
	int p_y = y;
	int count = 0;
	bool is_block_temp = isBlock(p_x, p_y);
	int32 _fill_data = fill_data[p_y*_width + p_x];

	while (_fill_data == 0 && !is_block_temp)
	{
		fill_data[p_y*_width + p_x] = 1;
		count++;
		p_x++;
		if (p_x > _width - 1)
			break;
		_fill_data = fill_data[p_y*_width + p_x];
		is_block_temp = isBlock(p_x, p_y);
	}
	return count;
}

void PathFinder::searchLineNewSeed(std::stack<Seed>& stk, int xLeft, int xRight, int y, int32* fill_data)
{
	int xt = xLeft;
	bool findNewSeed = false;

	while (xt < xRight)
	{
		findNewSeed = false;
		// �������������ұߵ���Ϊ�����ӵ�
		while (fill_data[y*_width + xt] != 1 && !isBlock(xt, y) && xt < xRight)
		{
			findNewSeed = true;
			xt++;
		}

		// �ҵ������ӵ㣬��ջ
		if (findNewSeed)
		{
			if (fill_data[y*_width + xt] != 1 && !isBlock(xt, y) && (xt == xRight))
				stk.push(Seed(xt, y));
			else
				stk.push(Seed(xt - 1, y));
		}

		while ((fill_data[y*_width + xt] == 1 || isBlock(xt, y)) && xt <= xRight)
		{
			xt++;
		}

		if (xt >= _width - 1)
			break;
	}
}

NS_XIANYOU_END
