return 
{
	[1] = {
		["args"] = {
			
		},
		["cmdName"] = "x_root_node",
		["connectors"] = { },
		["nextpms"] = 2,
	},
	[2] = {
        ["args"] = {
            ["ani_name"] = "skill_0_1",
            ["atom_id"] = "starman",
        },
        ["cmdName"] = "s_role_play_ani",
        ["connectors"] = {
            [1] = { 3, },
        },
    },
    [3] = {
        ["args"] = {
            ["atom_id"] = 1,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileTrack",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveSpeed"] = 5,			--移动速度
					["iRemainFrame"] = 45,		--生命周期
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 2.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 15,
							},
						},
					},
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            
        },
    },
}