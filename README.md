# JKPhotoBrowser

`v1.2.0` `已适配iOS14` 

**图片浏览器，具备拖拽缩放、渐变效果**



主要针对聊天界面、朋友圈界面实现图片浏览功能，并且高仿微信即iOS10相册的动画效果。实现部分的代码比较复杂，不在此列出，请下载工程查看。


![gif](http://wx2.sinaimg.cn/mw690/c56eaed1gy1fetak5vwztg20ac0j37wk.gif)



## 主要代码如 ##

```Object-C
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
        JKPhotoModel * model = [JKPhotoModel modelWithImageView:imageView
                                                      imageSize:image.size
                                                    smallPicUrl:imageName
                                                      indexPath:indexPath
                                                    contentView:self.view];                                                                                                                                                                          
```

```Object-C
    UIImageView * imageView = (UIImageView *)tap.view;
    JKPhotoBrowser().jk_itemArray = self.imageModels;
    JKPhotoBrowser().jk_currentIndex = imageView.tag - 1;
    
    JKSystemPageControl * pageIndicator = [[JKSystemPageControl alloc] init];
    pageIndicator.currentPageIndicatorTintColor = UIColor.whiteColor;
    pageIndicator.pageIndicatorTintColor = UIColor.darkGrayColor;
    
    JKPhotoBrowser().jk_pageControl = pageIndicator;
    //    JKPhotoBrowser().jk_hidesOriginalImageView = YES;
    [[JKPhotoManager sharedManager] jk_showPhotoBrowser];
    JKPhotoBrowser().jk_delegate = self;
    JKPhotoBrowser().jk_QRCodeRecognizerEnable = YES;
```

```Object-C
/**    返回大图URL    */
- (NSString *)jk_bigImageUrlAtIndex:(NSInteger) index {
    JKImageModel * model = self.models[index];
    return model.imageUrl;
}



- (void)jk_handleImageWriteToSavedPhotosAlbumWithError:(NSError *)error {
	// ...
}

///  处理二维码识别
- (void)jk_handleQRCodeRecognitionResult:(NSString *)QRCodeContent {
    NSLog(@"%@",QRCodeContent);
    [JKPhotoBrowser() jk_hidesPhotoBrowserWhenPushed];
    [self.navigationController pushViewController:[JKViewController new] animated:YES];
}

/// 展示图片浏览器(更改状态栏)
- (void)jk_phoneBrowserDidAppear {
    self.statusBarStyle = UIStatusBarStyleLightContent;
}

/// 关闭图片浏览器(更改状态栏)
- (void)jk_phoneBrowserDidDisappear {
    self.statusBarStyle = UIStatusBarStyleDefault;
}
```

![gif](http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetakb98qvg20ac0j31l0.gif)![gif](http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetakiyd3gg20ac0j3qv9.gif)