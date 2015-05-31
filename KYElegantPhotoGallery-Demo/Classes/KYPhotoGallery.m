//
//  KYPhotoGallery.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//


#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height


#import "KYPhotoGallery.h"
#import "UIImage+Blur.h"
#import "Macro.h"

@interface KYPhotoGallery ()

@property(nonatomic,strong)UIView *fadeView;
@property(nonatomic,strong)UIImageView *initialImageView;
@property(nonatomic,assign)CGRect finalImageViewFrame;

@end

@implementation KYPhotoGallery{
    
    UIImage *fromVCSnapShot;
    
    // iOS 7
    UIViewController *_applicationTopViewController;
    int _previousModalPresentationStyle;
}

-(id)init{
    self = [super init];
    if (self) {
        
        fromVCSnapShot = [self screenshot];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            self.modalPresentationStyle = UIModalPresentationCustom;
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.modalPresentationCapturesStatusBarAppearance = YES;
        }else{
            _applicationTopViewController = [self topviewController];
            _previousModalPresentationStyle = _applicationTopViewController.modalPresentationStyle;
            _applicationTopViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        }
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //模糊图层
    
    UIImageView *blurView = [[UIImageView alloc]initWithImage:[UIImage blurImage:fromVCSnapShot WithRadius:0.5]];
    blurView.frame = self.view.frame;
    [self.view addSubview:blurView];
    
    
    //黑色背景图层
    _fadeView = [[UIView alloc]initWithFrame:self.view.frame];
    _fadeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_fadeView];


    //退出按钮
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    actionButton.backgroundColor = [UIColor redColor];
    [actionButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    actionButton.center = self.view.center;
    actionButton.bounds = CGRectMake(0, 0, 100, 30);
    [actionButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionButton];
    
    //初始位置的imageView
    self.initialImageView = [[UIImageView alloc]initWithImage:self.fromImageView.image];
    self.initialImageView.frame = [self.fromImageView.superview convertRect:self.fromImageView.frame toView:nil];
    self.initialImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.initialImageView];
    
    float scaleFactor = self.fromImageView.image.size.width / SCREENWIDTH;
    self.finalImageViewFrame = CGRectMake(0, (SCREENHEIGHT/2)-((self.fromImageView.image.size.height / scaleFactor)/2), SCREENWIDTH, self.fromImageView.image.size.height / scaleFactor);
    


}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        _fadeView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.initialImageView.frame = self.finalImageViewFrame;
    } completion:nil];
    
}

- (void)buttonTaped:(UIButton *)button{
    [self dismissPhotoGalleryAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma dismiss
-(void)dismissPhotoGalleryAnimated:(BOOL)animated{
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:animated completion:^{
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
        {
            _applicationTopViewController.modalPresentationStyle = _previousModalPresentationStyle;
        }
    }];

}

#pragma Helper
- (UIViewController *)topviewController
{
    UIViewController *topviewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topviewController.presentedViewController) {
        topviewController = topviewController.presentedViewController;
    }
    
    return topviewController;
}


//Snapshot
- (UIImage *)screenshot
{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}






@end
