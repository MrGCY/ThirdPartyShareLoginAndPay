//
//  UIBarButtonItem+QU.m
//  QuizzesApp
//
//  Created by Gauss on 2017/12/5.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "UIBarButtonItem+QU.h"
//获取屏幕宽高
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
#define KNavbarItemFont [UIFont systemFontOfSize:18.0f]
@implementation UIBarButtonItem (QU)
//快速创建一个显示图片的Item
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIImage *img = [UIImage imageNamed:imageName];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[img imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:target action:action];
    return item;
}

//返回一个只有一张图片的Item
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:target action:action];
    return item;
}

//返回一个图片按原图片样式显示的BarButtonItem
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image andHighlightedImage:(UIImage *)HighlightedImage target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:target action:action];
    [item setBackgroundImage:HighlightedImage forState:(UIControlStateHighlighted) barMetrics:(UIBarMetricsDefault)];
    return item;
}

//返回一个左侧图片和右侧文字的Item
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName andLabel:(NSString *)labelStr target:(id)target action:(SEL)action
{
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imgView.frame = CGRectMake(0, 10, 24, 24);
    
    CGSize textSize = [self sizeWithText:labelStr font:KNavbarItemFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.text = labelStr;
    label.font = [UIFont systemFontOfSize:17];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if(textSize.width > (KMainW - 170)) {
        label.frame = CGRectMake(24, 10, KMainW - 250, 25);
    }else {
        label.frame = CGRectMake(24, 10, textSize.width, 25);
    }
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addSubview:imgView];
    [btn addSubview:label];
    [btn addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

//返回一个自定义的UIBarButtonItem
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName imageFrame:(CGRect)imageFrame andLabel:(NSString *)labelStr labelFrame:(CGRect)labelFrame andBackgroundImage:(NSString *)BackgroundImage andHighlightedImage:(NSString *)HighlightedImage target:(id)target action:(SEL)action
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imgView.frame = imageFrame;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.text = labelStr;
    label.font = [UIFont systemFontOfSize:17];
    label.frame = labelFrame;
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 0, labelFrame.size.width+imageFrame.size.width+20, 35);
    [btn setBackgroundImage:[UIImage imageNamed:BackgroundImage] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:HighlightedImage] forState:(UIControlStateHighlighted)];
    [btn addSubview:imgView];
    [btn addSubview:label];
    [btn addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

//返回一个有图片的Item
+ (UIImageView *)viewWithImageName:(NSString *)imageName andFrame:(CGRect)frame
{
    UIImageView *imgVIew = [[UIImageView alloc] initWithFrame:frame];
    imgVIew.image = [UIImage imageNamed:imageName];
    return imgVIew;
}

//返回一个有背景图片和文字的Item
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title andImage:(UIImage *)image andHighlightedImage:(UIImage *)image1 target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setBackgroundImage:image forState:(UIControlStateNormal)];
    [btn setImage:image1 forState:(UIControlStateHighlighted)];
    btn.frame = CGRectMake(0, 0, 45, 20);
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
//返回一个只有文字的Item
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 0, 45, 20);
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
//返回一个只有文字的Item(不能点击)
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
{
    CGSize textSize = [self sizeWithText:title font:KNavbarItemFont maxSize:CGSizeMake(300, MAXFLOAT)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width, 20)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc]initWithCustomView:label];
    return labelItem;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
