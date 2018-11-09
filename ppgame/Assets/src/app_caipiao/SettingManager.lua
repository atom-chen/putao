-------------------------
-- 配置表
-------------------------
module("setting", package.seeall)

T_lhc_sx = setting.Get("app_caipiao.configs.T_lhc_sx")
T_k3_wanfa_tip = setting.Get("app_caipiao.configs.T_k3_wanfa_tip")
T_all_wanfa = setting.Get("app_caipiao.configs.T_all_wanfa")
T_peilv_files = setting.Get("app_caipiao.configs.T_peilv_files")
T_game_cfg = setting.Get("app_caipiao.configs.T_game_cfg")

function GetPeilvCfg(key)
	if not key then return nil end
	if T_peilv_files[key] then
		return setting.Get(T_peilv_files[key])
	else
		print("配置表中没有该赔率表：", key)
	end
	return nil
end
