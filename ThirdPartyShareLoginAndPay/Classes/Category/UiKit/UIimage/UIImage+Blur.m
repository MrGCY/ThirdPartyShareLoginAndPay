//
//  UIImage+Extension.m
//  高斯模糊
//
//  Created by Mr.GCY on 2016/12/8.
//  Copyright © 2016年 Mr.GCY. All rights reserved.
//

#import "UIImage+Blur.h"
#import <Accelerate/Accelerate.h>
@implementation UIImage (Blur)
-(UIImage *)creatBlurRadius:(CGFloat)radius{
    //获取需要滤镜的图片资源。
    CIImage *ciimage = [[CIImage alloc]
                        initWithCGImage:self.CGImage];
    //获取滤镜使用filterWithName指定哪种滤镜效果
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    NSLog(@"%@",filter.attributes);
    //将图片输入到滤镜中，打个比方：滤镜是个具有某个功能的容器，任何东西放进去，拿出来的时候就会附上效果。
    //将图片输入到滤镜中
    [filter setValue:ciimage forKey:kCIInputImageKey];
    [filter setValue:@(radius) forKey:@"inputRadius"];
    //从滤镜容器中取出图片  这里还有一种输出方式：使用CIcontext
    CIImage * result = [filter valueForKey:kCIOutputImageKey];
    CIContext * context = [[CIContext alloc] initWithOptions:nil];
    return [[UIImage alloc] initWithCGImage:[context createCGImage:result fromRect:[result extent]]];;
}

/**
 vImage 方式
 *  图片添加高斯模糊效果
 */
- (UIImage *)blurryWithBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(self.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
