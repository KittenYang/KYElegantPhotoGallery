//
//  PhotoZoomScrollView.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 6/5/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PhotoZoomScrollView.h"



@interface PhotoZoomScrollView() <DetectingImageViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak)KYPhotoGallery *photoGallery;

@end

@implementation PhotoZoomScrollView

-(id)initWithPhotoGallery:(KYPhotoGallery *)photoGallery{
    self = [super init];
    if (self) {
        _photoGallery = photoGallery;
        self.delegate = self;
        self.maximumZoomScale = 2.0f;
    
    }
    
    return self;
}


#pragma private method
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma DetectingImageViewDelegate
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch{
    [self.photoGallery performSelector:@selector(dismissPhotoGalleryAnimated:) withObject:@(YES) afterDelay:0.2];
    NSLog(@"singleTap");
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.photoGallery];
    
    NSLog(@"doubleTap");
    
    // Zoom
    if (self.zoomScale == self.maximumZoomScale) {
        
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        CGPoint touchPoint = [touch locationInView:imageView];
        touchPoint = [self convertPoint:touchPoint fromView:imageView];
        
        // Zoom in
        CGRect zoomRect = [self zoomRectForScale:self.maximumZoomScale withCenter:touchPoint];
        [self zoomToRect:zoomRect animated:YES];
        
    }
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.currentPhoto;
}




@end
