
--------------------------------
-- @module PathFinder
-- @extend Ref
-- @parent_module xianyou

--------------------------------
-- 
-- @function [parent=#PathFinder] setBound 
-- @param self
-- @param #unsigned int x
-- @param #unsigned int y
-- @param #unsigned int w
-- @param #unsigned int h
-- @return PathFinder#PathFinder self (return value: xianyou.PathFinder)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getWidth 
-- @param self
-- @return unsigned int#unsigned int ret (return value: unsigned int)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] setTerrain 
-- @param self
-- @param #int x
-- @param #int y
-- @param #int terrain
-- @return PathFinder#PathFinder self (return value: xianyou.PathFinder)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] isBlock 
-- @param self
-- @param #int x
-- @param #int y
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] saveBlock 
-- @param self
-- @param #char path
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getHeight 
-- @param self
-- @return unsigned int#unsigned int ret (return value: unsigned int)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] addBlockRef 
-- @param self
-- @param #int x
-- @param #int y
-- @param #bool bblock
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] findPath 
-- @param self
-- @param #int sx
-- @param #int sy
-- @param #int ex
-- @param #int ey
-- @param #int dist
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getSize 
-- @param self
-- @return unsigned int#unsigned int ret (return value: unsigned int)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] setBlock 
-- @param self
-- @param #int x
-- @param #int y
-- @param #bool bblock
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getXList 
-- @param self
-- @return array_table#array_table ret (return value: array_table)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getYList 
-- @param self
-- @return array_table#array_table ret (return value: array_table)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] createBlock 
-- @param self
-- @param #unsigned int wid
-- @param #unsigned int hei
-- @return PathFinder#PathFinder self (return value: xianyou.PathFinder)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getWeight 
-- @param self
-- @param #int x
-- @param #int y
-- @return short#short ret (return value: short)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] loadBlock 
-- @param self
-- @param #char path
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getTerrain 
-- @param self
-- @param #int x
-- @param #int y
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] getInstance 
-- @param self
-- @return PathFinder#PathFinder ret (return value: xianyou.PathFinder)
        
--------------------------------
-- 
-- @function [parent=#PathFinder] PathFinder 
-- @param self
-- @return PathFinder#PathFinder self (return value: xianyou.PathFinder)
        
return nil
