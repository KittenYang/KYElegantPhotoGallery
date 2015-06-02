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

@property(nonatomic,copy)void (^DidScrollBlock)(NSInteger currentIndex);
@property(nonatomic,copy)void (^DidEndDecelerateBlock)(NSInteger currentIndex);

@end

@implementation PhotoGalleryScrollView{
    NSInteger currentIndex;
    BOOL isFirst;
}

-(id)initWithFrame:(CGRect)frame imageViews:(NSMutableArray *)imageViewArray initialPageIndex:(NSInteger)initialPageIndex{
    self =  [super initWithFrame:frame];
    if (self) {
        currentIndex = initialPageIndex;
        isFirst = YES;
        self.hidden = YES;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.backgroundColor = [UIColor clearColor];
        [self setUp:imageViewArray frame:frame];
        [self setContentOffset:CGPointMake((initialPageIndex-1)*frame.size.width, 0)];
    }
    
    return self;
}

-(void)dealloc{
    _photos = nil;
}


-(void)setUp:(NSMutableArray *)imageViewArray  frame:(CGRect)frame {
    
    self.photos = [NSMutableArray array];
    
    @autoreleasepool {
        for (int i=0; i<imageViewArray.count; i++) {
            UIImageView *igv = (UIImageView *)imageViewArray[i];
            PhotoGalleryImageView *image = [[PhotoGalleryImageView alloc]initWithImage:igv.image];
            image.tapDelegate = self;
            image.contentMode = UIViewContentModeScaleAspectFit;
            image.center = CGPointMake(self.center.x-10+self.frame.size.width*i, self.center.y);
            image.bounds = CGRectMake(0, 0, SCREENWIDTH, igv.image.size.height*SCREENWIDTH/igv.image.size.width);
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius  = 8.0f;
            
            [self.photos addObject:image];
            [self addSubview:image];
        }        
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


#pragma method
-(void)DidScrollBlock:(void(^)(NSInteger currentIndex))didEndScrollBlock{

    self.DidScrollBlock = didEndScrollBlock;
    
}

-(void)DidEndDecelerateBlock:(void(^)(NSInteger currentIndex))didEndDeceleratBlock{
    self.DidEndDecelerateBlock = didEndDeceleratBlock;
}


#pragma UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (isFirst) {
        isFirst = NO;
    }else{
        currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width + 1;
        currentIndex = MAX(1, currentIndex);
        self.DidScrollBlock(currentIndex-1);
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (isFirst) {
        isFirst = NO;
    }else{
        currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width + 1;
        currentIndex = MAX(1, currentIndex);
        self.DidEndDecelerateBlock(currentIndex-1);
    }
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
