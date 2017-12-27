//
//  CMNetWorkManager.m
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/21.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "NetWorkManager.h"
#import "APIGenerate.h"
#import "sys/utsname.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#define KNetStatus @"code"
#define KNetData @"data"
#define KNetMsg @"message"
//请求头
static NSString * const Authorization = @"Authorization";

@interface NetWorkManager()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end
@implementation NetWorkManager
//创建单例
+ (NetWorkManager *) sharedInstance
{
    static  NetWorkManager *sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        //初始化自己
        sharedInstance = [[self alloc] init];
        //实例化请求对象
        sharedInstance.manager = [AFHTTPSessionManager manager];
//        [sharedInstance.manager.securityPolicy setAllowInvalidCertificates:YES];
        //设置请求和接收数据类型(JSON)
        sharedInstance.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedInstance.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        sharedInstance.manager.responseSerializer = [AFJSONResponseSerializer serializer];//响应
        sharedInstance.manager.responseSerializer.acceptableContentTypes =[NSSet  setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        //设置请求超时的时间(8s)en
        sharedInstance.manager.requestSerializer.timeoutInterval = 5.0f;
    });
    return  sharedInstance;
}
//设置公共请求参数
-(id)setCommonRequestParmas:(id)parmas{
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithCapacity:0];
    //Authorization  token值
    NSString *token= @"";//[CMLoginUser authToken];
    if (!kStringIsEmpty(token)) {
        [param setValue:token forKey:@"token"];
    }else{
        [param setValue:@"" forKey:@"token"];
    }
    [param setValue:@(0) forKey:@"appKey"];
    [param setValue:[self dictionaryToJson:parmas] forKey:@"data"];
    [param setValue:[self dictionaryToJson:[self getDeviceStatue]] forKey:@"devicStatue"];
    [param setValue:@(0) forKey:@"isEncrypt"];
//    [param setValue:CurrentVersionNum forKey:@"apiVersion"];
    return param;
}
//字典转换成字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    if (!dic) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(NSDictionary *)getDeviceStatue{
    NSMutableDictionary * deviceStatue = [NSMutableDictionary dictionaryWithCapacity:0];
    /*
     dt    String    机型
     nt    String    网络类型
     packageName    String    包名
     devicesId    String    手机设备Id
     imei    String    手机唯一码
     terminalType    String    1:ios 2:android
     sv    String    系统版本
     mac    String    mac地址
     vc    String    apk版本号
     imsi    String    手机卡识别码
     vn    String    apk版本名
     sid    String    平台设备码，由服务器端生成
     cpu    String    cpu
     channelId    String    渠道号接口返回码对应信息
     areaName    String    地区信息
     */
//    [deviceStatue setValue:[self deviceVersion] forKey:@"dt"];
//    [deviceStatue setValue:@"wifi" forKey:@"nt"];
//    [deviceStatue setValue:BundleId forKey:@"packageName"];
//    [deviceStatue setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"devicesId"];
//    [deviceStatue setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"imei"];
//    [deviceStatue setValue:@"1" forKey:@"terminalType"];
//    [deviceStatue setValue:[[UIDevice currentDevice] systemVersion] forKey:@"sv"];
//    [deviceStatue setValue:CurrentVersionNum forKey:@"vc"];
//    [deviceStatue setValue:[self macAddress] forKey:@"mac"];
//    [deviceStatue setValue:@"" forKey:@"imsi"];
//    [deviceStatue setValue:CurrentVersion forKey:@"vn"];
//    [deviceStatue setValue:@"" forKey:@"sid"];
//    [deviceStatue setValue:@"" forKey:@"cpu"];
//    [deviceStatue setValue:@"" forKey:@"channelId"];
//    [deviceStatue setValue:@"" forKey:@"areaName"];
    
    return deviceStatue;
}
//获取Mac地址
- (NSString *)macAddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}
- (NSString*)deviceVersion{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return@"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return@"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return@"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return@"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return@"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return@"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return@"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return@"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return@"iPhone X";
    return deviceString;
}
//------------------------------post请求
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
      origin:(BOOL)isOrigin
     success:(NetworkSuccessBlock)success
     failure:(NetworkFailureBlock)failure
{
//    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if (isOrigin) {
            success(0,@"",responseDict);
            return ;
        }
        NSInteger status = [responseDict[KNetStatus] integerValue];
        NSString * msg = responseDict[KNetMsg];
        id data = responseDict[KNetData];
        if (success) {
            success(status,msg,data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(nil, error);
        }
    }];
}

//------------------------------get请求
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
     origin:(BOOL)isOrigin
    success:(NetworkSuccessBlock)success
    failure:(NetworkFailureBlock)failure
{
    [self.manager GET:URLString parameters:[self setCommonRequestParmas:parameters] progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if (isOrigin) {
            success(0,@"",responseDict);
            return ;
        }
        NSInteger status = [responseDict[KNetStatus] integerValue];
        NSString * msg = responseDict[KNetMsg];
        id data = responseDict[KNetData];
        if (success) {
            success(status,msg,data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(nil, error);
        }
    }];
}

//------------------------------PUT请求

- (void)PUT:(NSString *)URLString
 parameters:(id)parameters
     origin:(BOOL)isOrigin
    success:(NetworkSuccessBlock)success
    failure:(NetworkFailureBlock)failure{
    AFHTTPRequestSerializer *httpRequestSerializer = self.manager.requestSerializer;
    [httpRequestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.manager PUT:URLString parameters:[self setCommonRequestParmas:parameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if (isOrigin) {
            success(0,@"",responseDict);
            return ;
        }
        NSInteger status = [responseDict[KNetStatus] integerValue];
        NSString * msg = responseDict[KNetMsg];
        id data = responseDict[KNetData];
        if (success) {
            success(status,msg,data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(nil, error);
        }
    }];
    
}
//------------------------------DELETE请求
- (void)DELETE:(NSString *)URLString
    parameters:(id)parameters
        origin:(BOOL)isOrigin
       success:(NetworkSuccessBlock)success
       failure:(NetworkFailureBlock)failure{
    [self.manager DELETE:URLString parameters:[self setCommonRequestParmas:parameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if (isOrigin) {
            success(0,@"",responseDict);
            return ;
        }
        NSInteger status = [responseDict[KNetStatus] integerValue];
        NSString * msg = responseDict[KNetMsg];
        id data = responseDict[KNetData];
        if (success) {
            success(status,msg,data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(nil, error);
        }
    }]; 
    
}
@end
