//
//  KYPhotoGallery.h
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYPhotoGallery : UIViewController

-(id)initWithTappedImageView:(UIImageView *)tappedImageView;

@property(nonatomic,strong)NSMutableArray *imageViewArray;
@property(nonatomic,assign)NSInteger initialPageIndex;


-(void)dismissPhotoGalleryAnimated:(BOOL)animated;

@end
