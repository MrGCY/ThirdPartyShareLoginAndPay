//
//  WBApiUtils.m
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/20.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "WBApiUtils.h"
#import "ThirdPartyLoginContans.h"
#import "UIImage+TT.h"
@interface WBApiUtils()
@property (strong, nonatomic) WBAuthorizeRequest *request;
//qq
@property (strong, nonatomic) WBAuthorizeRequest * wbOauth;
@end
@implementation WBApiUtils
/**
 创建单例
 */
+ (WBApiUtils *)sharedInstance
{
    static WBApiUtils * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WBApiUtils alloc] init];
        sharedInstance.request = [WBAuthorizeRequest request];
    });
    return sharedInstance;
}
//登录方法
- (void)WBOauthLogin
{
    self.request = [WBAuthorizeRequest request];
    self.request.redirectURI = KWBRedirectURL;
    self.request.scope = @"all";
    self.request.userInfo = @{@"SSO_From": NSStringFromClass([self class]),
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    self.wbOauth = self.request;
    [WeiboSDK sendRequest:self.request];
}
//向微博注册
-(BOOL)WBRegister:(BOOL)enabled{
    //是否打开bug调试
    [WeiboSDK enableDebugMode:enabled];
    return [WeiboSDK registerApp:KWBAPPID];
}
//是否安装微博
- (BOOL)isWBAppInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
}
//移除代理
- (void)delegateDealloc{
    self.wbDelegate = nil;
}
//分享图片
- (BOOL)sharedImageToSinaWeibo:(NSString *) message
                           image:(UIImage *)image
{
    self.request.redirectURI = KWBRedirectURL;
    self.request.scope = @"all";
    UIImage *compressedImage = [image imageWithFileSize:10*1024*1024];
    NSData *imageData = UIImageJPEGRepresentation(compressedImage,1.0);
    WBMessageObject *wbMessageObject = [WBMessageObject message];
    if (wbMessageObject != nil)
    {
        wbMessageObject.text = message;
    }
    
    if ([imageData length] > 0)
    {
        WBImageObject *imageObj = [WBImageObject object];
        imageObj.imageData = imageData;
        wbMessageObject.imageObject = imageObj;
    }
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbMessageObject authInfo:self.request access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"SinaWeiboShare"};
    
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    return [WeiboSDK sendRequest:request];
}
//分享网页
- (BOOL)sharedLinkToSinaWeiboWithTitle:(nonnull NSString*)title
                                webURL:(nullable NSString *)webURL
                               message:(nullable NSString *) message
                            coverImage:(nullable UIImage*)coverImage;
{
    self.request.redirectURI = KWBRedirectURL;
    self.request.scope = @"all";
    //实测缩略图限制为(?, ?)
    UIImage *compressedImage = coverImage?[coverImage imageWithFileSize:32*1024 scaledToSize:CGSizeMake(120, 120)]:nil;
    NSData *imageData = coverImage?UIImageJPEGRepresentation(compressedImage,1.0):nil;
    WBMessageObject *wbMessageObject = [WBMessageObject message];
    if (wbMessageObject != nil)
    {
        wbMessageObject.text = message;
    }
    
    if ([webURL length] > 0)
    {
        WBWebpageObject *webObj = [WBWebpageObject object];
        webObj.objectID = [NSString stringWithFormat:@"%d",arc4random()%1000000];
        webObj.webpageUrl = webURL;
        webObj.title = title;
        webObj.thumbnailData = imageData;
        wbMessageObject.mediaObject = webObj;
    }
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbMessageObject authInfo:self.request access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"SinaWeiboShare"};
    
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    return [WeiboSDK sendRequest:request];
}
//分享视频
- (BOOL)sharedVideoToSinaWeiboWithTitle:(nonnull NSString*)title
                               videoURL:(nonnull NSString *)videoURL
                         videoStreamURL:(nullable NSString*)streamURL
                                message:(nullable NSString *)message
                             coverImage:(nullable UIImage*)coverImage;
{
    self.request.redirectURI = KWBRedirectURL;
    self.request.scope = @"all";
    //实测缩略图限制为(168, 168)
    UIImage *compressedImage = coverImage?[coverImage imageWithFileSize:32*1024 scaledToSize:CGSizeMake(160, 160)]:nil;
    NSData *imageData = coverImage?UIImageJPEGRepresentation(compressedImage,1.0):nil;
    WBMessageObject *wbMessageObject = [WBMessageObject message];
    if (wbMessageObject != nil)
    {
        wbMessageObject.text = message;
    }
    
    if ([videoURL length] > 0)
    {
        WBVideoObject *videoObj = [WBVideoObject object];
        videoObj.objectID = [NSString stringWithFormat:@"%d",arc4random()%1000000];
        videoObj.videoUrl = videoURL;
        videoObj.videoStreamUrl = streamURL;
        videoObj.title = title;
        videoObj.thumbnailData = imageData;
        wbMessageObject.mediaObject = videoObj;
    }
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbMessageObject authInfo:self.request access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"SinaWeiboShare"};
    
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL success = [WeiboSDK sendRequest:request];
    return success;
}

#pragma mark- WeiboSDKDelegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvSendMessageReq:)]) {
            WBSendMessageToWeiboRequest* sendMessageToWeiboReq = (WBSendMessageToWeiboRequest*)request;
            [self.wbDelegate WBApiUtilsDidRecvSendMessageReq:sendMessageToWeiboReq];
        }
    }
    else if ([request isKindOfClass:WBAuthorizeResponse.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvAuthorizeReq:)]) {
            WBAuthorizeRequest *authReq = (WBAuthorizeRequest *)request;
            [self.wbDelegate WBApiUtilsDidRecvAuthorizeReq:authReq];
        }
    }
    else if ([request isKindOfClass:WBPaymentResponse.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvPaymentReq:)]) {
            WBPaymentRequest *payReq = (WBPaymentRequest *)request;
            [self.wbDelegate WBApiUtilsDidRecvPaymentReq:payReq];
        }
    }
    else if([request isKindOfClass:WBSDKAppRecommendRequest.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvRecommendReq:)]) {
            WBSDKAppRecommendRequest *messageReq = (WBSDKAppRecommendRequest *)request;
            [self.wbDelegate WBApiUtilsDidRecvRecommendReq:messageReq];
        }
    }
    
}
/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvSendMessageResponse:)]) {
            WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
            [self.wbDelegate WBApiUtilsDidRecvSendMessageResponse:sendMessageToWeiboResponse];
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvAuthorizeResponse:)]) {
            WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
            [self.wbDelegate WBApiUtilsDidRecvAuthorizeResponse:authResp];
        }
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvPaymentResponse:)]) {
            WBPaymentResponse *payResp = (WBPaymentResponse *)response;
            [self.wbDelegate WBApiUtilsDidRecvPaymentResponse:payResp];
        }
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        if (self.wbDelegate
            && [self.wbDelegate respondsToSelector:@selector(WBApiUtilsDidRecvRecommendResponse:)]) {
            WBSDKAppRecommendResponse *messageResp = (WBSDKAppRecommendResponse *)response;
            [self.wbDelegate WBApiUtilsDidRecvRecommendResponse:messageResp];
        }
    }
}
@end
