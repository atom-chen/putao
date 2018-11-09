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
            ["ani_name"] = "skill_1",
            ["atom_id"] = "starman",
        },
        ["cmdName"] = "s_role_play_ani",
        ["connectors"] = {
            [15] = { 
            	201,202,203,
            },
            [45] = { 
            	211,212,213,214,215,
            },
        },
    },
    
    [201] = {
        ["args"] = {
            ["atom_id"] = 1,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 0,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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
    [202] = {
        ["args"] = {
            ["atom_id"] = 2,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 120,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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
    [203] = {
        ["args"] = {
            ["atom_id"] = 3,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 240,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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
    
    [211] = {
        ["args"] = {
            ["atom_id"] = 9,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 0,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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
    [212] = {
        ["args"] = {
            ["atom_id"] = 10,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 60,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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
    [213] = {
        ["args"] = {
            ["atom_id"] = 11,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 120,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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
    [214] = {
        ["args"] = {
            ["atom_id"] = 12,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 180,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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
    [215] = {
        ["args"] = {
            ["atom_id"] = 13,
			["owner_atom"] = "starman",
			["tMagicInfo"] = {
				["sMissleType"] = "clsMissileLine",		--运动方式
				--资源路径
				["sResPath"] = "effects/effect_img/huoqiu.png",
				["sResType"] = "Sprite",
				--消亡策略
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["iMoveDir"] = 240,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
				--伤害帧
				["tHarmFrame"] = {
					[0] = {
						["iDamagePower"] = 1.50,
						["iIsSingleAtk"] = 0,
						["AffectFunc"] = {
							["funcName"] = "OnEcForce",
							["param"] = {
								["iSPframe"] = 30,
								["iCZspeed"] = 10,
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