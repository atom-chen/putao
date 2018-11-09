-------------------------
-- 协议注册器
-------------------------
require("app.proto.others")

local proto_register = {}

function proto_register:RegisterAllProtocal()
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

	logger.net("开始生成协议......")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.award")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.bet")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.daily_reward")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.goucai")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.grade")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.helpdoc")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.home")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.login")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.pay")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.user")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.agent")
	proto.RegisterProtocal("app_caipiao.proto.protocal_define.redbag")
	logger.net( "生成协议完成")
end

return proto_register
