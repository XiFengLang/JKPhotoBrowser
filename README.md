# JKPhotoBrowser
高仿微信、iOS10相册的图片浏览器，具备拖拽缩放、渐变效果。

主要针对聊天界面、朋友圈界面实现图片浏览功能，并且高仿微信即iOS10相册的动画效果。

![本地图片](https://github.com/XiFengLang/JKPhotoBrowser/blob/master/JKPhotoBrowser02.gif)
![本地图片](https://github.com/XiFengLang/JKPhotoBrowser/blob/master/JKPhotoBrowser03.gif)



## 主要代码如 ##

```Object-C
JKPhotoModel * photoModel = [JKPhotoModel modelWithImageView:imageView
                                                         smallPicUrl:model.imageUrl
                                                                cell:self
                                                         contentView:tableView];                                                                                                                                                                           
```

```Object-C
    UIImageView * imageView = (UIImageView *)tap.view;
    JKPhotoBrowser().jk_itemArray = self.imageModels;
    JKPhotoBrowser().jk_currentIndex = imageView.tag - 1;
    JKPhotoBrowser().jk_showPageController = YES;
    [[JKPhotoManager sharedManager] jk_showPhotoBrowser];
    JKPhotoBrowser().jk_delegate = self;
```

```Object-C
/**    返回大图URL    */
- (NSString *)jk_bigImageUrlAtIndex:(NSInteger) index {
    JKImageModel * model = self.models[index];
    return model.imageUrl;
}




/**
 将图片保存到相册的结果回调
 */
- (void)jk_handleImageWriteToSavedPhotosAlbumWithError:(NSError *) error {
    NSLog(@"%@",error);
}


/**
 处理二维码识别
 */
- (void)jk_handleQRCodeRecognitionResult:(NSString *)QRCodeContent {
    NSLog(@"%@",QRCodeContent);
}
```