//
//  JKPhotoManager.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "JKPhotoManager.h"
#import "JKPhotoCollectionViewCell.h"
#import "JKActionSheet.h"


@interface JKPhotoManager () <
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
JKPhotoCollectionViewCellDelegate>


@property (nonatomic, strong)UICollectionView * collectionView;

/// 第一张图片会有放大的效果
@property (nonatomic, assign)BOOL isFirstTimeZoomImage;


@end

@implementation JKPhotoManager

+ (instancetype)sharedManager {
    static JKPhotoManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JKPhotoManager alloc]init];
    });
    return manager;
}


- (void)setJk_pageControl:(JKPageControl *)jk_pageControl {
    if (jk_pageControl == nil) {
        [_jk_pageControl removeFromSuperview];
    }
    _jk_pageControl = jk_pageControl;
    
    if (jk_pageControl == nil) {
        return;
    }
    
    BOOL isIPhoneX = AppleDevice.isNotchDesignStyle;
    CGFloat YAxis = JKPhotoManager_ScreenHeight() - (isIPhoneX ? 56 : 30);
    
    jk_pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    jk_pageControl.frame = CGRectMake(0, YAxis, JKPhotoManager_ScreenWidth(), 40);
    [jk_pageControl addTarget:self action:@selector(handlePageControlTapAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handlePageControlTapAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.jk_pageControl.currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    });
}


- (instancetype)init{
    if (self = [super init]) {
        _jk_itemArray = NSArray.array;
        _jk_QRCodeRecognizerEnable = YES;
        _jk_hidesOriginalImageView = YES;
        _jk_contentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        self.collectionView.backgroundColor = UIColor.clearColor;
        [self.collectionView registerClass:[JKPhotoCollectionViewCell class] forCellWithReuseIdentifier:JKPhotoCollectionViewCellKey];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.maximumZoomScale= 3.0;
        self.collectionView.pagingEnabled = YES;
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.isFirstTimeZoomImage = YES;
    }return self;
}


- (void)setJk_itemArray:(NSArray<JKPhotoModel *> *)jk_itemArray {
    _jk_itemArray = [jk_itemArray copy];
    self.isFirstTimeZoomImage = YES;
    [self.collectionView reloadData];
}

- (void)jk_showPhotoBrowser{
    if (self.jk_itemArray == nil || self.jk_itemArray.count == 0) {
        NSLog(@"<JKPhotoModel *> * jk_itemArray 是空数组");
        return;
    }
    if (self.jk_contentView.superview != nil) {
        /// 防止快速点击，重复弹出
        return;
    }
    
    [self jk_resignFirstResponderIfNeeded];
    
    /// iOS13之前：把View添加到statusBar.superview上，能遮盖statusBar，不能直接加到statusBar上，不然没法响应事件
    /// iOS13后，添加在Keywindow上
    self.jk_contentView.alpha = 1;
    if (@available(iOS 13.0, *)) {
        [JKPhotoManager_KeyWindow() addSubview:self.jk_contentView];
    } else {
        [[self jk_statusBar].superview addSubview:self.jk_contentView];
    }
    [self.jk_contentView addSubview:self.collectionView];
    
    UIPageControl * pageController = nil;
    if (self.jk_pageControl != nil) {
        [self.jk_contentView addSubview:self.jk_pageControl];
        
        self.jk_pageControl.numberOfPages = self.jk_itemArray.count;
        self.jk_pageControl.currentPage = self.jk_currentIndex;
    }
    
    self.collectionView.userInteractionEnabled = false;
    self.jk_contentView.autoresizesSubviews = NO;
    self.isFirstTimeZoomImage = YES;
    
    /// 根据index设置偏移
    //    [self.collectionView reloadData];
    
    [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.collectionView.frame) * self.jk_currentIndex, 0)];
    
    self.jk_contentView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0];
    pageController.alpha = 0.f;
    [UIView animateWithDuration:0.5 delay:0 options:7<<16 | 1<<2 animations:^{
        self.jk_contentView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:1.f];
        pageController.alpha = 1.f;
    } completion:^(BOOL finished) {
        self.collectionView.userInteractionEnabled = true;
        
        if ([self.jk_delegate respondsToSelector:@selector(jk_phoneBrowserDidAppear)]) {
            [self.jk_delegate jk_phoneBrowserDidAppear];
        }
    }];
    
    _jk_isContentViewScrolling = NO;
}


