//
//  UIColor+Hex.m
//  redPacketDemo
//
//  Created by Mr.GCY on 2016/12/6.
//  Copyright © 2016年 Mr.GCY. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (UIColor *)colorWithHexString:(NSString *)hex withAlpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hex{
    return [UIColor colorWithHexString:hex withAlpha:1];
}

+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha{
    
    CGFloat r = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat g = ((hex & 0x00FF00) >> 8 ) / 255.0;
    CGFloat b = ((hex & 0x0000FF)      ) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hex{
    return [UIColor colorWithHex:hex withAlpha:1];
}


- (UIColor *)colorCoveredWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
    Byte colorComponents[10  * 10 * 4] = { 0 };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(colorComponents, 10, 10, 8, 40, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGFloat selfColorComponents[4];
    [self getRed:selfColorComponents green:selfColorComponents + 1 blue:selfColorComponents + 2 alpha:selfColorComponents + 3];
    CGContextSetFillColor(context, selfColorComponents);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 10.0f, 10.0f));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
    [path fill];
    
    [color setFill];
    [path fillWithBlendMode:blendMode alpha:1.0f];
    
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *retval = [UIColor colorWithRed:colorComponents[0]/255.0
                                      green:colorComponents[1]/255.0
                                       blue:colorComponents[2]/255.0
                                      alpha:colorComponents[3]/255.0];
    
    return retval;
}

- (UIColor *)colorCoveredWithColor:(UIColor *)color {
    return [self colorCoveredWithColor:color blendMode:kCGBlendModeNormal];
}

@end
