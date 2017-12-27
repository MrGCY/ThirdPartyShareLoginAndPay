//
//  UIView+TT.h
//  HongBao
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//


/**
 *  UIImage 扩展
 */
#import <UIKit/UIKit.h>

@interface UIImage (TT)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
// Load image from bundle
+ (UIImage *)imageNamed:(NSString*)imageName module:(NSString*)moduleName;


// Draw and Cache
/* Returns a `UIImage` rendered with the drawing code in the block.
 This method does not cache the image object. */
+ (UIImage *)imageForSize:(CGSize)size withDrawingBlock:(void(^)())drawingBlock;
+ (UIImage *)imageForSize:(CGSize)size opaque:(BOOL)opaque withDrawingBlock:(void(^)())drawingBlock;

/** Returns a cached `UIImage` rendered with the drawing code in the block.
 The `UIImage` is cached in an `NSCache` with the identifier provided. */
+ (UIImage *)imageWithIdentifier:(NSString *)identifier forSize:(CGSize)size andDrawingBlock:(void(^)())drawingBlock;
+ (UIImage *)imageWithIdentifier:(NSString *)identifier opaque:(BOOL)opaque forSize:(CGSize)size andDrawingBlock:(void(^)())drawingBlock;

/** Return the cached image for the identifier, or nil if there is no cached image. */
+ (UIImage *)imageWithIdentifier:(NSString *)identifier;

/** Remove the cached image for the identifier. */
+ (void)removeCachedImageWithIdentifier:(NSString *)identifier;

/** Remove all cached images. */
+ (void)removeAllCachedImages;

/** Scale or compress image */
- (UIImage *)imageWithFileSize:(NSUInteger)fileSize;
    
- (UIImage *)imageWithFileSize:(NSUInteger)size
                  scaledToSize:(CGSize)newSize;


@end
