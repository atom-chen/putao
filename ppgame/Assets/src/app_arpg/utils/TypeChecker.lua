-------------------------
--类型检查
-------------------------
module("gameutil", package.seeall)

function IsValidGender(v) 
	assert(v==const.GENDER.MALE or v==const.GENDER.FEMALE or v==const.GENDER.UNKNOWN)
end

function IsValidCardTypeId(v)
	assert(setting.T_card_cfg[v])
end

function IsValidAngerPower(v)
	assert(v>=0 and v<=100)
end
