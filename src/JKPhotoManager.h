//
//  JKPhotoManager.h
//  ZoomScrollView
//
//  Created by 蒋鹏 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPhotoModel.h"
#import "JKPhoneBrowserFunction.h"

NS_ASSUME_NONNULL_BEGIN


@class JKPhotoManager;
@protocol JKPhotoManagerDelegate <NSObject>
@optional

/// 返回占位图，一般是原来的小图
- (UIImage *)jk_placeholderImageAtIndex:(NSInteger)index;

/// 返回大图URL
- (NSString *)jk_bigImageUrlAtIndex:(NSInteger)index;

/// 将图片保存到相册的结果回调
/// @param error error description
- (void)jk_handleImageWriteToSavedPhotosAlbumWithError:(NSError * _Nullable)error;

///  处理二维码识别
/// @param QRCodeContent 二维码内容
- (void)jk_handleQRCodeRecognitionResult:(NSString *)QRCodeContent;

/// 展示图片浏览器(更改状态栏)
- (void)jk_phoneBrowserDidAppear;

/// 关闭图片浏览器(更改状态栏)
- (void)jk_phoneBrowserDidDisappear;

@end






@interface JKPhotoManager : NSObject


/**
 图片浏览器的contentView,可添加自定义的subView。
 
 默认视图结构如下：
    statusBar.superView
             ↓
        contentView
         ↙       ↘
 pageControl    collectionView
                    ↓
                  cells
                    ↓
                 scrollView
                    ↓
                 imageView
 
 */
@property (nonatomic, strong, readonly) UIView * jk_contentView;

/// 图片数据源
@property (nonatomic, copy, nonnull) NSArray <JKPhotoModel *> * jk_itemArray;

/// 当前第几张，默认0，即展示第一张
@property (nonatomic, assign) NSInteger jk_currentIndex;

/// 代理，返回占位图，一般是原来的小图
@property (nonatomic, weak) id<JKPhotoManagerDelegate> jk_delegate;

/// 展示pageController
@property (nonatomic, assign) BOOL jk_showPageController;

/// 是否需要识别二维码，默认YES
@property (nonatomic, assign) BOOL jk_QRCodeRecognizerEnable;


/// 底层的CollectionView是否正在滚动，如果正在滚动，说明已经响应了拖拽手势并且发生了被动偏移，此时
/// JKPhotoCollectionViewCell中的panGesture 不响应手势
@property (nonatomic, assign, readonly) BOOL jk_isContentViewScrolling;

/// 是否需要隐藏原始的imageView，default is YES，如果隐藏，拖拽的时候会出现空白
@property (nonatomic, assign) BOOL jk_hidesOriginalImageView;


/// 单例
+ (instancetype)sharedManager;

/// 显示图片浏览器
- (void)jk_showPhotoBrowser;

/// Push的时候调用，动态隐藏PhotoBrowser
- (void)jk_hidesPhotoBrowserWhenPushed;

/// 全局隐藏键盘和UIMenuController
- (void)jk_resignFirstResponderIfNeeded;

@end


static inline JKPhotoManager * JKPhotoBrowser() {
    return [JKPhotoManager sharedManager];
}

NS_ASSUME_NONNULL_END
