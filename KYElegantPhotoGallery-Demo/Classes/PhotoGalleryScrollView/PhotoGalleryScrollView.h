//
//  PhotoGalleryScrollView.h
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoGalleryImageView.h"

@class KYPhotoGallery;
@interface PhotoGalleryScrollView : UIScrollView

@property (nonatomic,weak)KYPhotoGallery *photoGallery;
@property (nonatomic,strong)NSMutableArray *photos;      //ScrollView上的所有照片


-(id)initWithFrame:(CGRect)frame imageViews:(NSMutableArray *)imageViewArray initialPageIndex:(NSInteger)initialPageIndex;

-(void)DidEndDeceleratBlock:(void(^)(NSInteger currentIndex))didEndDeceleratBlock;

-(NSInteger)currentIndex; // 当前图片的编号
-(PhotoGalleryImageView *)currentPhoto;


@end
