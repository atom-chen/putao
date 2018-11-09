return 
{
    [1] = {
        ["args"] = {
            ["sNodeName"] = "测试剧情1",
        },
        ["cmdName"] = "x_root_node",
        ["connectors"] = { },
		["nextpms"] = 101,
    },
    [2] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["dx"] = 200.000000,
            ["dy"] = 100.000000,
        },
        ["cmdName"] = "s_role_rush_to",
        ["connectors"] = {
            [0] = {
                [1] = 200.000000,
            },
        },
        ["nextpms"] = 3,
    },
    [3] = {
        ["args"] = {
            ["ani_name"] = "hit",
            ["atom_id"] = "starman",
        },
        ["cmdName"] = "s_role_play_ani",
        ["connectors"] = {

        },
        ["nextpms"] = 4,
    },
    [4] = {
        ["args"] = {
            ["seconds"] = 2.000000,
        },
        ["cmdName"] = "x_delay_time",
        ["connectors"] = {
            
        },
        ["nextpms"] = 5,
    },
    [5] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["dx"] = 0.000000,
            ["dy"] = 0.000000,
        },
        ["cmdName"] = "s_role_face_to",
        ["connectors"] = {
           
        },
        ["nextpms"] = 6,
    },
    [6] = {
        ["args"] = {
            ["iBlackScreen"] = 1.000000,
            ["iKeepSeconds"] = 1.000000,
        },
        ["cmdName"] = "s_black_screen",
        ["connectors"] = {
            
        },
        ["nextpms"] = 7,
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
            
        },
        ["nextpms"] = 8,
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
                [2] = 11.000000,
            },
            ["ec_xstart"] = {
            },
        },
        ["nextpms"] = 999,
    },
    [999] = {
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
                [2] = 11.000000,
            },
            ["ec_xstart"] = {
            },
        },
        ["nextpms"] = 999,
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
                [1] = 110.000000,
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
            },
        },
    },
    [14] = {
        ["args"] = {
            ["atom_id"] = 2.000000,
            ["res_path"] = "res/effects/effect_seq/bingpo.plist",
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
            ["seconds"] = 1.000000,
            ["toAngle"] = 120.000000,
        },
        ["cmdName"] = "x_rotate_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 17.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [17] = {
        ["args"] = {
            ["Angle"] = -120.000000,
            ["atom_id"] = "starman",
            ["seconds"] = 0.500000,
        },
        ["cmdName"] = "x_rotate_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 18.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [18] = {
        ["args"] = {
            ["SkewX"] = 40.000000,
            ["SkewY"] = -40.000000,
            ["atom_id"] = "starman",
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_skew_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 19.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [19] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["deltaSkewX"] = -40.000000,
            ["deltaSkewY"] = 40.000000,
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_skew_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 20.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [20] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["dstX"] = 40.000000,
            ["dstY"] = 40.000000,
            ["jmpHeight"] = 100.000000,
            ["jmpTimes"] = 1.000000,
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_jump_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 21.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [21] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["deltaX"] = 400.000000,
            ["deltaY"] = 100.000000,
            ["jmpHeight"] = 200.000000,
            ["jmpTimes"] = 1.000000,
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_jump_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 22.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [22] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["pt_list"] = {
                [1] = {
                    ["x"] = 0.000000,
                    ["y"] = 0.000000,
                },
                [2] = {
                    ["x"] = 277.000000,
                    ["y"] = 0.000000,
                },
                [3] = {
                    ["x"] = 277.000000,
                    ["y"] = 556.000000,
                },
                [4] = {
                    ["x"] = 0.000000,
                    ["y"] = 222.000000,
                },
                [5] = {
                    ["x"] = 0.000000,
                    ["y"] = 0.000000,
                },
                [6] = {
                    ["x"] = 222.000000,
                    ["y"] = 666.000000,
                },
            },
            ["seconds"] = 2.000000,
            ["tension"] = 0.500000,
        },
        ["cmdName"] = "x_cardinal_spline_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 23.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [23] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_fade_out",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 24.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [24] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_fade_in",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 25.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [25] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["seconds"] = 1.000000,
            ["times"] = 15.000000,
        },
        ["cmdName"] = "x_blink",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 26.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [26] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["b"] = 133.000000,
            ["g"] = 244.000000,
            ["r"] = 15.000000,
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_tint_to",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 27.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [27] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["deltaB"] = 133.000000,
            ["deltaG"] = 244.000000,
            ["deltaR"] = 15.000000,
            ["seconds"] = 1.000000,
        },
        ["cmdName"] = "x_tint_by",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 28.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [28] = {
        ["args"] = {
            ["atom_id"] = 3.000000,
            ["panel_clsname"] = "clsBenefitUI",
            ["x"] = 500.000000,
            ["y"] = 400.000000,
        },
        ["cmdName"] = "z_create_panel",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 29.000000,
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
            },
            ["ec_xstart"] = {
            },
        },
    },
    [101] = {
        ["args"] = {
            ["degree"] = 20.000000,
            ["seconds"] = 4.000000,
        },
        ["cmdName"] = "s_shake_screen",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 2.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [110] = {
        ["args"] = {
            ["atom_id"] = 1.000000,
            ["skill_index"] = 1.000000,
            ["times"] = 1.000000,
        },
        ["cmdName"] = "s_play_skill",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 112.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [112] = {
        ["args"] = {
            ["atom_id"] = 1.000000,
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
            ["seconds"] = 0.000000,
        },
        ["cmdName"] = "x_delay_time",
        ["connectors"] = {
            ["ec_xfinish"] = {
                [1] = 13.000000,
            },
            ["ec_xstart"] = {
            },
        },
    },
    [200] = {
        ["args"] = {
            ["atom_id"] = "starman",
            ["words"] = "你个混蛋！为什么受伤的老是我",
        },
        ["cmdName"] = "s_pop_say",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            },
        },
    },
}