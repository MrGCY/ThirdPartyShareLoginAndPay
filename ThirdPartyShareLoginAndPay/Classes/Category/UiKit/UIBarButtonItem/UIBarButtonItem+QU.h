//
//  UIBarButtonItem+QU.h
//  QuizzesApp
//
//  Created by Gauss on 2017/12/5.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (QU)
//快速创建一个显示图片的Item
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

//返回一个有图片的Item
+ (UIImageView *)viewWithImageName:(NSString *)imageName andFrame:(CGRect)frame;

//返回一个只有一张图片的Item
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

//返回一个图片按原图片样式显示的BarButtonItem
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image andHighlightedImage:(UIImage *)image target:(id)target action:(SEL)action;

//返回一个左侧图片和右侧文字的Item
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName andLabel:(NSString *)labelStr  target:(id)target action:(SEL)action;

//返回一个自定义的UIBarButtonItem
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName imageFrame:(CGRect)imageFrame andLabel:(NSString *)labelStr labelFrame:(CGRect)labelFrame andBackgroundImage:(NSString *)BackgroundImage andHighlightedImage:(NSString *)HighlightedImage target:(id)target action:(SEL)action;

//返回一个有背景图片和文字的Item
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title andImage:(UIImage *)image andHighlightedImage:(UIImage *)image target:(id)target action:(SEL)action;

//返回一个只有文字的Item(不能点击)
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title;
//返回一个只有文字的Item
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
