// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2015-2016 Hangzhou Freewind Technology Co., Ltd.
// All rights reserved.
// http://company.zaoing.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  payRequsestHandler.mm
//  beibei
//
//  Created by Sailor on 16/6/15.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "payRequsestHandler.h"
#import "WXApiObject.h"
/*
 服务器请求操作处理
 */
@implementation payRequsestHandler

//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
{
    //初始构造函数
    payUrl     = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
    if (debugInfo == nil){
        debugInfo   = [NSMutableString string];
    }
    [debugInfo setString:@""];
    appid   = app_id;
    mchid   = mch_id;
    return YES;
}
//设置商户密钥
-(void) setKey:(NSString *)key
{
    spkey  = [NSString stringWithString:key];
}
//获取debug信息
-(NSString*) getDebugifo
{
    NSString    *res = [NSString stringWithString:debugInfo];
    [debugInfo setString:@""];
    return res;
}
//获取最后服务返回错误代码
-(long) getLasterrCode
{
    return last_errcode;
}
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", spkey];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];

    return md5Sign;
}

//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams
{
    NSString *sign;
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    sign        = [self createMd5Sign:packageParams];
    //生成xml的package
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams
{
    NSString *prepayid = nil;
    
    //获取提交支付
    NSString *send = [self genPackage:prePayParams];
    
    //输出Debug Info
    [debugInfo appendFormat:@"API链接:%@\n", payUrl];
    [debugInfo appendFormat:@"发送的xml:%@\n", send];
    
    //发送请求post xml数据
    NSData *res = [WXUtil httpSend:payUrl method:@"POST" data:send];
    
    //输出Debug Info
    [debugInfo appendFormat:@"服务器返回：\n%@\n\n",[[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding]];
     
    XMLHelper *xml  = [[XMLHelper alloc] init];
    
    //开始解析
    [xml startParse:res];
    
    NSMutableDictionary *resParams = [xml getDict];

    //判断返回
    NSString *return_code   = [resParams objectForKey:@"return_code"];
    NSString *result_code   = [resParams objectForKey:@"result_code"];
    if ( [return_code isEqualToString:@"SUCCESS"] )
    {
        //生成返回数据的签名
        NSString *sign      = [self createMd5Sign:resParams ];
        NSString *send_sign =[resParams objectForKey:@"sign"] ;
        
        //验证签名正确性
        if( [sign isEqualToString:send_sign]){
            if( [result_code isEqualToString:@"SUCCESS"]) {
                //验证业务处理状态
                prepayid    = [resParams objectForKey:@"prepay_id"];
                return_code = 0;
                
                [debugInfo appendFormat:@"获取预支付交易标示成功！\n"];
            }
        }else{
            last_errcode = 1;
            [debugInfo appendFormat:@"gen_sign=%@\n   _sign=%@\n",sign,send_sign];
            [debugInfo appendFormat:@"服务器返回签名验证错误！！！\n"];
        }
    }else{
        last_errcode = 2;
        [debugInfo appendFormat:@"接口返回错误！！！\n"];
    }

    return prepayid;
}

//生成预支付参数
- (NSDictionary *)sendPay_prepareWithOrder:(WeChatOrder *)order andNotifyURL:(NSString *)url
{
    NSString *orderName = order.orderName;
    NSString *orderNo = order.orderNo;
    NSString *orderPrice = order.orderPrice;
    NSString *attach = order.attach;
    NSString *noncestr = [self noncestrCreate];
    
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    
    [packageParams setObject: appid             forKey:@"appid"];       //开放平台appid
    [packageParams setObject: mchid             forKey:@"mch_id"];      //商户号
    [packageParams setObject: @"com.quzhua.com"        forKey:@"device_info"]; //支付设备号或门店号
    [packageParams setObject: noncestr          forKey:@"nonce_str"];   //随机串
    [packageParams setObject: @"APP"            forKey:@"trade_type"];  //支付类型，固定为APP
    [packageParams setObject: orderName        forKey:@"body"];        //订单描述，展示给用户
    [packageParams setObject:attach forKey:@"attach"];                  //附加信息
    [packageParams setObject: url        forKey:@"notify_url"];    //支付结果异步通知
    [packageParams setObject: orderNo           forKey:@"out_trade_no"];//商户订单号
    [packageParams setObject: [self getIPAddress]    forKey:@"spbill_create_ip"];//发器支付的机器ip
    [packageParams setObject: orderPrice       forKey:@"total_fee"];
    //订单金额，单位为分

    //获取prepayId（预支付交易会话标识）
    NSString *prePayid;
    prePayid            = [self sendPrepay:packageParams];
    
    if ( prePayid != nil) {
        //获取到prepayid后进行第二次签名
        //返回参数列表
        return [self getSignParamsWithPrepareID:prePayid];
        
    }else{
        [debugInfo appendFormat:@"获取prepayid失败！\n"];
    }
    return nil;
}
//根据prpayid获取支付参数
-(NSDictionary *)getSignParamsWithPrepareID:(NSString *)prepareId{
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str    = [WXUtil md5:time_stamp];
    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: appid        forKey:@"appid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: mchid        forKey:@"partnerid"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    [signParams setObject: prepareId     forKey:@"prepayid"];
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    [debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
    //添加签名
    [signParams setObject: sign forKey:@"sign"];
    return signParams;
}
- (void)payWithPrepareParams:(NSDictionary *)dict
{
    if(dict == nil){
        //错误提示
        NSString *debug = [self getDebugifo];
        
        NSLog(@"%@\n\n",debug);
    }else{
//        NSLog(@"%@\n\n",[self getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}

- (NSString *)noncestrCreate
{
    static int kNumber = 32;
    
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
- (NSString *)getIPAddress {
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
