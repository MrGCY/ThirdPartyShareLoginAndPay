//
//  QQApiUtils.h
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/19.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
//qq
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/QQApiInterface.h>
typedef NS_ENUM(NSUInteger, QQShareType) {
    QQShareMessage,
    QQShareZone
};

@protocol QQApiUtilsDelegate <NSObject>

@optional
/**
 * 退出登录的回调
 */
- (void)QQApiUtilsTencentDidLogout;
/**
 * 登录成功后的回调
 */
- (void)QQApiUtilsTencentDidLogin;
/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)QQApiUtilsTencentDidNotLogin:(BOOL)cancelled;
/**
 * 登录时网络有问题的回调
 */
- (void)QQApiUtilsTencentDidNotNetWork;
/**
 * 登录成功获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)QQApiUtilsGetUserInfoResponse:(APIResponse*) response tencentOAuth:(TencentOAuth *)tencentOAut;

//消息应答响应
- (void)QQApiUtilsDidRecvMessageResponse:(GetMessageFromQQResp *)response;
- (void)QQApiUtilsDidRecvSendMessageResponse:(SendMessageToQQResp *)response;
- (void)QQApiUtilsDidRecvShowMessageResponse:(ShowMessageFromQQResp *)Response;
@end

@interface QQApiUtils : NSObject<TencentSessionDelegate,TencentLoginDelegate,QQApiInterfaceDelegate>
@property(weak,nonatomic)id<QQApiUtilsDelegate>qqDelegate;
/**
 创建单例
 */
+ (QQApiUtils *)sharedInstance;

- (BOOL)isQQInstalled;

- (BOOL)isZoneInstalled;
/**
 QQ认证登录方法
 */
- (void)QQOauthLogin;
/**
 * 退出登录(退出登录后，TecentOAuth失效，需要重新初始化)
 * param delegate 第三方应用用于接收请求返回结果的委托对象
 */
-(void)QQLogout;
//移除代理
- (void)delegateDealloc;
/**
 * 向QQ分享(空间和好友)
 */
-(BOOL)sharedLinkToQQWithTitle:(NSString*)title
              message:(NSString *) message
            detailUrl:(NSString *)detailUrl
                image:(UIImage *)image
            shareType:(QQShareType) sharedType;
//向QQ分享图片(空间和好友)
- (void)shareImgDataToQQ:(NSString *)titleStr
                 andInfo:(NSString *)messageStr
                andImage:(UIImage *)avatar;
@end
