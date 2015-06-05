# KYElegantPhotoGallery
An elegant photo gallery. It will zoom from a thumb image and you can pan to dismiss it with cool animation.

The loading indicator component which I forked and customized is [Here](https://github.com/KittenYang/UCZProgressView)

<img src="http://ww4.sinaimg.cn/bmiddle/aa1f155cgw1esraezg38cg205s0ache0.gif" width="300px" />

`KYPhotoGallery.h`：

```objc
/*
 *
   @parm:  tappedImageView 当前点击的图片视图
   @parm:  imagesUrls   所有图片的URL链接
   @parm:  currentIndex 当前图片的序号，第一张图请传入1，第二张为2，以此类推...
*
*/
-(id)initWithTappedImageView:(UIImageView *)tappedImageView andImageUrls:(NSMutableArray *)imagesUrls andInitialIndex:(NSInteger )currentIndex;


/*
 *
   @property 所有需要显示的UIImageView
 *
 */
@property(nonatomic,strong)NSMutableArray *imageViewArray;


-(void)dismissPhotoGalleryAnimated:(BOOL)animated;
-(void)finishAsynDownload:(void(^)(void))finishAsynDownloadBlock;

```

##What it can do

###1.支持双击放大、pinch缩放

###2.支持长微博滑动

###3.支持手势滑动dismiss

###4.支持单击dismiss

##TODO

###1.滑动时显示自定义PageControl，并且显示总页数和当前页数

###2.增加长按保存



##How to use
```objc
    _photoGallery = [[KYPhotoGallery alloc]initWithTappedImageView:(UIImageView *)sender.view andImageUrls:self.bigImagesUrls andInitialIndex:sender.view.tag];
    _photoGallery.imageViewArray = self.imageViewArray;
    [_photoGallery finishAsynDownload:^{
        [self presentViewController:_photoGallery animated:NO completion:nil];
    }];
```


##[A brief intro of the pan-to-dismiss animation](http://kittenyang.com/function-animtion/):

I use two quadratic functions(二次函数) to generate two factors:**factorOfAngle** & **factorOfScale**. 

The **factorOfAngle** is the factor to make the view rotaton around the X axis,the **factorOfScale** of course is the factor to make view scale.And here are the graphs of **factorOfAngle** & **factorOfScale** blow.

###**factorOfAngle**

<img src="http://kittenyang.com/content/images/2015/Jun/Screen-Shot-2015-06-04-at-14-05-39.png" width="700px" />

<p align="center" >
   <img src="http://kittenyang.com/content/images/2015/Jun/CodeCogsEqn--1-.gif" width="150px" />
</p>


###**factorOfScale**

<img src="http://kittenyang.com/content/images/2015/Jun/Screen-Shot-2015-06-04-at-14-08-37.png" width="700px" />

<p align="center" >
   <img src="http://kittenyang.com/content/images/2015/Jun/CodeCogsEqn--2-.gif" width="150px" />
</p>




Then,put it to`currentPhoto.layer.transform`:

```objc
        CGFloat Y =MIN(SCROLLDISTANCE,MAX(0,ABS(transition.y)));
        factorOfAngle = MAX(0,-4/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-SCROLLDISTANCE));
        factorOfScale = MAX(0,-1/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-2*SCROLLDISTANCE));
        
        CATransform3D t = CATransform3DIdentity;
        t.m34  = 1.0/-1000;
        t = CATransform3DRotate(t,factorOfAngle*(M_PI/5), transition.y>0?-1:1, 0, 0);
        t = CATransform3DScale(t, 1-factorOfScale*0.2, 1-factorOfScale*0.2, 0);
        currentPhoto.layer.transform = t;

```



