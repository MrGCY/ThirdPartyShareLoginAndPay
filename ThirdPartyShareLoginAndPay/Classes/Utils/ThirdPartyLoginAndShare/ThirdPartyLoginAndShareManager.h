//
//  GDThirdPartyLoginAndShareManager.h
//  GrabDollApp
//
//  Created by Gauss on 2017/11/30.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "QQApiUtils.h"
#import "WXApiUtils.h"
#import "WBApiUtils.h"
@protocol ThirdPartyLoginAndShareManagerDelegate <NSObject>
@optional
//显示第三方登录分享的提示消息
-(void)thirdPartyDidShowToastMessage:(NSString *)message;
//登录成功
-(void)thirdPartyDidLoginSuccess:(NSDictionary *)responseObject;
@end
//支付响应回调
typedef void (^PayResponseBlock)(BOOL success,NSString *message,int type);
@interface ThirdPartyLoginAndShareManager : NSObject
@property(weak,nonatomic)id<ThirdPartyLoginAndShareManagerDelegate>thirdPartyDelegate;
//qq的管理类
@property(strong,nonatomic)QQApiUtils * qqUtils;
//微信的管理类
@property(strong,nonatomic)WXApiUtils * wxUtils;
//微博的管理类
@property(strong,nonatomic)WBApiUtils * wbUtils;

+ (ThirdPartyLoginAndShareManager *)sharedInstance;
#pragma mark- AppDelegate方法处理
- (void)thirdPartyApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)thirdPartyApplicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)thirdPartyApplicationHandleOpenURL:(NSURL *)url;
- (BOOL)thirdPartyaApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
//----------微信支付
- (void)wxPayWithPrepayId:(NSString *)prepayId andPayResponse:(PayResponseBlock)payReponse;
- (void)weChatPayOrderTitle:(NSString *)title andAttach:(NSString *)attach andPrice:(NSString *)price andPayResponse:(PayResponseBlock)payReponse;
// Get IP Address
+(NSString *)getIPAddress;
@end
