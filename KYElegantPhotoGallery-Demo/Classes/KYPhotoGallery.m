//
//  KYPhotoGallery.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//



#import "KYPhotoGallery.h"
#import "UIImage+ImageEffects.h"
#import "Macro.h"
#import "PhotoGalleryScrollView.h"

@interface KYPhotoGallery ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView *fromImageView;
@property(nonatomic,strong)UIImageView *blurView;
@property(nonatomic,strong)PhotoGalleryScrollView *photosGalleryScroll;
@property(nonatomic,strong)UIImageView *animatedImageView;
@property(nonatomic,assign)CGRect initialImageViewFrame;
@property(nonatomic,assign)CGRect finalImageViewFrame;

@end

@implementation KYPhotoGallery{
    
    UIImage *fromVCSnapShot;
    
    // iOS 7
    UIViewController *_applicationTopViewController;
    int _previousModalPresentationStyle;
}

-(id)initWithTappedImageView:(UIImageView *)tappedImageView{
    self = [super init];
    if (self) {
        
        self.fromImageView = tappedImageView;
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

    
}


- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    //initial
    self.fromImageView.hidden = YES;
    fromVCSnapShot = [self screenshot];
    self.view.backgroundColor = [UIColor clearColor];
    float scaleFactor = self.fromImageView.image.size.width / SCREENWIDTH;
    
    self.initialImageViewFrame = [self.fromImageView.superview convertRect:self.fromImageView.frame toView:nil];
    
    self.finalImageViewFrame = CGRectMake(0, (SCREENHEIGHT/2)-((self.fromImageView.image.size.height / scaleFactor)/2), SCREENWIDTH, self.fromImageView.image.size.height / scaleFactor);
    
    
    //模糊图层
    self.blurView = [[UIImageView alloc]initWithImage:[fromVCSnapShot applyDarkEffect]];
    self.blurView.frame = self.view.frame;
    self.blurView.alpha = 0.0f;
    [self.view addSubview:self.blurView];
    

    
    //图片滚动视图
    _photosGalleryScroll = [[PhotoGalleryScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+PHOTOS_SPACING, self.view.frame.size.height) imageViews:self.imageViewArray initialPageIndex:self.initialPageIndex];
    _photosGalleryScroll.photoGallery = self;
    [self.view addSubview:_photosGalleryScroll];
    
    
    //动画视图
    self.animatedImageView = [[UIImageView alloc]initWithImage:self.fromImageView.image];
    self.animatedImageView.frame = self.initialImageViewFrame;
    self.animatedImageView.clipsToBounds = YES;
    self.animatedImageView.layer.cornerRadius = 8.0f;
    self.animatedImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.animatedImageView belowSubview:self.photosGalleryScroll];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view addGestureRecognizer:pan];
    
    
    [UIView animateWithDuration:ANIMATEDURATION delay:0.0 usingSpringWithDamping:ANIMATEDAMPING initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.blurView.alpha = 1.0f;
        self.animatedImageView.frame = self.finalImageViewFrame;
        
    } completion:^(BOOL finished) {

        self.photosGalleryScroll.hidden = NO;
        self.animatedImageView.hidden   = YES;
    }];
    
    
    [self.photosGalleryScroll DidEndDeceleratBlock:^(NSInteger currentIndex) {
        self.fromImageView.hidden = NO;
        self.fromImageView = (UIImageView *)self.imageViewArray[currentIndex];
        self.fromImageView.hidden = YES;
        self.initialImageViewFrame = [self.fromImageView.superview convertRect:self.fromImageView.frame toView:nil];
        self.animatedImageView.image = self.fromImageView.image;
        NSLog(@"currentIndex:%ld",currentIndex);
    }];
    
}


-(void)panGestureRecognized:(UIPanGestureRecognizer *)pan{
    
    static CGPoint initialPoint;
    CGFloat factor = 0.0f;
    CGPoint transition = [pan translationInView:self.view];
    PhotoGalleryImageView *currentPhoto = (PhotoGalleryImageView *)[self.photosGalleryScroll currentPhoto];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        NSLog(@"currentIndex:%ld",self.photosGalleryScroll.currentIndex);
        initialPoint = currentPhoto.center;
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        
        
        currentPhoto.center = CGPointMake(initialPoint.x,initialPoint.y + transition.y);
        self.animatedImageView.center = CGPointMake(self.animatedImageView.center.x, currentPhoto.center.y);
        factor = ABS(transition.y)<= SCROLLDISTANCE ? MIN(1,ABS(transition.y) / SCROLLDISTANCE) : MAX(0, 1 - MAX(0, (ABS(transition.y) - SCROLLDISTANCE) / SCROLLDISTANCE));

        
        CATransform3D t = CATransform3DIdentity;
        t.m34  = 1.0/-1000;
        t = CATransform3DRotate(t,factor*(M_PI/6), transition.y>0?-1:1, 0, 0);

        t = CATransform3DScale(t,ABS(transition.y)<= SCROLLDISTANCE? 1-factor*0.1 : 0.9, ABS(transition.y)<= SCROLLDISTANCE?1-factor*0.1 : 0.9, 0);
        
        currentPhoto.layer.transform = t;
        
        self.blurView.alpha = 1 - MIN(0.5,MIN(1,ABS(transition.y) / 250));
        
        NSLog(@"factor:%f",factor);
        
        
    }else if ((pan.state == UIGestureRecognizerStateEnded) || (pan.state ==UIGestureRecognizerStateCancelled)){
        
        if (ABS(transition.y) > SCROLLDISTANCE) {
            
            [self dismissPhotoGalleryAnimated:YES];
            
        }else{
            
            currentPhoto.layer.transform = CATransform3DIdentity;
            [UIView animateWithDuration:ANIMATEDURATION delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                currentPhoto.center = initialPoint;
                self.blurView.alpha = 1.0f;
            } completion:nil];
            
        }
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    _fromImageView = nil;
    _blurView = nil;
    _photosGalleryScroll = nil;
    _animatedImageView = nil;
    _imageViewArray = nil;
    fromVCSnapShot = nil;
    _applicationTopViewController = nil;

}



#pragma dismiss
-(void)dismissPhotoGalleryAnimated:(BOOL)animated{
    
    @autoreleasepool {
        for (UIImageView *igv in self.imageViewArray) {
            if (![igv isEqual:self.fromImageView]) {
                igv.hidden = NO;
            }
        }
    }

    self.animatedImageView.hidden   = NO;
    self.animatedImageView.layer.cornerRadius = 0.0f;
    self.photosGalleryScroll.hidden = YES;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [UIView animateWithDuration:ANIMATEDURATION delay:0.0f usingSpringWithDamping:ANIMATEDAMPING initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blurView.alpha = 0.0f;
        self.animatedImageView.frame = self.initialImageViewFrame;

        self.presentingViewController.view.transform = CGAffineTransformIdentity;

        
    } completion:^(BOOL finished) {
        
        self.animatedImageView.hidden = YES;
        self.fromImageView.hidden = NO;
        [self dismissViewControllerAnimated:animated completion:^{
            
            if (SYSTEM_VERSION_LESS_THAN(@"8.0")){
                _applicationTopViewController.modalPresentationStyle = _previousModalPresentationStyle;
            }
        }];
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
