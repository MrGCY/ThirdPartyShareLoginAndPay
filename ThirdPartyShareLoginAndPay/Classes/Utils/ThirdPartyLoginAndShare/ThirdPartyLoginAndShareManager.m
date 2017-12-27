//
//  GDThirdPartyLoginAndShareManager.m
//  GrabDollApp
//
//  Created by Gauss on 2017/11/30.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "ThirdPartyLoginAndShareManager.h"
#import "ThirdPartyLoginContans.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"
#import "WeChatOrder.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

//微信支付
NSString * const kIP = @"http://211.149.242.216";
NSString * const APP_ID = @"wx69302eaae9f8698a";                //APPID
NSString * const APP_SECRET = @"e117dd5e2e7cf274d3f873cee8208f34";  //appsecret
//商户号，填写商户对应参数
NSString * const MCH_ID = @"1494877972";
//商户API密钥，填写相应参数
NSString * const PARTNER_ID = @"w12we34rt56yu78io90pasdfghjklzxc";


@interface ThirdPartyLoginAndShareManager()<QQApiUtilsDelegate,WXApiUtilsDelegate,WBApiUtilsDelegate>
@property (copy, nonatomic) PayResponseBlock payResponseBlock;
@end
@implementation ThirdPartyLoginAndShareManager
/**
 创建单例
 */
+ (ThirdPartyLoginAndShareManager *)sharedInstance
{
    static ThirdPartyLoginAndShareManager * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ThirdPartyLoginAndShareManager alloc] init];
    });
    return sharedInstance;
}
//QQ管理者
-(QQApiUtils *)qqUtils{
    if (!_qqUtils) {
        _qqUtils = [QQApiUtils sharedInstance];
        _qqUtils.qqDelegate = self;
    }
    return _qqUtils;
}
//微信管理者
-(WXApiUtils *)wxUtils{
    if (!_wxUtils) {
        _wxUtils = [WXApiUtils sharedInstance];
        _wxUtils.wxDelegate = self;
    }
    return _wxUtils;
}
//微博的管理类
-(WBApiUtils *)wbUtils{
    if (!_wbUtils) {
        _wbUtils = [WBApiUtils sharedInstance];
        _wbUtils.wbDelegate = self;
    }
    return _wbUtils;
}
#pragma mark- AppDelegate方法处理
-(void)thirdPartyApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //微信注册
    [self.wxUtils WXRegister];
    //微博注册
    [self.wbUtils WBRegister:YES];
}
- (BOOL)thirdPartyApplicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([KTencentSchema isEqualToString:[url scheme]]) {
        //QQ
        return [TencentOAuth HandleOpenURL:url];
        
    }else if ([KTencentURLSchema isEqualToString:[url scheme]]) {
        //QQ
        return [QQApiInterface handleOpenURL:url delegate:self.qqUtils];
        
    }else if ([KWXURLSchema isEqualToString:[url scheme]]) {
        //微信
        return [WXApi handleOpenURL:url delegate:self.wxUtils];
        
    }else if ([KWBURLSchema isEqualToString:[url scheme]]){
        //微博
        return [WeiboSDK handleOpenURL:url delegate:self.wbUtils];
    }
    return NO;
}
- (BOOL)thirdPartyApplicationHandleOpenURL:(NSURL *)url {
    
    if ([KTencentSchema isEqualToString:[url scheme]]) {
        //QQ
        return [TencentOAuth HandleOpenURL:url];
        
    }else if ([KTencentURLSchema isEqualToString:[url scheme]]) {
        //QQ
        return [QQApiInterface handleOpenURL:url delegate:self.qqUtils];
        
    }else if ([KWXURLSchema isEqualToString:[url scheme]]) {
        //微信
        return [WXApi handleOpenURL:url delegate:self.wxUtils];
        
    }else if ([KWBURLSchema isEqualToString:[url scheme]]){
        //微博
        return [WeiboSDK handleOpenURL:url delegate:self.wbUtils];
    }
    return NO;
}
- (BOOL)thirdPartyaApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    if ([KTencentSchema isEqualToString:[url scheme]]) {
        //QQ
        return [TencentOAuth HandleOpenURL:url];
        
    }else if ([KTencentURLSchema isEqualToString:[url scheme]]) {
        //QQ
        return [QQApiInterface handleOpenURL:url delegate:self.qqUtils];
        
    }else if ([KWXURLSchema isEqualToString:[url scheme]]) {
        //微信
        return [WXApi handleOpenURL:url delegate:self.wxUtils];
        
    }else if ([KWBURLSchema isEqualToString:[url scheme]]){
        //微博
        return [WeiboSDK handleOpenURL:url delegate:self.wbUtils];
    }
    return NO;
}
#pragma mark- 显示提示语
-(void)showToastMessage:(NSString *)message{
    if (self.thirdPartyDelegate && [self.thirdPartyDelegate respondsToSelector:@selector(thirdPartyDidShowToastMessage:)]) {
        [self.thirdPartyDelegate thirdPartyDidShowToastMessage:message];
    }
}
-(void)loginSuccess:(NSDictionary *)responseObject{
    if (self.thirdPartyDelegate && [self.thirdPartyDelegate respondsToSelector:@selector(thirdPartyDidLoginSuccess:)]) {
        [self.thirdPartyDelegate thirdPartyDidLoginSuccess:responseObject];
    }
}
#pragma mark- QQApiUtilsDelegate  QQ代理
/**
 * 登录成功后的回调
 */
