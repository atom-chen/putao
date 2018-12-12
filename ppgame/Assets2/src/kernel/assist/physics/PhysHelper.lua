-------------------------
-- tShapeInfo：形状信息
-- Rect = { x=, y=, width=, height= }
-- Circle = { x=, y=, radius= }
-- Sector = { x=, y=, radius=, dir=ONE_PI/4, angle=ONE_PI/6 }
-------------------------
-- tHarmInfo：伤害信息
-------------------------
module("phys", package.seeall)

function CreateRect(x, y, w, h, bodyH)
	return {
		["sShapeType"] = "Rect",
		["tShapeDesc"] = { x=x, y=y, width=w, height=h },
		["iBodyHeight"] = bodyH,
	}
end

function CreateCircle(x, y, r, bodyH)
	return {
		["sShapeType"] = "Circle",
		["tShapeDesc"] = { x=x, y=y, radius=r },
		["iBodyHeight"] = bodyH,
	}
end

-- dir[0,2PI]  angle[0,2PI]
function CreateSector(x, y, r, dir, angle, bodyH)
	return {
		["sShapeType"] = "Circle",
		["tShapeDesc"] = { x=x, y=y, radius=r, dir=dir, angle=angle },
		["iBodyHeight"] = bodyH,
	}
end
