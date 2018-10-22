
#ifndef __CC_EXTENSION_CCHTTP_REQUEST_DELEGATE_H_
#define __CC_EXTENSION_CCHTTP_REQUEST_DELEGATE_H_

#if CC_TARGET_PLATFORM != CC_PLATFORM_ANDROID
#include "extra/cocos2dx_extra.h"
#else
#include "cocos2dx_extra.h"
#endif

NS_CC_EXTRA_BEGIN

class HTTPRequest;

class HTTPRequestDelegate
{
public:
    virtual void requestFinished(HTTPRequest* request) {}
    virtual void requestFailed(HTTPRequest* request) {}
};

NS_CC_EXTRA_END

#endif // __CC_EXTENSION_CCHTTP_REQUEST_DELEGATE_H_