- (void)QQApiUtilsTencentDidLogin{
    //授权成功正在登录中
    [self showToastMessage:QQToastLoginSuccessed];
}
/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)QQApiUtilsTencentDidNotLogin:(BOOL)cancelled{
    if(cancelled){
        [self showToastMessage:QQToastLoginCancelled];
    }else{
        [self showToastMessage:QQToastLoginFailed];
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)QQApiUtilsTencentDidNotNetWork{
    [self showToastMessage:QQToastNetworkError];
}
/**
 * 登录成功获取用户个人信息回调
 */
- (void)QQApiUtilsGetUserInfoResponse:(APIResponse*) response tencentOAuth:(TencentOAuth *)tencentOAut{
    //获取到QQ的用户信息
    NSLog(@"===%@",response.jsonResponse);
    NSInteger gender = 0;
    if ([response.jsonResponse[@"gender"] isEqualToString:@"男"]){
        gender = 1;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:tencentOAut.openId forKey:@"openid"];//openid【必须】
    [params setValue:[response.jsonResponse objectForKey:@"nickname"] forKey:@"nickName"];//QQ昵称【必须】
    [params setValue:[response.jsonResponse objectForKey:@"figureurl_qq_2"] forKey:@"avatar"];//头像【必须】
    [params setValue:gender == 1 ? @"男":@"女" forKey:@"sex"];//性别【必须】
    //登录成功回调
#warning 需要开发调用自己的登录接口
    [self loginSuccess:params];
}

- (void)QQApiUtilsDidRecvSendMessageResponse:(SendMessageToQQResp *)response{
    switch (response.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            if ([response.result isEqualToString:@"0"])
            {
                //QQ分享成功
                [self showToastMessage:QQToastShareSuccessed];
            }
            else
            {
                //QQ分享失败
                [self showToastMessage:QQToastShareFailed];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark- WXApiUtilsDelegate  微信代理
//第三方程序向微信终端发送SendMessageToWXReq后，微信发送回来的处理结果，该结果用SendMessageToWXResp表示。
- (void)WXApiUtilsDidRecvMessageResponse:(SendMessageToWXResp *)response{
    switch (response.errCode)
    {
        case WXErrCodeUserCancel:
            [self showToastMessage:WXToastShareCancelled];
            break;
        case WXErrCodeSentFail:
            [self showToastMessage:WXToastShareFailed];
            break;
        case WXSuccess:
            [self showToastMessage:WXToastShareSuccessed];
            break;
        default:
            break;
    }
}
//微信处理完第三方程序的认证和权限申请后向第三方程序回送的处理结果响应
- (void)WXApiUtilsDidRecvAuthResponse:(SendAuthResp *)response{
    //获取accessToken
    SendAuthResp *oauthResp = (SendAuthResp *)response;
    if (oauthResp.errCode == WXErrCodeAuthDeny)
    {
        [self showToastMessage:WXToastLoginRefused];
    }
    else if (oauthResp.errCode == WXErrCodeUserCancel)
    {
        [self showToastMessage:WXToastLoginCancelled];
    }
    else if (oauthResp.errCode == WXSuccess)
    {
        //登录成功
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KWXAPPID,KWXSecret,response.code];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            WEAKSELF
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    STRONGSELFFor(weakSelf)
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    //获取到的三方凭证
                    NSString * access_token = dic[@"access_token"];
                    //三方唯一标识
                    NSString * openid = dic[@"openid"];
                    [strongSelf getWXUserInfo:access_token openid:openid];
                }
            });
        });
        [self showToastMessage:WXToastLoginSuccessed];
    }
}
//微信返回第三方添加卡券结果
- (void)WXApiUtilsDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response{
    
}
//微信终端返回给第三方的关于支付结果
- (void)WXApiUtilsDidRecvPayResponse:(PayResp *)response{
    if (self.payResponseBlock) {
//        WXSuccess           = 0,    /**< 成功    */
//        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//        WXErrCodeSentFail   = -3,   /**< 发送失败    */
//        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
        if (response.errCode == WXSuccess) {
            //支付成功
            self.payResponseBlock(YES, @"支付成功", response.type);
        }else{
            //支付失败
            NSString * message = nil;
            switch (response.errCode) {
                case WXErrCodeCommon:
                    message = @"普通错误类型";
                    break;
                case WXErrCodeUserCancel:
                    message = @"用户点击取消并返回";
                    break;
                case WXErrCodeSentFail:
                    message = @"发送失败";
                    break;
                case WXErrCodeAuthDeny:
                    message = @"授权失败";
                    break;
                case WXErrCodeUnsupport:
                    message = @"微信不支持";
                    break;
                default:
                    break;
            }
            self.payResponseBlock(NO, message, response.type);
        }
    }
}
//获取微信用户信息
-(void)getWXUserInfo:(NSString *)access_token openid:(NSString *)openid{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setValue:openid forKey:@"openid"];//openid【必须】
                [params setValue:[dic objectForKey:@"nickname"] forKey:@"nickName"];//QQ昵称【必须】
                [params setValue:[dic objectForKey:@"headimgurl"] forKey:@"avatar"];//头像【必须】
                [params setValue:[[dic objectForKey:@"sex"] integerValue] == 1 ? @"男":@"女" forKey:@"sex"];//性别【必须】
                //微信登录
