-------------------------
-- A星寻路
-------------------------
module("utils", package.seeall)

function GetPathFinder()
	return xianyou.PathFinder:getInstance()
end

-- sx sy dx dy distance 都为像素坐标
function FindPath(sx, sy, dx, dy, distance)
	if not VVDirector:GetMap() then return nil end
	if distance == nil then distance = 0 end
	
	if not VVDirector:GetMap():IsLoadblockSucc() then 
		return FindStraightPath(sx, sy, dx, dy, distance)
	end
	
	if (dx-sx)*(dx-sx) + (dy-sy)*(dy-sy) <= distance * distance then 
		return {
			get_next = function(self, inc)
				return sx, sy, nil, true
			end,
		}
	end
	
	local sxGrid, syGrid = VVDirector:GetMap():WorldPos_2_GridPos(sx,sy)
	local dxGrid, dyGrid = VVDirector:GetMap():WorldPos_2_GridPos(dx,dy)
	local pPathFinder = xianyou.PathFinder:getInstance()
	local bSucc = pPathFinder:findPath(sxGrid, syGrid, dxGrid, dyGrid, distance)
	if not bSucc then logger.error("寻路失败") return nil end
	local xlist = pPathFinder:getXList()
	local ylist = pPathFinder:getYList()
	
	-- 生成路径
	local roadPath = {
		_curX = sx,
		_curY = sy,
		_curPoint = 0,
		get_next = function(self, inc)
			local nextPt = self._curPoint + 1
			local nextX, nextY = VVDirector:GetMap():GridPos_2_WorldPos(xlist[nextPt], ylist[nextPt])
			nextX, nextY = nextX+8, nextY+8
			if (nextX-self._curX)*(nextX-self._curX) + (nextY-self._curY)*(nextY-self._curY) > inc * inc then
				local dir = math.Vector2Radian(nextX-self._curX, nextY-self._curY)
				self._curX = self._curX + inc*math.cos(dir)
				self._curY = self._curY + inc*math.sin(dir)
				return self._curX, self._curY, dir, false
			else
				local dir = math.Vector2Radian(nextX-self._curX, nextY-self._curY)
				self._curX = nextX
				self._curY = nextY
				self._curPoint = nextPt
				return self._curX, self._curY, dir, self._curPoint==#xlist
			end
		end,
	}
	
	return roadPath
end

-- 没有地图阻挡时，采用该接口
-- sx sy dx dy distance 都为像素坐标
function FindStraightPath(sx, sy, dx, dy, distance)
	if distance == nil then distance = 0 end
	
	local X, Y = dx-sx, dy-sy
	local LenSqure = X*X + Y*Y
	local disSqure = distance * distance
	if LenSqure <= disSqure then 
		return {
			get_next = function(self, inc)
				return sx, sy, math.Vector2Radian(X, Y), true
			end
		}
	end
	
	
	local dir = math.Vector2Radian(X, Y)
	-- 生成路径
	local roadPath = {
		iPathedLen = 0,
		get_next = function(self, inc)
			self.iPathedLen = self.iPathedLen + inc
			local curDir = dir
			
			if self.iPathedLen*self.iPathedLen >= LenSqure-disSqure then
				self.iPathedLen = math.sqrt(LenSqure-disSqure)
				return sx+self.iPathedLen*math.cos(dir), sy+self.iPathedLen*math.sin(dir), curDir, true
			else
				return sx+self.iPathedLen*math.cos(dir), sy+self.iPathedLen*math.sin(dir), curDir, false
			end
		end,
	}
	
	return roadPath
end

--沿某方向直线移动，遇到障碍点则停止
function FindLinePath(sx, sy, iDir, iSpeed, iDistance)
	
end