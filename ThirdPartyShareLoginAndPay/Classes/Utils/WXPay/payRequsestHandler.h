// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2015-2016 Hangzhou Freewind Technology Co., Ltd.
// All rights reserved.
// http://company.zaoing.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  payRequsestHandler.h
//  beibei
//
//  Created by Sailor on 16/6/15.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
#import "WeChatOrder.h"
#import "WXApi.h"

@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;

    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}
//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//生成预支付参数
- (NSMutableDictionary *)sendPay_prepareWithOrder:(WeChatOrder *)order andNotifyURL:(NSString *)url;
//支付
- (void)payWithPrepareParams:(NSDictionary *)dict;
//根据prpayid获取支付参数
-(NSDictionary *)getSignParamsWithPrepareID:(NSString *)prepareId;
@end
