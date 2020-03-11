//
//  JKPhotoManager.m
//  ZoomScrollView
//
//  Created by 蒋鹏 on 16/6/27.
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

/**
 *  第一张图片会有放大的效果
 */
@property (nonatomic, assign)BOOL isFirstTimeZoomImage;


@property (nonatomic, strong)UIPageControl * pageController;

/**
 *  监听ScrollView滚动减速
 */
@property (nonatomic, assign)BOOL didEndDecelerating;


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





- (UIPageControl *)pageController{
    if (!_pageController) {
        BOOL isIPhoneX = JKPhotoManager_iPhoneX();
        
        _pageController = [[UIPageControl alloc]init];
        _pageController.numberOfPages = 1;
        _pageController.hidesForSinglePage = YES;
        _pageController.frame = CGRectMake(0, CGRectGetHeight(UIScreen.mainScreen.bounds) - (isIPhoneX ? 46 : 40), CGRectGetWidth(UIScreen.mainScreen.bounds), 40);
        _pageController.backgroundColor = [UIColor clearColor];
        _pageController.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageController.pageIndicatorTintColor = [UIColor whiteColor];
        _pageController.userInteractionEnabled = YES;
        _pageController.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [_pageController addTarget:self action:@selector(handlePageControlTapAction) forControlEvents:UIControlEventTouchUpInside];
    }return _pageController;
}

- (void)handlePageControlTapAction {
    [self.collectionView setContentOffset:CGPointMake(self.pageController.currentPage * self.collectionView.bounds.size.width, 0) animated:YES];
}


- (instancetype)init{
    if (self = [super init]) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        _jk_itemArray = NSArray.array;
        _jk_QRCodeRecognizerEnable = YES;
        _jk_hidesOriginalImageView = YES;
        _jk_contentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.jk_keyWindow.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor blackColor];
        [collectionView registerClass:[JKPhotoCollectionViewCell class] forCellWithReuseIdentifier:JKPhotoCollectionViewCellKey];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.maximumZoomScale= 3.0;
        collectionView.pagingEnabled = YES;
        _collectionView = collectionView;
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.isFirstTimeZoomImage = YES;
        self.jk_showPageController = NO;
    }return self;
}


- (void)jk_showPhotoBrowser{
    if (self.jk_itemArray == nil || self.jk_itemArray.count == 0) {
        NSLog(@"<JKPhotoModel *> * jk_itemArray 是空数组");
        return;
    }
    
    self.jk_contentView.alpha = 1.0;
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [self jk_resignFirstResponderIfNeeded];
    
    /// iOS13之前：把View添加到statusBar.superview上，能遮盖statusBar，不能直接加到statusBar上，不然没法响应事件
    /// iOS13后，添加在Keywindow上
    if (@available(iOS 13.0, *)) {
        [[self jk_keyWindow] addSubview:self.jk_contentView];
    } else {
        [[self jk_statusBar].superview addSubview:self.jk_contentView];
    }
    [self.jk_contentView addSubview:self.collectionView];
    
    if (self.jk_showPageController) {
        [self.jk_contentView addSubview:self.pageController];
        self.pageController.numberOfPages = self.jk_itemArray.count;
        self.pageController.currentPage = self.jk_currentIndex;
        self.pageController.hidden = NO;
        
    } else if (nil != _pageController) {
        [self.pageController removeFromSuperview];
        self.pageController = nil;
    }
    
    self.jk_contentView.backgroundColor = [UIColor blackColor];
    self.jk_contentView.userInteractionEnabled = YES;
    self.isFirstTimeZoomImage = YES;
    
    self.jk_contentView.autoresizesSubviews = NO;
    
    /// 根据index设置偏移
    [self.collectionView setContentOffset:CGPointMake(self.jk_currentIndex* [UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    [self.collectionView reloadData];
    _jk_isContentViewScrolling = NO;
}


- (void)jk_hidesPhotoBrowserWhenPushed {
    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect tempFrame = self.jk_contentView.frame;
        tempFrame.origin.x -= tempFrame.size.width;
        self.jk_contentView.frame = tempFrame;
        
    } completion:^(BOOL finished) {
        [self jk_didClickedImageView:nil visible:YES completion:^{
            CGRect tempFrame = self.jk_contentView.frame;
            tempFrame.origin.x += tempFrame.size.width;
            self.jk_contentView.frame = tempFrame;
        }];
    }];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _jk_isContentViewScrolling = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _jk_isContentViewScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.didEndDecelerating = YES;
    _jk_isContentViewScrolling = NO;
    [self scrollViewObservedDidChangePageWithOffsetX:scrollView.contentOffset.x];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.didEndDecelerating = NO;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.didEndDecelerating) {
        CGFloat index = scrollView.contentOffset.x/CGRectGetWidth(UIScreen.mainScreen.bounds);
        [self scrollViewObservedDidChangePageWithOffsetX:roundf(index)*CGRectGetWidth(UIScreen.mainScreen.bounds)];
    }
}

