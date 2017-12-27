//
//  CMNetWorkManager.h
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/21.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#define KNetworkSuccess 0
typedef void (^NetworkSuccessBlock)(NSInteger statusCode,NSString* message,id responseObject);
typedef void (^NetworkFailureBlock)( id responseObject,NSError * error);
@interface NetWorkManager : NSObject
//创建单例
+ (NetWorkManager *) sharedInstance;

//------------------------------post请求
/*
 URLString  请求地址
 parameters 请求参数
 origin     是否返回源数据
 success    成功回调
 failure    失败回调
 */
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
      origin:(BOOL)isOrigin
     success:(NetworkSuccessBlock)success
     failure:(NetworkFailureBlock)failure;


//------------------------------get请求
/*
 URLString  请求地址
 parameters 请求参数
 origin     是否返回源数据
 success    成功回调
 failure    失败回调
 */
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
     origin:(BOOL)isOrigin
    success:(NetworkSuccessBlock)success
    failure:(NetworkFailureBlock)failure;

//------------------------------PUT请求
/*
 URLString  请求地址
 parameters 请求参数
 origin     是否返回源数据
 success    成功回调
 failure    失败回调
 */
- (void)PUT:(NSString *)URLString
 parameters:(id)parameters
     origin:(BOOL)isOrigin
    success:(NetworkSuccessBlock)success
    failure:(NetworkFailureBlock)failure;



//------------------------------Delete请求
/*
 URLString  请求地址
 parameters 请求参数
 origin     是否返回源数据
 success    成功回调
 failure    失败回调
 */
- (void)DELETE:(NSString *)URLString
    parameters:(id)parameters
        origin:(BOOL)isOrigin
       success:(NetworkSuccessBlock)success
       failure:(NetworkFailureBlock)failure;
@end
