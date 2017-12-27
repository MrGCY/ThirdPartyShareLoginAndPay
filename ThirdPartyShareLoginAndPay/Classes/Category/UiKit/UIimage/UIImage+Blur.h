//
//  UIImage+Extension.h
//  高斯模糊
//
//  Created by Mr.GCY on 2016/12/8.
//  Copyright © 2016年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)
//创建高斯模糊的图片
-(UIImage *)creatBlurRadius:(CGFloat)radius;
/**
 *  图片添加高斯模糊效果
 */
- (UIImage *)blurryWithBlurLevel:(CGFloat)blur;
@end
