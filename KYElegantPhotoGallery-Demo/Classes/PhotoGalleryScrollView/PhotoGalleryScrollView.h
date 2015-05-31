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

@property (nonatomic,strong)KYPhotoGallery *photoGallery;

-(id)initWithFrame:(CGRect)frame imageViews:(NSMutableArray *)imageViewArray imageLocation:(CGRect)imageFrame initialPageIndex:(NSInteger)initialPageIndex;


@end
