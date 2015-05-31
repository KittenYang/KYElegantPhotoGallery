//
//  ViewController.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define IMAGE_SIZE  60

#import "ViewController.h"
#import "KYPhotoGallery.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIImageView *testImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    actionButton.backgroundColor = [UIColor clearColor];
    [actionButton setTitle:@"Present" forState:UIControlStateNormal];
    actionButton.center = self.view.center;
    actionButton.bounds = CGRectMake(0, 0, 100, 30);
    [actionButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionButton];
    
    
    testImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    testImageView.center = CGPointMake(actionButton.center.x, actionButton.center.y + IMAGE_SIZE);
    testImageView.clipsToBounds = YES;
    testImageView.bounds = CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE);
    testImageView.image  = [UIImage imageNamed:@"bkgImg.jpg"];
    testImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:testImageView];
}


#pragma mark -- Tapped
- (void)buttonTaped:(UIButton *)button{

    KYPhotoGallery *photoGallery = [[KYPhotoGallery alloc]init];
    photoGallery.fromImageView = testImageView;
    [self presentViewController:photoGallery animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
