# KYElegantPhotoGallery
An elegant photo gallery. It will zoom from a thumb image and you can pan to dismiss it with cool animation.

The loading indicator component which I forked and customized is [Here](https://github.com/KittenYang/UCZProgressView)

<img src="demo.gif" width="300px" />

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

##How to use
```objc
    _photoGallery = [[KYPhotoGallery alloc]initWithTappedImageView:(UIImageView *)sender.view andImageUrls:self.bigImagesUrls andInitialIndex:sender.view.tag];
    _photoGallery.imageViewArray = self.imageViewArray;
    [_photoGallery finishAsynDownload:^{
        [self presentViewController:_photoGallery animated:NO completion:nil];
    }];
```

##Note:
I didn't add the double-tap to zoom feature,but you can learn how to implement the dismiss animation and the architecture:)