- (void)jk_hidesPhotoBrowserWhenPushed {
    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect tempFrame = self.jk_contentView.frame;
        tempFrame.origin.x -= tempFrame.size.width;
        self.jk_contentView.frame = tempFrame;
        
    } completion:^(BOOL finished) {
        [self jk_pictureViewClicked:nil visible:YES completion:^{
            CGRect tempFrame = self.jk_contentView.frame;
            tempFrame.origin.x += tempFrame.size.width;
            self.jk_contentView.frame = tempFrame;
        }];
    }];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _jk_isContentViewScrolling = YES;
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = CGRectGetWidth(scrollView.bounds);
    float scale = contentOffsetX / scrollViewWidth;
    /// 将展示第n页
    self.jk_currentIndex = (NSInteger)(scale + 0.5);
    if (scrollView.isTracking || scrollView.isDragging) {
        self.jk_pageControl.currentPage = self.jk_currentIndex;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _jk_isContentViewScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _jk_isContentViewScrolling = NO;
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView  numberOfItemsInSection:(NSInteger)section{
    return self.jk_itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JKPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:JKPhotoCollectionViewCellKey forIndexPath:indexPath];
    
    NSString * bigImageUrl = nil;
    if ([self.jk_delegate respondsToSelector:@selector(jk_bigImageUrlAtIndex:)]) {
        bigImageUrl = [self.jk_delegate jk_bigImageUrlAtIndex:indexPath.row];
    }
    
    UIImage * placeholder = nil;
    if ([self.jk_delegate respondsToSelector:@selector(jk_placeholderImageAtIndex:)]) {
        placeholder = [self.jk_delegate jk_placeholderImageAtIndex:indexPath.row];
    }
    
    cell.jk_hidesOriginalImageView = self.jk_hidesOriginalImageView;
    [cell refreshCellWithModel:self.jk_itemArray[indexPath.row]
                collectionView:collectionView
                   bigImageUrl:bigImageUrl
              placeholderImage:placeholder
           isTheImageBeTouched:self.isFirstTimeZoomImage];
    
    if (self.isFirstTimeZoomImage) {
        self.isFirstTimeZoomImage = NO;
    }
    
    cell.delegate = self;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(JKPhotoCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell collectionViewWillDisplayCell];
}

/// 消失后要把图片还原到1.0比例
- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(nonnull JKPhotoCollectionViewCell *)cell
    forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [cell.scrollView setZoomScale:1.0 animated:NO];
    [cell collectionViewDidEndDisplayCell];
}


#pragma mark - JKPhotoCollectionViewCellDelegate


/**
 移除视图
 */
- (void)jk_pictureViewClicked:(UIImageView *)imageView visible:(BOOL)visible completion:(void (^)(void))completion {
    
    [UIView animateWithDuration:0.25 delay:0 options:7<<16 animations:^{
        self.jk_contentView.alpha = 0;
    } completion:^(BOOL finished) {
        self.jk_QRCodeRecognizerEnable = YES;
        self.jk_hidesOriginalImageView = YES;
        
        self.jk_pageControl = nil;
        
        [self.jk_contentView removeFromSuperview];
        self.jk_itemArray = NSArray.new;
        [self.collectionView reloadData];
        [self.collectionView removeFromSuperview];
        
        if (completion) completion();
        
        if ([self.jk_delegate respondsToSelector:@selector(jk_phoneBrowserDidDisappear)]) {
            [self.jk_delegate jk_phoneBrowserDidDisappear];
        }
    }];
}


