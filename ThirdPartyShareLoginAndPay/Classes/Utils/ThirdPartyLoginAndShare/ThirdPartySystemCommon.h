//
//  ThirdPartySystemCommon.h
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/19.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#ifndef ThirdPartySystemCommon_h
#define ThirdPartySystemCommon_h

#define SYSTEM_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue]

#define IS_IOS10                     (SYSTEM_VERSION >= 10)
#define IS_IOS9                     (SYSTEM_VERSION >= 9)
#define IS_IOS8                     (SYSTEM_VERSION >= 8)
#define IS_IOS7                     (SYSTEM_VERSION >= 7)
#define IS_IPHONE4                  (SCREEN_HEIGHT < 568)
#define IS_IPHONE5                  (SCREEN_HEIGHT == 568)
#define IS_IPHONE6                  (SCREEN_HEIGHT == 667)
#define IS_IPHONE6Plus              (SCREEN_HEIGHT == 736)

#endif /* ThirdPartySystemCommon_h */
