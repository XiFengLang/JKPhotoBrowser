# JKPhotoBrowser
高仿微信、iOS10相册的图片浏览器，具备拖拽缩放、渐变效果。

主要针对聊天界面、朋友圈界面实现图片浏览功能，并且高仿微信即iOS10相册的动画效果。实现部分的代码比较复杂，不在此列出，请下载工程查看。


![gif](http://wx2.sinaimg.cn/mw690/c56eaed1gy1fetak5vwztg20ac0j37wk.gif)



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

- (void)jk_handleQRCodeRecognitionResult:(NSString *)QRCodeContent {
    NSLog(@"%@",QRCodeContent);
    [JKPhotoBrowser() jk_hidesPhotoBrowserWhenPushed];
    [self.navigationController pushViewController:[JKViewController new] animated:YES];
}
```
![gif](http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetakb98qvg20ac0j31l0.gif)![gif](http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetakiyd3gg20ac0j3qv9.gif)