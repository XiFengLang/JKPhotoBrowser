//
//  JKPhotoPageIndicator.h
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2021/4/27.
//  Copyright © 2021 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 可添加UIControlEventTouchUpInside事件监听点击分页，
/// 自身不带UI样式，由子类实现
@interface JKPageControl : UIControl

/// default is 0
@property (nonatomic, assign) long numberOfPages;

/// default is 0. Value is pinned to 0..numberOfPages-1
@property (nonatomic, assign) long currentPage;

/// hides the indicator if there is only one page, default is YES
@property (nonatomic) BOOL hidesForSinglePage;

/// The tint color for non-selected indicators. Default is nil.
@property (nullable, nonatomic, strong) UIColor *pageIndicatorTintColor;

/// The tint color for the currently-selected indicators. Default is nil.
@property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor;

- (void)loadSubviews NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
