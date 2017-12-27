//
//  CMAPIGenerate.m
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/21.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "APIGenerate.h"
//正式域名
const NSString * defaultNetworkHost =  @"192.168.89.138:8080";
//测试
const NSString * defaultNetworkHostTest = @"192.168.89.138:8080";

static NSString* const apiFileName = @"Config";
static NSString* const apiFileExtension = @"json";
@implementation APIGenerate
+(APIGenerate*)sharedInstance{
    static APIGenerate* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
//获取api字典
+(NSDictionary*)apiDictionary
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:apiFileName ofType:apiFileExtension];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}
-(NSString*)API:(NSString*)apiName{
    NSDictionary* configDict = nil;
    configDict = [[self class] apiDictionary];
    const NSString *host = APITEST ? defaultNetworkHostTest : defaultNetworkHost;
    
    NSDictionary *dic = [configDict objectForKey:apiName];
    NSString* apiProtocol = @"http";
    //拼接url
    NSString *apiUrl = [NSString stringWithFormat:@"%@://%@",apiProtocol,host];
    NSString *control = dic[@"control"];
    if (control && ![control isEqual:[NSNull null]] && control.length > 0) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", control];
    }
    NSString *action = dic[@"action"];
    if (action && ![action isEqual:[NSNull null]] && action.length > 0) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", action];
    }
    apiUrl = [apiUrl stringByAppendingString:@"?"];
    
    return apiUrl;
}
-(NSString*)APINomark:(NSString*)apiName{
    NSDictionary* configDict = nil;
    configDict = [[self class] apiDictionary];
    const NSString *host = APITEST ? defaultNetworkHostTest : defaultNetworkHost;
    
    NSDictionary *dic = [configDict objectForKey:apiName];
    NSString* apiProtocol = @"http";
    //拼接url
    NSString *apiUrl = [NSString stringWithFormat:@"%@://%@",apiProtocol,host];
    NSString *control = dic[@"control"];
    if (control && ![control isEqual:[NSNull null]] && control.length > 0) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", control];
    }
    NSString *action = dic[@"action"];
    if (action && ![action isEqual:[NSNull null]] && action.length > 0) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", action];
    }
    
    return apiUrl;
}
@end
