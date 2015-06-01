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

@interface PhotoGalleryScrollView()<DetectingImageViewDelegate,UIScrollViewDelegate>

@property(nonatomic,copy)void (^DidEndDeceleratBlock)(NSInteger currentIndex);

@end

@implementation PhotoGalleryScrollView{
    NSInteger currentIndex;
}

-(id)initWithFrame:(CGRect)frame imageViews:(NSMutableArray *)imageViewArray initialPageIndex:(NSInteger)initialPageIndex{
    self =  [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        [self setUp:imageViewArray frame:frame];
        [self setContentOffset:CGPointMake((initialPageIndex-1)*frame.size.width, 0)];
        currentIndex = initialPageIndex;
    }
    
    return self;
}


-(void)setUp:(NSMutableArray *)imageViewArray  frame:(CGRect)frame {
    
    self.photos = [NSMutableArray array];
    for (int i=0; i<imageViewArray.count; i++) {
        UIImageView *igv = (UIImageView *)imageViewArray[i];
        PhotoGalleryImageView *image = [[PhotoGalleryImageView alloc]initWithImage:igv.image];
        image.tapDelegate = self;
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.center = CGPointMake(self.center.x-10+self.frame.size.width*i, self.center.y);
        image.bounds = CGRectMake(0, 0, SCREENWIDTH, igv.image.size.height*SCREENWIDTH/igv.image.size.width);
        
        [self.photos addObject:image];
        [self addSubview:image];
    }
    self.contentSize = CGSizeMake(frame.size.width * imageViewArray.count, frame.size.height);
}


-(NSInteger)currentIndex{
    return currentIndex;
}


-(PhotoGalleryImageView *)currentPhoto{
    PhotoGalleryImageView *currentPhoto = (PhotoGalleryImageView *)[self.photos objectAtIndex:currentIndex-1];
    return currentPhoto;
    
}

-(void)DidEndDeceleratBlock:(void(^)(NSInteger currentIndex))didEndDeceleratBlock{

    self.DidEndDeceleratBlock = didEndDeceleratBlock;
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width + 1;
    
    self.DidEndDeceleratBlock(currentIndex-1);
}


#pragma DetectingImageViewDelegate
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch{
    NSLog(@"singleTap");
    [self.photoGallery dismissPhotoGalleryAnimated:YES];
//    [self.nextResponder methodForSelector:@selector(dismissPhotoGalleryAnimated:)];
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch{
    NSLog(@"doubleTap");
}










@end
