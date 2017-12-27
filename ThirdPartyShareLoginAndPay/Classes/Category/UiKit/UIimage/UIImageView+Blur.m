//
//  UIImageView+Extension.m
//  高斯模糊
//
//  Created by Mr.GCY on 2016/12/8.
//  Copyright © 2016年 Mr.GCY. All rights reserved.
//

#import "UIImageView+Blur.h"

@implementation UIImageView (Blur)
//添加模糊效果
-(void)addBlurEffect{
    //iOS8之后适用
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.bounds;
    [self addSubview:visualEffectView];
}
@end
