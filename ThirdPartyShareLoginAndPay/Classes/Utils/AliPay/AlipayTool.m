//
//  AlipayTool.m
//  GrabDollApp
//
//  Created by Gauss on 2017/12/15.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "AlipayTool.h"
#import "APOrderInfo.h"
#import "APAuthInfo.h"
#import "APRSASigner.h"
#import <AlipaySDK/AlipaySDK.h>
//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
static NSString * const appScheme = @"ThirdPartyApp";
//商户签约id
static NSString * const alipayPid = @"";
//注册的appID
/*============================================================================*/
/*=======================需要填写商户app申请的===================================*/
/*============================================================================*/
static NSString * const alipayAppID = @"2016080101692471";
// 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
// 如果商户两个都设置了，优先使用 rsa2PrivateKey
// rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
// 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
// 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
//rsa2PrivateKey 应用私钥 升级版 2048字节
static NSString * const alipayRSA2PrivateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDox5wFMMuwGuBgKtaxnwlOyxpvxPs+2Svsqv6AD+rS2eOWJHpZOU7t3N31hGctc+iU6KDLZFv/HU/+9+WJ1Rkl69Ojyhu6fSP8L2ht1RilDYzfruOPtGwJ+zEeZa9Kq5Pm+gHuu3INHKGT0TZajz5gj635tYO7id6XtZ4kOAsOKJl3Nl1qLHYA84HxbP8ckJQpehZwGnNLRV4x6pytAvNO5oEjDIHm3z2xBPnXxz02uy/gCtN1juguQ+AW8dfjuPq9hHooGh6xZU5jBhnMg6DmN7ls16LJaPhJaprAGs0yJ2/fDUhc5EYw21OncjfWf1a7jHsKwny9m6c6CEbqWb1pAgMBAAECggEBAKfxk8Q+70YQLf/UCG/AESQS7vDiym4Om102BUX5te8IGuXxTYBgE20To+QF8bbeYFhG+fOkZadKy7NlwOrPn0Q3v8r0/0puDO9eeNZ9Hzm96/xaHn5IqoYM/+QxcuXJonzLtWc7P87r8DtIfxGZNWTPZLK7Xd6JWtpTw1PYR0mfas0PnD/8Wv21UNnc8M8PojDDleBS1Z6psgyuyNkkJHsjg6URyPNXA3v0jkEbLQYtUVUYirD6DzmNQxJxKFGRGPZibzc8SvI8Z2ulM/8LFoEpy7tN83wLIiur34NWivwch2hzydLE93qt8tWvhqAbfxwdxF/gtY/RZVREKt9XHk0CgYEA9sB2NvUwysxQyPL1P/cwThtMSvZHVlzoXVjkPtdrclU7HZzX9wHZ/clXd+0gmtVCV+GRoz+ixG4U+4dK2cY948jyRfuxKXCfcd3nn73U+PYUahz7EmM7Yw2u3MDNOxRucMiEM4OaTVLfkzZq3q2qR4fu/kaF12rGJsv2CAy93usCgYEA8YEWkJEZ6EGA6GqFLlv3EwCutuhlKsA6JI1qlgjC9HKuttnlT5j3okPcH2gr7Q01eNOF7dnuU24qhozpVvKTjblnCdo20kvIk2aeEIWzy+oB5ji9PRR1RBHrUNnilvVRrJ5xHd2naMDvEaEqGxZsXRkR6tFSlO/0XKNyf6TXR/sCgYBLZzb4xmaZomQRdEVDvcryI19mDOpx1sRfOjnNhlDcSHVfMD3CyrsN1cg36qurBP5YEqNJqrmXozggQRC7idwBzrdScX6K9lKTHkeYxg7d4X0NjDuhO9e7BkRoSzasFitFpdDYWR/+/xM5TkjMMW+2mjCLXYuq74ML+gn+Hb6r7wKBgEL6ikeN9qFziUzsPgOdfejHR61yxpwUtAtvLSBvTaJ+K/aKeA6bXhKiv2n2ejhEcZARGhPdXTvGUgT/D7gNjt6/jNQusQWh/v7idvQeIL9tJxmyoslN4zf9wEWsKCu13fECAF1IHCXxXFyHViYtEeDAEzgM1dp4skz/B8Je9VYBAoGBAO1SWLxPU/fadsu1SAmLSlHZRlRQlji44/kXMyngQPu/0YcwSCsS4dBxLTFKbZOzyAezZ1FALWRVd/Rv+h4Opg9ZwYGm3695BVr/2Bqtsga+3TQPBOej8yryNjgi78SS38c2aLy/K3j1oEtmLYgPEcbUVp3JD9NciyG7n5irzo4B";
//rsaPrivateKey 应用私钥
static NSString * const alipayRSAPrivateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAI+g6HUxGEaLYFXmDqyL4PhxGphOo2h4t7KMJLu6lKmFNbuctNB3sv/X8YoRtApoY2BTrAoyoBro+YGF0b6fM/bIQ8i4v0A8vCvKf8fa1zpiQmYAlETO+YkHaRoiZuQ/+x1F4OFFRcFBPwNZLcHHl3OMN9lZHQKJBgNwbavFoTYLAgMBAAECgYBBCW+5gV2os/wPaXlDkKNyXGTaiuFbsS4dX3BSwY4HpRZLug32R/159GKfTpzkCZjWSY0hoQL2rIAuslXjp1tzuQMMXOXGIwR8AyBN3MuBKGFYUEUDgzewoW8wik+WgGDNcA5upB82c2o0YMU10nufXPEIC9NBPSRQd8IJusNIwQJBANkgYOuDLvjGdBb4tOaBYKecx23OoZ02AuYThhdut3GdWiIOOuSQ8YyytSDlmWnC/SGh4hoCm7sh6JG3S9ZQbgkCQQCpV+CSuoF43pKKq3gmqvW/u3SrS1mgJ8Pi4Uaq3n7clrdMBgGOGaZyq6OHC5yesFGgypQ09uK/ExaXMcFfc4hzAkEAjSe9mp6oNNdftWduw8QsgAsuo7aH3tq0O7tJm4ZBAD3Z0PYLV3jbcCrmEkLx344CXpENmvdDIv9CYSkWxnd3cQJANYlZrymVaw/6hiqFdrwPq0jpLopI0HAh5qVPwQ9MThK76iXv8eu8Cn6m2TfbkPOvKsVAq6ntr3iqaKxLNRECbwJAGWCnm+iO8PivvG/4ZZxq/aji7QDZIkguK7oatt0SutHq/MBhDWJRhLntpjVOs92OYKa5R7ojeVdRzu7j/Xlhmg==";
@interface AlipayTool()
@property (copy, nonatomic) SuccessBlock success;
@property (copy, nonatomic) FailBlock fail;
@end
@implementation AlipayTool
#pragma mark- appdelegate中支付处理相关
+ (void)Alipay_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [AlipayTool alipayCompleteHandleWithResult:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
}
+ (void)Alipay_application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [AlipayTool alipayCompleteHandleWithResult:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [AlipayTool alipayCompleteHandleWithResult:resultDic];
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
}
#pragma mark- 创建单例
#pragma mark - 初始化方法
+ (AlipayTool *)alipayTool
{
    static AlipayTool * alipayTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alipayTool = [[AlipayTool alloc] init];
    });
    return alipayTool;
}
#pragma mark - 支付宝支付
/**
 建议使用这种
 */
