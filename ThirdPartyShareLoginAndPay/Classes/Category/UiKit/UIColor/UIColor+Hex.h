//
//  UIColor+Hex.h
//  redPacketDemo
//
//  Created by Mr.GCY on 2016/12/6.
//  Copyright © 2016年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)hex withAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hex;


@end