#warning 需要开发调用自己的登录接口
                [self loginSuccess:params];
            }
        });
    });
}
#pragma mark- WBApiUtilsDelegate  微博代理
- (void)WBApiUtilsDidRecvSendMessageResponse:(WBSendMessageToWeiboResponse *)response{
    //分享状态获取
    switch (response.statusCode)
    {
        case WeiboSDKResponseStatusCodeUserCancel:
            [self showToastMessage:WBToastShareCancelled];
            break;
        case WeiboSDKResponseStatusCodeSentFail:
            [self showToastMessage:WBToastShareFailed];
            break;
        case WeiboSDKResponseStatusCodeSuccess:
            [self showToastMessage:WBToastShareSuccessed];
            break;
        default:
            break;
    }
}
- (void)WBApiUtilsDidRecvAuthorizeResponse:(WBAuthorizeResponse *)response{
    if ((int)response.statusCode == 0) {
        WBAuthorizeResponse *authorize = (WBAuthorizeResponse *)response;
        [self showToastMessage:WBToastLoginSuccessed];
        //获取微博的用户信息
        [self getWeiBoUserInfo:authorize];
    }else if ((int)response.statusCode == -1){
        [self showToastMessage:WBToastLoginCancelled];
    }else if ((int)response.statusCode == -2){
        [self showToastMessage:WBToastLoginFailed];
    }
}
//获取微博信息
-(void)getWeiBoUserInfo:(WBAuthorizeResponse *)response{
    NSMutableDictionary *params =  [NSMutableDictionary dictionaryWithCapacity:2];
    [params setValue:response.accessToken forKey:@"access_token"];
    [params setValue:response.userID forKey:@"uid"];
    NSString * url = @"https://api.weibo.com/2/users/show.json";
    WEAKSELF
    [[NetWorkManager sharedInstance] GET:url parameters:params origin:YES success:^(NSInteger statusCode, NSString *message, id responseObject) {
        STRONGSELFFor(weakSelf)
        NSDictionary * dic = (NSDictionary *)responseObject;
        [strongSelf weiboLogin:dic andUserID:response.userID];
    } failure:^(id responseObject, NSError *error) {
    }];
}
//微博登录
-(void)weiboLogin:(NSDictionary *)dic andUserID:(NSString *)userID{
    NSInteger gender = 0;
    if ([[dic objectForKey:@"gender"] isEqualToString:@"m"]){
        gender = 1;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:userID forKey:@"openid"];//openid【必须】
    [params setValue:[dic objectForKey:@"name"] forKey:@"nickName"];//QQ昵称【必须】
    [params setValue:[dic objectForKey:@"avatar_hd"] forKey:@"avatar"];//头像【必须】
    [params setValue:gender == 1 ? @"男":@"女" forKey:@"sex"];//性别【必须】
    //微博登录
#warning 需要开发调用自己的登录接口
    [self loginSuccess:params];
}
#pragma mark - 微信支付  需要服务端下单 给客户端 prepayId
- (void)wxPayWithPrepayId:(NSString *)prepayId andPayResponse:(PayResponseBlock)payReponse{
    self.payResponseBlock = payReponse;
    payRequsestHandler *req = [payRequsestHandler alloc];
    [req init:APP_ID mch_id:MCH_ID];
    [req setKey:PARTNER_ID];
    [req payWithPrepareParams:[req getSignParamsWithPrepareID:prepayId]];
}
#pragma mark - 微信支付  不需要服务端下单  客户端进行下单并支付
- (void)weChatPayOrderTitle:(NSString *)title andAttach:(NSString *)attach andPrice:(NSString *)price andPayResponse:(PayResponseBlock)payReponse
{
    self.payResponseBlock = payReponse;
    NSLog(@"++++++++++++跳到微信支付页面");
    if([WXApi isWXAppInstalled]){
        WeChatOrder *order = [[WeChatOrder alloc] init];
        order.orderName = title;
        order.orderNo = [self generateTradeNO];
        order.attach = attach;
        order.orderPrice = price;               //按每分支付的10分就是1角钱
        [self wxPayWithOrder:order andNotifyUrl:[NSString stringWithFormat:@"%@%@",kIP,@"/cooperation/ifachui/wxpay/money.jsp"]];
    }else{
        [self showToastMessage:@"请安装微信"];
    }
}

#pragma mark   =================微信支付=================
- (void)wxPayWithOrder:(WeChatOrder *)order andNotifyUrl:(NSString *)url
{
    //设置请求参数
    payRequsestHandler *req = [payRequsestHandler alloc];
    [req init:APP_ID mch_id:MCH_ID];
    [req setKey:PARTNER_ID];
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_prepareWithOrder:order andNotifyURL:url];
    [req payWithPrepareParams:dict];
}
#pragma mark  ================产生随机订单号===============
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"192.168.1.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
