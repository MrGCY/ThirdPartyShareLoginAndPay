//
//  WBApiUtils.h
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/20.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeiboSDK/WeiboSDK.h>
@protocol WBApiUtilsDelegate <NSObject>
@optional
//收到微博的请求后，一些回调
- (void)WBApiUtilsDidRecvSendMessageReq:(WBSendMessageToWeiboRequest *)request;
- (void)WBApiUtilsDidRecvAuthorizeReq:(WBAuthorizeRequest *)request;
- (void)WBApiUtilsDidRecvPaymentReq:(WBPaymentRequest *)request;
- (void)WBApiUtilsDidRecvRecommendReq:(WBSDKAppRecommendRequest *)request;
//收到微博的响应后，一些回调
- (void)WBApiUtilsDidRecvSendMessageResponse:(WBSendMessageToWeiboResponse *)response;
- (void)WBApiUtilsDidRecvAuthorizeResponse:(WBAuthorizeResponse *)response;
- (void)WBApiUtilsDidRecvPaymentResponse:(WBPaymentResponse *)response;
- (void)WBApiUtilsDidRecvRecommendResponse:(WBSDKAppRecommendResponse *)response;
@end
@interface WBApiUtils : NSObject<WeiboSDKDelegate>
@property (weak , nonatomic)id <WBApiUtilsDelegate> wbDelegate;
/**
 创建单例
 */
+ (WBApiUtils *)sharedInstance;
//登录方法
- (void)WBOauthLogin;
//向微博注册
-(BOOL)WBRegister:(BOOL)enabled;
//是否安装微博
- (BOOL)isWBAppInstalled;
//移除代理
- (void)delegateDealloc;
//分享图片
- (BOOL)sharedImageToSinaWeibo:(NSString *) message
                         image:(UIImage *)image;
//分享网页
- (BOOL)sharedLinkToSinaWeiboWithTitle:(nonnull NSString*)title
                                webURL:(nullable NSString *)webURL
                               message:(nullable NSString *) message
                            coverImage:(nullable UIImage*)coverImage;
//分享视频
- (BOOL)sharedVideoToSinaWeiboWithTitle:(nonnull NSString*)title
                      videoURL:(nonnull NSString *)videoURL
                videoStreamURL:(nullable NSString*)streamURL
                         message:(nullable NSString *)message
                    coverImage:(nullable UIImage*)coverImage;
@end
