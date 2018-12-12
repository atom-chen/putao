-------------------------
--类型检查
-------------------------
module("gameutil", package.seeall)

function IsValidGender(v) 
	return v==const.GENDER.MALE or v==const.GENDER.FEMALE or v==const.GENDER.UNKNOWN
end

function IsValidCardTypeId(v)
	return setting.T_card_cfg[v], "not valid TypeId"
end

function IsValidAngerPower(v)
	return v>=0 and v<=100
end
