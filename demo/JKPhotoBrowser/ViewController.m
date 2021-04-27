//
//  ViewController.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 17/2/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+JK.h"
#import "MomentsViewController.h"
#import "ChatViewController.h"

#import "JKHUDManager.h"

#import "JKPhotoBrowser.h"
#import "JKSystemPageControl.h"
#import "JKNumberPageControl.h"

#import "JKViewController.h"

@interface ViewController () <JKPhotoManagerDelegate>

@property (nonatomic, copy) NSArray * imageModels;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _statusBarStyle = UIStatusBarStyleDefault;
    
    //    NSLog(@"%@",[UIApplication sharedApplication].jk_declaredInstanceVariables);
    
    CGFloat margin = 10.0f;
    CGFloat width = (CGRectGetWidth(UIScreen.mainScreen.bounds) - 40) / 3.0 ;
    
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    NSMutableArray * mutArray = [NSMutableArray array];
    
    for (NSInteger index = 1; index < 10; index ++) {
        NSString * imageName = [NSString stringWithFormat:@"img%zd.jpg",index];
        UIImage * image = [UIImage imageNamed:imageName];
        
        CGFloat x = (margin + width) * ((index -1) % 3 + 1) - width;
        CGFloat y = 100 + ((index - 1) / 3) * (margin + width);
        
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        imageView.tag = index;
        [self.view addSubview:imageView];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
        JKPhotoModel * model = [JKPhotoModel modelWithImageView:imageView
                                                      imageSize:image.size
                                                    smallPicUrl:imageName
                                                      indexPath:indexPath
                                                    contentView:self.view];
        [mutArray addObject:model];
    }
    
    self.imageModels = mutArray.copy;
    
}

- (void)clickedImageView:(UITapGestureRecognizer *)tap {
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
}

/// 将图片保存到相册的结果回调
- (void)jk_handleImageWriteToSavedPhotosAlbumWithError:(NSError *)error {
    if (error) {
        /// UIAlertController的windowLevel不够高，显示不了，所以要用自定义的HUD，添加到JKPhotoBrowser().conetntView上显示
        [HUDManager() showHUDInView:JKPhotoBrowser().jk_contentView detail:@"图片保存失败"];
    } else {
        [HUDManager() showHUDInView:JKPhotoBrowser().jk_contentView detail:@"已保存到相册"];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return false;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