- (void)jk_hidesPageControlIfNeed {
    self.jk_pageControl = nil;
}

- (void)jk_didLongPressImageView:(UIImageView *)imageView{
    if (!imageView.image || CGSizeEqualToSize(imageView.image.size, CGSizeZero)) {
        return;
    }
    
    
    /// 保存到相册
    NSString * qrContent = self.jk_QRCodeRecognizerEnable ? [self jk_recognizeQRCodeFromImage:imageView.image] : nil;
    
    JKAction * saveAction = [JKAction actionWithTitle:@"保存图片到相册" selectionHandler:^(JKAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(imageView.image,self,@selector(image:didFinishCacheWithError:contextInfo:),NULL);
    }];
    JKAction * recognizeAction = [JKAction actionWithTitle:@"识别图中二维码" selectionHandler:^(JKAction * _Nonnull action) {
        if ([self.jk_delegate respondsToSelector:@selector(jk_handleQRCodeRecognitionResult:)]) {
            [self.jk_delegate jk_handleQRCodeRecognitionResult:qrContent];
        }
    }];
    NSArray * actions = qrContent ? @[saveAction, recognizeAction] : @[saveAction];
    
    UIView * view = self.jk_contentView.superview;
    JKActionSheet * actionSheet = [[JKActionSheet alloc] initWithFrame:view.bounds actions:actions];
    actionSheet.topCornerRadius = 24;
    [actionSheet showInView:view animated:true];
}


- (void)image:(UIImage*)image didFinishCacheWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if ([self.jk_delegate respondsToSelector:@selector(jk_handleImageWriteToSavedPhotosAlbumWithError:)]) {
        [self.jk_delegate jk_handleImageWriteToSavedPhotosAlbumWithError:error];
    }
}




#pragma mark - 拓展


/**
 识别图片中的二维码
 @param image 图片
 @return 二维码信息
 */
- (NSString *)jk_recognizeQRCodeFromImage:(UIImage *)image {
    CIDetector * detecter = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                               context:nil
                                               options:@{
                                                   CIDetectorAccuracy:CIDetectorAccuracyHigh
                                               }];
    @try {
        
        /// 如果有异常，此处会被断点捕获，继续运行即可
        NSArray<CIFeature *> * features = [detecter featuresInImage:[[CIImage alloc] initWithCGImage:image.CGImage]];
        if (features && features.count) {
            CIQRCodeFeature * feature = (CIQRCodeFeature *)features.firstObject;
            return feature.messageString;
        }
        return nil;
    } @catch (NSException *exception) {
        return nil;
    }
}



/**
 用KVC取statusBar，⚠️iOS13取出的statusBar不能用于展示
 
 @return statusBar
 */
- (UIView *)jk_statusBar {
    if (@available(iOS 13.0, *)) {
        @try {
            __auto_type statusBarManager = UIApplication.sharedApplication.keyWindow.windowScene.statusBarManager;
            typedef UIView * (* MessageSendFunc)(id, SEL);
            SEL selector = NSSelectorFromString([@"creat*&eLocalSta*&tusBar" stringByReplacingOccurrencesOfString:@"*&" withString:@""]);
            IMP imp = [statusBarManager methodForSelector:selector];
            MessageSendFunc invoke = (MessageSendFunc)imp;
            UIView * localStatusBar = invoke(statusBarManager, selector);
            
            selector = NSSelectorFromString(@"statusBar");
            imp = [localStatusBar methodForSelector:selector];
            invoke = (MessageSendFunc)imp;
            UIView * statusBar = invoke(localStatusBar, selector);
            /// 取出的localStatusBar.superView = nil，添加视图没法展示
            return statusBar.subviews.firstObject;
        } @catch (NSException *exception) {
            return JKPhotoManager_KeyWindow();
        }
    } else {
        return [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    }
}




/**
 注销第一响应者
 */
- (void)jk_resignFirstResponderIfNeeded{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil from:nil forEvent:nil];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}




@end