#pragma mark 服务端生成订单信息加签字符串 客户端支付
- (void)alipayWithOrderSignInfo:(NSString *)orderSignInfo{
    //回调结果
    [[AlipaySDK defaultService] payOrder:orderSignInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [AlipayTool alipayCompleteHandleWithResult:resultDic];
    }];
}
#pragma mark - 支付宝支付
#pragma mark - 客户端生加签订单并支付
- (void)alipayWithPrice:(NSString *)price
               andTitle:(NSString *)title
                andDesc:(NSString *)desc
             andTradeNo:(NSString *)tradeNO
          andPrivateKey:(NSString *)privateKey
               withRSA2:(BOOL)rsa2
                backUrl:(NSString *)backUrl
                success:(SuccessBlock)successBlock
              failBlock:(FailBlock)failBlock{
    self.success = successBlock;
    self.fail = failBlock;
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = alipayAppID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    //回调地址
    if (!kStringIsEmpty(backUrl)) {
        order.notify_url = backUrl;
    }
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = rsa2 ?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = desc;//商品描述
    order.biz_content.subject = title;//商品标题
    order.biz_content.out_trade_no = tradeNO; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = price; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:privateKey];
    if (rsa2) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [AlipayTool alipayCompleteHandleWithResult:resultDic];
        }];
    }
}
- (void)alipayWithPrice:(NSString *)price
               andTitle:(NSString *)title
                andDesc:(NSString*)desc
             andTradeNo:(NSString *)tradeNO
                success:(SuccessBlock)successBlock
              failBlock:(FailBlock)failBlock
{
    [[AlipayTool alipayTool] alipayWithPrice:price andTitle:title andDesc:desc andTradeNo:tradeNO andPrivateKey:alipayRSA2PrivateKey withRSA2:YES backUrl:nil success:successBlock failBlock:failBlock];
}
+(void)alipayCompleteHandleWithResult:(NSDictionary *)resultDic{
    NSLog(@"memo:%@,result:%@,resultStatus:%@",resultDic[@"memo"],resultDic[@"result"],resultDic[@"resultStatus"]);
    NSString * message = nil;
    switch ([resultDic[@"resultStatus"] intValue]) {
        case 9000:{
            NSLog(@"支付成功");
            if ([AlipayTool alipayTool].success) {
                [AlipayTool alipayTool].success(resultDic);
            }
        }
            break;
        case 8000:
            NSLog(@"正在处理中");
            break;
        case 4000:
            NSLog(@"订单支付失败");
            message = @"订单支付失败";
        case 6001:
            NSLog(@"用户中途取消");
            message = @"用户中途取消";
        case 6002:{
            NSLog(@"网络连接出错");
            message = @"网络连接出错";
            if ([AlipayTool alipayTool].fail) {
                [AlipayTool alipayTool].fail(resultDic, message);
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark   ==============点击模拟授权行为==============
-(void)alipayDoAPAuth
{
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    
    //生成 auth info 对象
    APAuthInfo *authInfo = [APAuthInfo new];
    authInfo.pid = alipayPid;
    authInfo.appID = alipayAppID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((alipayRSA2PrivateKey.length > 1)?alipayRSA2PrivateKey:alipayRSAPrivateKey)];
    if ((alipayRSA2PrivateKey.length > 1)) {
        signedString = [signer signString:authInfoStr withRSA2:YES];
    } else {
        signedString = [signer signString:authInfoStr withRSA2:NO];
    }
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0) {
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, ((alipayRSA2PrivateKey.length > 1)?@"RSA2":@"RSA")];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
                                               NSLog(@"result = %@",resultDic);
                                               // 解析 auth code
                                               NSString *result = resultDic[@"result"];
                                               NSString *authCode = nil;
                                               if (result.length>0) {
                                                   NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                   for (NSString *subResult in resultArr) {
                                                       if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                           authCode = [subResult substringFromIndex:10];
                                                           break;
                                                       }
                                                   }
                                               }
                                               NSLog(@"授权结果 authCode = %@", authCode?:@"");
                                           }];
    }
}

#pragma mark   ==============产生随机订单号==============
+(NSString *)generateTradeNO
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
@end
