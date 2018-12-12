return 
{
    [1] = {
        ["args"] = {
            ["sNodeName"] = "测试剧情1",
        },
        ["cmdName"] = "x_root_node",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 101.000000,
            },
        },
    },
    [101] = {
        ["args"] = {
            ["seconds"] = 4,
			["degree"] = 20,
        },
        ["cmdName"] = "s_shake_screen",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 2,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [2] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["dx"] = 200.000000,
            ["dy"] = 100.000000,
        },
        ["cmdName"] = "s_role_rush_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 3.000000,
            },
            ["ec_xstart"] = {
            	[1] = 200,
            },
        },
    },
    [200] = {
    	["args"] = {
    		["atom_id"] = "starman",
    		["words"] = "你个混蛋！为什么受伤的老是我",
    	},
    	["cmdName"] = "s_pop_say",
    	["connectors"] = {},
    },
    [3] = {
        ["args"] = {
            ["ani_name"] = "hit",
            ["atom_id"] = "starman",
        },
        ["cmdName"] = "s_role_play_ani",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 4.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [4] = {
        ["args"] = {
            ["seconds"] = 2.000000,
        },
        ["cmdName"] = "x_delay_time",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 5.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [5] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["dx"] = 0.000000,
            ["dy"] = 0.000000,
        },
        ["cmdName"] = "s_role_face_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 6.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [6] = {
        ["args"] = {
            ["iBlackScreen"] = 1.000000,
            ["iKeepSeconds"] = 1.000000,
        },
        ["cmdName"] = "s_black_screen",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 7.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [7] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["seconds"] = 1.000000,
            ["stepx"] = 100.000000,
            ["stepy"] = 0.000000,
        },
        ["cmdName"] = "x_move_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 8.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [8] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["seconds"] = 0.500000,
            ["stepx"] = -100.000000,
            ["stepy"] = 0.000000,
        },
        ["cmdName"] = "x_move_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 9.000000,
                [2] = 11,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [9] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["scaleX"] = 2.000000,
            ["scaleY"] = 2.000000,
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_scale_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 10.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [10] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["scaleX"] = 1.000000,
            ["scaleY"] = 1.000000,
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_scale_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 14.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [11] = {
        ["args"] = {
            ["atom_id"] = 1.000000,
            ["iShapeId"] = 32000.000000,
            ["x"] = 310.000000,
            ["y"] = 110.000000,
        },
        ["cmdName"] = "z_create_role",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 12.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [12] = {
        ["args"] = {
            ["seconds"] = 2.000000,
        },
        ["cmdName"] = "x_delay_time",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 110,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [110] = {
    	["args"] = {
    		["atom_id"] = 1,
			["skill_index"] = 1,
			["times"] = 1,
    	},
    	["cmdName"] = "s_play_skill",
    	["connectors"] = {
    		["ec_xfinish"] = {
    			[1] = 112,
    		},
    		["ec_xstart"] = {
    		},
    	},
    },
    [112] = {
        ["args"] = {
            ["atom_id"] = 1,
            ["dx"] = 400.000000,
            ["dy"] = 300.000000,
        },
        ["cmdName"] = "s_role_walk_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 113.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [113] = {
        ["args"] = {
            ["seconds"] = 0,
        },
        ["cmdName"] = "x_delay_time",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 13,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [13] = {
        ["args"] = {
            ["atom_id"] = 1.000000,
        },
        ["cmdName"] = "z_destroy_role",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
                [1] = 14.000000,
            },
        },
    },
    [14] = {
        ["args"] = {
            ["atom_id"] = 2.000000,
            ["res_path"] = "effects/effect_seq/bingpo.plist",
            ["x"] = 250.000000,
            ["y"] = 250.000000,
        },
        ["cmdName"] = "z_create_effect",
        ["connectors"] = {
            [30] = {
                [1] = 15.000000,
            },
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            },
        },
    },
    [15] = {
        ["args"] = {
            ["atom_id"] = 2.000000,
        },
        ["cmdName"] = "z_destroy_effect",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 16.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [16] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
			["toAngle"] = 120,
        },
        ["cmdName"] = "x_rotate_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 17,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [17] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 0.5,
			["Angle"] = -120,
        },
        ["cmdName"] = "x_rotate_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 18,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [18] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["SkewX"] = 40,
			["SkewY"] = -40,
			["seconds"] = 1,
        },
        ["cmdName"] = "x_skew_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 19,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [19] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["deltaSkewX"] = -40,
			["deltaSkewY"] = 40,
			["seconds"] = 1,
        },
        ["cmdName"] = "x_skew_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 20,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [20] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
			["dstX"] = 40,
			["dstY"] = 40,
			["jmpHeight"] = 100,
			["jmpTimes"] = 1,
        },
        ["cmdName"] = "x_jump_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 21,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [21] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
			["deltaX"] = 400,
			["deltaY"] = 100,
			["jmpHeight"] = 200,
			["jmpTimes"] = 1,
        },
        ["cmdName"] = "x_jump_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1]=22,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [22] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 2,
			["tension"] = 0.5,
			["pt_list"] = {
				{x=0, y=0},
				{x=277, y=0},
				{x=277, y=556},
				{x=0, y=222},
				{x=0, y=0},
				{x=222, y=666},
			},
        },
        ["cmdName"] = "x_cardinal_spline_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 23,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [23] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
        },
        ["cmdName"] = "x_fade_out",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 24,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [24] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
        },
        ["cmdName"] = "x_fade_in",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 25,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [25] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
			["times"] = 15,
        },
        ["cmdName"] = "x_blink",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 26,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [26] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
			["r"] = 15,
			["g"] = 244,
			["b"] = 133,
        },
        ["cmdName"] = "x_tint_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 27,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [27] = {
        ["args"] = {
            ["atom_id"] = "starman",
			["seconds"] = 1,
			["deltaR"] = 15,
			["deltaG"] = 244,
			["deltaB"] = 133,
        },
        ["cmdName"] = "x_tint_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 28,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [28] = {
        ["args"] = {
            ["atom_id"] = 3,
			["panel_clsname"] = "clsBenefitUI",
			["x"] = 500,
			["y"] = 400,
        },
        ["cmdName"] = "z_create_panel",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 29,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [29] = {
        ["args"] = {
            ["seconds"] = 2.000000,
        },
        ["cmdName"] = "x_delay_time",
        ["connectors"] = {
            ["ec_xfinish"] = {
            --    [1] = 2901.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    --[[
    [2901] = {
    	["args"] = {
    		["func"] = function() print("x_callfunc: 我是一只小小鸟") end,
    	},
    	["cmdName"] = "x_callfunc",
    	["connectors"] = {
    		["ec_xfinish"] = {
    			[1] = 30,
    		},
    	}
    },
    [30] = {
        ["args"] = {
            ["atom_id"] = 3.000000,
        },
        ["cmdName"] = "z_destroy_panel",
        ["connectors"] = {
            ["ec_xfinish"] = {
            	[1] = 31,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [31] = {
        ["args"] = {
            ["seconds"] = 4,
			["degree"] = 20,
        },
        ["cmdName"] = "s_shake_screen",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            },
        },
    },
    ]]--
}