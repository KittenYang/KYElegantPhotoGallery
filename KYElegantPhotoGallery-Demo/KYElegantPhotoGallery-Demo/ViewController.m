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
    NSMutableArray *imagesUrls;
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
    
    imagesUrls = [NSMutableArray arrayWithObjects:
                  @"http://ww1.sinaimg.cn/bmiddle/62dd2005jw1esphsmx3o4j20rs0rsaco.jpg",
                  @"http://ww1.sinaimg.cn/bmiddle/7f5cf1ffgw1espju5u0awj20lc0c03yz.jpg",
                  @"http://ww4.sinaimg.cn/bmiddle/7f5cf1ffgw1espjpik3anj20zk0k075x.jpg",
                  @"http://ww3.sinaimg.cn/bmiddle/7f5cf1ffgw1esmpp5o7dkj20fi08rta7.jpg",
                  @"http://ww2.sinaimg.cn/bmiddle/7f5cf1ffgw1esm8ezg84qj20lc0c0ac5.jpg",
                  @"http://ww4.sinaimg.cn/bmiddle/7f5cf1ffgw1esm88fpwwyj20zk0k0mzu.jpg",
                  nil];

    
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
    
    _photoGallery = [[KYPhotoGallery alloc]initWithTappedImageView:(UIImageView *)sender.view andImageUrls:imagesUrls andInitialIndex:sender.view.tag];
    _photoGallery.imageViewArray = imageViewArray;
    [_photoGallery finishAsynDownload:^{
        [self presentViewController:_photoGallery animated:NO completion:nil];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
