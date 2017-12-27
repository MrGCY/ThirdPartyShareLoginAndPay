//
//  CMAPIGenerate.h
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/21.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
//是不是测试环境
#define APITEST [[NSBundle mainBundle].infoDictionary[@"APITEST"] boolValue]
@interface APIGenerate : NSObject
+(APIGenerate*)sharedInstance;
-(NSString*)API:(NSString*)apiName;
//没有？
-(NSString*)APINomark:(NSString*)apiName;
@end
