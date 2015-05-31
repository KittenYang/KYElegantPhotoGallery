//
//  UIImage+Blur.h
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

+ (UIImage *)blurImage:(UIImage *)image WithRadius:(CGFloat)blurRadius;

@end
