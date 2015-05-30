//
//  KYPhotoGallery.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYPhotoGallery.h"

@interface KYPhotoGallery ()

@property(nonatomic,strong)UIView *fadeView;
@property(nonatomic,strong)UIImageView *initialImageView;

@end

@implementation KYPhotoGallery

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //黑色背景
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
    [self.view addSubview:self.initialImageView];
    
    

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        _fadeView.backgroundColor = [UIColor blackColor];
    } completion:nil];
}

- (void)buttonTaped:(UIButton *)button{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
