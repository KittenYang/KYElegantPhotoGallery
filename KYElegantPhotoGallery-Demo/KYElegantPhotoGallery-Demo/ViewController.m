//
//  ViewController.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define IMAGE_SIZE  60
#define PADDING (SCREENWIDTH-IMAGE_SIZE*3)/4

#import "ViewController.h"
#import "KYPhotoGallery.h"
#import "Macro.h"

@interface ViewController ()

@property(nonatomic,strong)KYPhotoGallery *photoGallery;

@end

@implementation ViewController{
//    UIImageView *testImageView;
    NSMutableArray *imageViewArray;
    NSMutableArray *images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [NSMutableArray array];
    @autoreleasepool{
        for (int i =0; i<6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bkgImg%d.jpg",i+1]];
            [images addObject:image];
        }
    }
    
    [self setTestImages];
}

-(void)setTestImages{
    
    imageViewArray = [NSMutableArray array];
    @autoreleasepool{
        for (int i = 0; i<6; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            if (i < 3) {
                img.frame = CGRectMake(PADDING + i*(IMAGE_SIZE+PADDING), self.view.center.y-IMAGE_SIZE-10, IMAGE_SIZE, IMAGE_SIZE);
            }else{
                img.frame = CGRectMake(PADDING + (i-3)*(IMAGE_SIZE+PADDING), self.view.center.y+IMAGE_SIZE+10, IMAGE_SIZE, IMAGE_SIZE);
            }
            img.clipsToBounds = YES;
            img.userInteractionEnabled = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.image = images[i];
            img.tag = i+1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTaped:)];
            [img addGestureRecognizer:tap];
            [self.view addSubview:img];
            
            [imageViewArray addObject:img];
        }
    }
}

#pragma mark -- Tapped
- (void)imgTaped:(UITapGestureRecognizer *)sender{
    
    _photoGallery = [[KYPhotoGallery alloc]initWithTappedImageView:(UIImageView *)sender.view];
    _photoGallery.imageViewArray = imageViewArray;
    _photoGallery.initialPageIndex = sender.view.tag;
    [self presentViewController:_photoGallery animated:NO completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
