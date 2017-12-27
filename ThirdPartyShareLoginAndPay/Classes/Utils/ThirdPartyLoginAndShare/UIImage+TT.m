//
//  UIView+TT.m
//  HongBao
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "UIImage+TT.h"
#import "ThirdPartySystemCommon.h"

@implementation UIImage (TT)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageNamed:(NSString*)imageName module:(NSString*)moduleName
{
    UIImage *externalImage = [UIImage imageNamed:imageName];
    if (externalImage) {
        return externalImage;
    }
    
#ifdef __IPHONE_8_0
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0    //Minimum Target iOS 8+
    
    // Get the top level "bundle" which may actually be the framework
    NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(moduleName)];
    
    // Check to see if the resource bundle exists inside the top level bundle
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:moduleName ofType:@"bundle"]];
    
    if (resourcesBundle == nil) {
        resourcesBundle = mainBundle;
    }
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];

#else   //Minimum Target iOS7+
    
    UIImage *image;
    
    if (IS_IOS8)
    {
        // Get the top level "bundle" which may actually be the framework
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(moduleName)];
        
        // Check to see if the resource bundle exists inside the top level bundle
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:moduleName ofType:@"bundle"]];
        
        if (resourcesBundle == nil) {
            resourcesBundle = mainBundle;
        }
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];

    }
    else
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@",moduleName,imageName]];
    }
    
#endif
    
#else   //Maximum target iOS 7
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@",moduleName,imageName]];
#endif
    return image;
}


#pragma mark - Draw&Cache

+ (NSCache *)drawingCache{
    static NSCache *cache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}

+ (UIImage *)imageForSize:(CGSize)size opaque:(BOOL)opaque withDrawingBlock:(void(^)())drawingBlock{
    if(size.width <= 0.0f || size.height <= 0.0f){
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0f);
    if(drawingBlock){
        drawingBlock();
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageForSize:(CGSize)size withDrawingBlock:(void(^)())drawingBlock{
    return [self imageForSize:size opaque:NO withDrawingBlock:drawingBlock];
}

+ (UIImage *)imageWithIdentifier:(NSString *)identifier opaque:(BOOL)opaque forSize:(CGSize)size andDrawingBlock:(void(^)())drawingBlock{
    UIImage *image = [[self drawingCache] objectForKey:identifier];
    if(image == nil && (image = [self imageForSize:size opaque:opaque withDrawingBlock:drawingBlock])){
        [[self drawingCache] setObject:image forKey:identifier];
    }
    return image;
}

+ (UIImage *)imageWithIdentifier:(NSString *)identifier forSize:(CGSize)size andDrawingBlock:(void(^)())drawingBlock{
    return [self imageWithIdentifier:identifier opaque:NO forSize:size andDrawingBlock:drawingBlock];
}

+ (UIImage *)imageWithIdentifier:(NSString *)identifier{
    return [[self drawingCache] objectForKey:identifier];
}

+ (void)removeCachedImageWithIdentifier:(NSString *)identifier{
    [[self drawingCache] removeObjectForKey:identifier];
}

+ (void)removeAllCachedImages{
    [[self drawingCache] removeAllObjects];
}

#pragma mark scale
- (UIImage *)imageWithFileSize:(NSUInteger)fileSize
{
    UIImage *newImage = self;
    NSData * imageData = UIImageJPEGRepresentation(self,1);
    NSUInteger oFileSize = imageData.length;
    if (oFileSize < fileSize) {
        return newImage;
    }
    
    CGFloat compression = 1.0f;
    
    while ([imageData length] > fileSize && compression >= 0) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(newImage, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
    
}

    
- (UIImage *)imageWithFileSize:(NSUInteger)fileSize
                  scaledToSize:(CGSize)targetSize
{
    
    //scale
    UIImage *sourceImage = self;
    UIImage *newImage = self;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        scaleFactor = widthFactor; // scale to fit height
        else
        scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
        
        UIGraphicsBeginImageContext(targetSize); // this will crop
        
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width= scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
        
        if(newImage == nil)
        {
            NSLog(@"could not scale image");
            return self;
        }
        
    }
    
    //compress
    NSData * imageData = UIImageJPEGRepresentation(newImage,1);
    NSUInteger oFileSize = imageData.length;
    if (oFileSize < fileSize) {
        return newImage;
    }
    
    CGFloat compression = 1.0f;
    
    while ([imageData length] > fileSize && compression > 0) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(newImage, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

@end
