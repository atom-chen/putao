-------------------------
-- 协议注册器
-------------------------
require("app.proto.others")

local proto_register = {}

function proto_register:RegisterAllProtocal()
	logger.net("开始生成协议......")
	
	unquire("app_caipiao.proto.rpc.award")
	unquire("app_caipiao.proto.rpc.bet")
	unquire("app_caipiao.proto.rpc.daily_reward")
	unquire("app_caipiao.proto.rpc.goucai")
	unquire("app_caipiao.proto.rpc.grade")
	unquire("app_caipiao.proto.rpc.helpdoc")
	unquire("app_caipiao.proto.rpc.home")
	unquire("app_caipiao.proto.rpc.login")
	unquire("app_caipiao.proto.rpc.pay")
	unquire("app_caipiao.proto.rpc.user")
	unquire("app_caipiao.proto.rpc.agent")
	unquire("app_caipiao.proto.rpc.redbag")
	
	require("app_caipiao.proto.rpc.award")
	require("app_caipiao.proto.rpc.bet")
	require("app_caipiao.proto.rpc.daily_reward")
	require("app_caipiao.proto.rpc.goucai")
	require("app_caipiao.proto.rpc.grade")
	require("app_caipiao.proto.rpc.helpdoc")
	require("app_caipiao.proto.rpc.home")
	require("app_caipiao.proto.rpc.login")
	require("app_caipiao.proto.rpc.pay")
	require("app_caipiao.proto.rpc.user")
	require("app_caipiao.proto.rpc.agent")
	require("app_caipiao.proto.rpc.redbag")
	
	
	unquire("app_caipiao.proto.protocal_define.award")
	unquire("app_caipiao.proto.protocal_define.bet")
	unquire("app_caipiao.proto.protocal_define.daily_reward")
	unquire("app_caipiao.proto.protocal_define.goucai")
	unquire("app_caipiao.proto.protocal_define.grade")
	unquire("app_caipiao.proto.protocal_define.helpdoc")
	unquire("app_caipiao.proto.protocal_define.home")
	unquire("app_caipiao.proto.protocal_define.login")
	unquire("app_caipiao.proto.protocal_define.pay")
	unquire("app_caipiao.proto.protocal_define.user")
	unquire("app_caipiao.proto.protocal_define.agent")
	unquire("app_caipiao.proto.protocal_define.redbag")

	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.award") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.bet") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.daily_reward") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.goucai") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.grade") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.helpdoc") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.home") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.login") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.pay") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.user") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.agent") )
	proto.RegisterProtocal( require("app_caipiao.proto.protocal_define.redbag") )
	
	logger.net( "生成协议完成")
end

return proto_register
