//
//  PhotoGalleryScrollView.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PhotoGalleryScrollView.h"
#import "PhotoGalleryImageView.h"
#import "Macro.h"
#import "KYPhotoGallery.h"


@interface PhotoGalleryScrollView()<DetectingImageViewDelegate>


@end

@implementation PhotoGalleryScrollView

-(id)initWithFrame:(CGRect)frame imageViews:(NSMutableArray *)imageViewArray imageLocation:(CGRect)imageFrame initialPageIndex:(NSInteger)initialPageIndex{
    self =  [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self setUp:imageViewArray frame:frame imageFrame:imageFrame];
        [self setContentOffset:CGPointMake((initialPageIndex-1)*frame.size.width, 0)];
    }
    
    return self;
}


-(void)setUp:(NSMutableArray *)imageViewArray  frame:(CGRect)frame imageFrame:(CGRect)imageFrame{
    
    for (int i=0; i<imageViewArray.count; i++) {
        UIImageView *igv = (UIImageView *)imageViewArray[i];
        PhotoGalleryImageView *image = [[PhotoGalleryImageView alloc]initWithImage:igv.image];
        image.tapDelegate = self;
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.frame = CGRectMake(i*(SCREENWIDTH+PHOTOS_SPACING), imageFrame.origin.y, imageFrame.size.width, imageFrame.size.height);
        [self addSubview:image];
    }
    self.contentSize = CGSizeMake(frame.size.width * imageViewArray.count, frame.size.height);
}


#pragma DetectingImageViewDelegate
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch{
    NSLog(@"singleTap");
    [self.photoGallery dismissPhotoGalleryAnimated:YES];
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch{
    NSLog(@"doubleTap");
}









@end
