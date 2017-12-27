//
//  WXApiUtils.m
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/20.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "WXApiUtils.h"
#import "ThirdPartyLoginContans.h"
#import "UIImage+TT.h"
@interface WXApiUtils()

@end
@implementation WXApiUtils
/**
 创建单例
 */
+ (WXApiUtils *)sharedInstance
{
    static WXApiUtils * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXApiUtils alloc] init];
    });
    return sharedInstance;
}
//登录方法
- (void)WXOauthLogin
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
    
}
//向微信注册
-(BOOL)WXRegister{
    return [WXApi registerApp:KWXAPPID];
}
//是否安装微信
- (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
//移除代理
- (void)delegateDealloc{
    self.wxDelegate = nil;
}
//网页类型分享
- (BOOL)sharedLinkToWeChat:(NSString *)title
                  description:(NSString *)description
                    detailUrl:(NSString *)detailUrl
                        image:(UIImage *)image
                    shareType:(WXShareSceneType)sharedType
{
    UIImage *compressedImage = [image imageWithFileSize:32*1024 scaledToSize:CGSizeMake(300, 300)];

    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = title;
    
    message.description = description;
    
    [message setThumbImage:compressedImage];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    
    webpageObject.webpageUrl = detailUrl;
    
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    req.bText= NO;
    
    req.message = message;
    
    req.scene = (sharedType == WXShareSceneTypeTimeline? WXSceneTimeline:WXSceneSession);
    BOOL success = [WXApi sendReq:req];
    return success;
}
//分享图片
-(BOOL)shareImageToWeChat:(UIImage *)image
                shareType:(WXShareSceneType)sharedType{
    
    UIImage *compressedImage = [image imageWithFileSize:32*1024 scaledToSize:CGSizeMake(300, 300)];
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:compressedImage];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = (sharedType == WXShareSceneTypeTimeline? WXSceneTimeline:WXSceneSession);
    
    BOOL success = [WXApi sendReq:req];
    return success;
}
//音乐类型分享
- (BOOL)sharedMusicToWeChat:(NSString *)title
               description:(NSString *)description
                   musicUrl:(NSString *)musicUrl
               musicDataUrl:(NSString *)musicDataUrl
                     image:(UIImage *)image
                 shareType:(WXShareSceneType)sharedType
{
    UIImage *compressedImage = [image imageWithFileSize:32*1024 scaledToSize:CGSizeMake(300, 300)];
    
    WXMediaMessage *message = [WXMediaMessage message];
    //标题
    message.title = title;
    //描述
    message.description = description;
    //缩略图
    [message setThumbImage:compressedImage];
    
    WXMusicObject * musicObject = [WXMusicObject object];
    //音乐的url
    musicObject.musicUrl = musicUrl;
    //低分辨率音频
    musicObject.musicLowBandUrl = musicUrl;
    //音乐数据的url
    musicObject.musicDataUrl = musicDataUrl;
    musicObject.musicLowBandDataUrl = musicDataUrl;
    message.mediaObject = musicObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    req.bText= NO;
    
    req.message = message;
    
    req.scene = (sharedType == WXShareSceneTypeTimeline? WXSceneTimeline:WXSceneSession);
    BOOL success = [WXApi sendReq:req];
    return success;
}
//视频类型分享
- (BOOL)sharedVideoToWeChat:(NSString *)title
                description:(NSString *)description
                   videoUrl:(NSString *)videoUrl
                      image:(UIImage *)image
                  shareType:(WXShareSceneType)sharedType
{
    UIImage *compressedImage = [image imageWithFileSize:32*1024 scaledToSize:CGSizeMake(300, 300)];
    
    WXMediaMessage *message = [WXMediaMessage message];
    //标题
    message.title = title;
    //描述
    message.description = description;
    //缩略图
    [message setThumbImage:compressedImage];
    
    WXVideoObject * videoObject = [WXVideoObject object];
    //视频的url
    videoObject.videoUrl = videoUrl;
    videoObject.videoLowBandUrl = videoUrl;
    message.mediaObject = videoObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    req.bText= NO;
    
    req.message = message;
    
    req.scene = (sharedType == WXShareSceneTypeTimeline? WXSceneTimeline:WXSceneSession);
    BOOL success = [WXApi sendReq:req];
    return success;
}
#pragma mark- WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        //微信终端向第三方程序请求提供内容的消息结构体
        if (self.wxDelegate
            && [self.wxDelegate respondsToSelector:@selector(WXApiUtilsDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [self.wxDelegate WXApiUtilsDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        //微信通知第三方程序，要求第三方程序显示的消息结构体
        if (self.wxDelegate
            && [self.wxDelegate respondsToSelector:@selector(WXApiUtilsDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [self.wxDelegate WXApiUtilsDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        //微信终端打开第三方程序携带的消息结构体
        if (self.wxDelegate
            && [self.wxDelegate respondsToSelector:@selector(WXApiUtilsDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [self.wxDelegate WXApiUtilsDidRecvLaunchFromWXReq:launchReq];
        }
    }
}
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass: [PayResp class]]){
        //支付结果
        if (self.wxDelegate
            && [self.wxDelegate respondsToSelector:@selector(WXApiUtilsDidRecvPayResponse:)]) {
            PayResp *payResp = (PayResp *)resp;
            [self.wxDelegate WXApiUtilsDidRecvPayResponse:payResp];
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //第三方程序向微信终端发送SendMessageToWXReq后，微信发送回来的处理结果，该结果用SendMessageToWXResp表示。
        if (self.wxDelegate
            && [self.wxDelegate respondsToSelector:@selector(WXApiUtilsDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [self.wxDelegate WXApiUtilsDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        //微信处理完第三方程序的认证和权限申请后向第三方程序回送的处理结果
        if (self.wxDelegate
            && [self.wxDelegate respondsToSelector:@selector(WXApiUtilsDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [self.wxDelegate WXApiUtilsDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        //微信返回第三方添加卡券结果
        if (self.wxDelegate
            && [self.wxDelegate respondsToSelector:@selector(WXApiUtilsDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [self.wxDelegate WXApiUtilsDidRecvAddCardResponse:addCardResp];
        }
    }
}
@end
