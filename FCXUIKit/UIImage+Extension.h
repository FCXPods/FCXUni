//
//  UIImage+Extension.h
//  Common
//
//  Created by 冯 传祥 on 14-12-5.
//  Copyright (c) 2014年 冯 传祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor*)color;
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size;

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.

- (UIImage *)croppedImageWithRect:(CGRect)rect;

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;


- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

 // We need to calculate the proper transformation to make the image upright.
- (UIImage *)fixOrientation;

+ (UIImage *)circleImageWithColor:(UIColor*)color
                             size:(CGSize)size
                     cornerRadius:(CGFloat)cornerRadius;

@end
