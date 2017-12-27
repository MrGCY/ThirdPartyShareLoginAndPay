//
//  AlipayTool.h
//  GrabDollApp
//
//  Created by Gauss on 2017/12/15.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock)(NSDictionary * resultDic);
typedef void (^FailBlock)(NSDictionary * resultDic,NSString *message);
@interface AlipayTool : NSObject
#pragma mark- appdelegate中支付处理相关
+ (void)Alipay_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (void)Alipay_application:(UIApplication *)application handleOpenURL:(NSURL *)url;
#pragma mark - 初始化方法
+ (AlipayTool *)alipayTool;
#pragma mark - 服务端生成订单信息加签字符串 客户端支付
- (void)alipayWithOrderSignInfo:(NSString *)orderSignInfo;
#pragma mark - 客户端生加签订单并支付
- (void)alipayWithPrice:(NSString *)price
               andTitle:(NSString *)title
                andDesc:(NSString *)desc
             andTradeNo:(NSString *)tradeNO
          andPrivateKey:(NSString *)privateKey
               withRSA2:(BOOL)rsa2
                backUrl:(NSString *)backUrl
                success:(SuccessBlock)successBlock
              failBlock:(FailBlock)failBlock;
//默认rsa2
- (void)alipayWithPrice:(NSString *)price
               andTitle:(NSString *)title
                andDesc:(NSString*)desc
             andTradeNo:(NSString *)tradeNO
                success:(SuccessBlock)successBlock
              failBlock:(FailBlock)failBlock;
#pragma mark -点击模拟授权行为
-(void)alipayDoAPAuth;
#pragma mark - 产生随机订单号
+(NSString *)generateTradeNO;
    
@end
