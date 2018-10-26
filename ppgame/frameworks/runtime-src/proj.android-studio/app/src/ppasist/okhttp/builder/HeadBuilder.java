package ppasist.okhttp.builder;

import ppasist.okhttp.OkHttpUtils;
import ppasist.okhttp.request.OtherRequest;
import ppasist.okhttp.request.RequestCall;

/**
 * Created by zhy on 16/3/2.
 */
public class HeadBuilder extends GetBuilder
{
    @Override
    public RequestCall build()
    {
        return new OtherRequest(null, null, OkHttpUtils.METHOD.HEAD, url, tag, params, headers,id).build();
    }
}
