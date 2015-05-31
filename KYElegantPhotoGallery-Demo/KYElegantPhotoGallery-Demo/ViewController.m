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

@end

@implementation ViewController{
//    UIImageView *testImageView;
    NSMutableArray *imageViewArray;
    NSMutableArray *images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [NSMutableArray array];
    for (int i =0; i<6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bkgImg%d.jpg",i+1]];
        [images addObject:image];
    }
    
//    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    actionButton.backgroundColor = [UIColor clearColor];
//    [actionButton setTitle:@"Present" forState:UIControlStateNormal];
//    actionButton.center = self.view.center;
//    actionButton.bounds = CGRectMake(0, 0, 100, 30);
//    [actionButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:actionButton];
    
    
//    testImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    testImageView.center = CGPointMake(actionButton.center.x, actionButton.center.y + IMAGE_SIZE);
//    testImageView.clipsToBounds = YES;
//    testImageView.bounds = CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE);
//    testImageView.image  = [UIImage imageNamed:@"bkgImg.jpg"];
//    testImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:testImageView];
    
    [self setTestImages];
}

-(void)setTestImages{
    
    imageViewArray = [NSMutableArray array];
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

#pragma mark -- Tapped
- (void)imgTaped:(UITapGestureRecognizer *)sender{
    
    KYPhotoGallery *photoGallery = [[KYPhotoGallery alloc]initWithTappedImageView:(UIImageView *)sender.view];

    photoGallery.imageViewArray = imageViewArray;
    photoGallery.initialPageIndex = sender.view.tag;
    [self presentViewController:photoGallery animated:NO completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