- (void)scrollViewObservedDidChangePageWithOffsetX:(CGFloat)offsetX{
    self.jk_currentIndex   = (NSInteger)(offsetX / CGRectGetWidth(UIScreen.mainScreen.bounds));
    if (self.jk_showPageController) {
        self.pageController.currentPage = self.jk_currentIndex;
    }
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
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
    
    if (self.isFirstTimeZoomImage ) {
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
- (void)jk_didClickedImageView:(UIImageView *)imageView visible:(BOOL)visible completion:(void (^)(void))completion {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.jk_contentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.jk_QRCodeRecognizerEnable = YES;
            self.jk_hidesOriginalImageView = YES;
            if (self.jk_showPageController) {
                [self.pageController removeFromSuperview];
            }
            
            [self.jk_contentView removeFromSuperview];
            self.jk_itemArray = NSArray.new;
            [self.collectionView reloadData];
            [self.collectionView removeFromSuperview];
            
            if (completion) {
                completion();
            }
        }
    }];
}


- (void)jk_hidesPageControlIfNeed {
    if (self.jk_showPageController) {
        self.pageController.hidden = YES;
    }
}


- (void)jk_makeContentViewTransparentWithAlpha:(CGFloat)alpha {
    self.jk_contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
    self.collectionView.backgroundColor = self.jk_contentView.backgroundColor;
}

- (void)jk_didLongPressImageView:(UIImageView *)imageView{
    if (!imageView.image || CGSizeEqualToSize(imageView.image.size, CGSizeZero)) {
        return;
    }
    
    
    /// 保存到相册
    
    NSString * qrContent = self.jk_QRCodeRecognizerEnable ? [self jk_recognizeQRCodeFromImage:imageView.image] : nil;
    
    JKActionSheet * actionSheet = [[JKActionSheet alloc] initWithCancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片到相册" otherButtonTitles:qrContent ? @[@"识别图中二维码"] : nil];
    
    [actionSheet showInView:self.jk_contentView.superview actionHandle:^(JKActionSheet * _Nonnull tempActionSheet, NSInteger index, NSString * _Nonnull buttonTitle) {
        if (index != tempActionSheet.cancelButtonIndex) {
            if (qrContent && [buttonTitle isEqualToString:@"识别图中二维码"]) {
                
                if ([self.jk_delegate respondsToSelector:@selector(jk_handleQRCodeRecognitionResult:)]) {
                    [self.jk_delegate jk_handleQRCodeRecognitionResult:imageView.accessibilityIdentifier];
                }
            } else {
                UIImageWriteToSavedPhotosAlbum(imageView.image,self,@selector(image:didFinishCacheWithError:contextInfo:),NULL);
            }
        }
    }];
    
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
    CIDetector * detecter = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
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
#ifdef __IPHONE_13_0
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
            return [self jk_keyWindow];
        }
    } else {
        return [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    }
#else
    return [[UIApplication sharedApplication] valueForKey:@"statusBar"];
#endif
}


/**
 遍历取window
 
 @return keyWindow
 */
- (UIWindow *)jk_keyWindow {
    UIWindow * windown = JKPhotoManager_KeyWindow();
    return windown ?: [UIApplication sharedApplication].keyWindow;
}


/**
 注销第一响应者
 */
- (void)jk_resignFirstResponderIfNeeded{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}




@end
