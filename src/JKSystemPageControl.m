//
//  JKSystemPageControl.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2021/4/27.
//  Copyright © 2021 溪枫狼. All rights reserved.
//

#import "JKSystemPageControl.h"
#import <Masonry/Masonry.h>

@interface JKSystemPageControl ()

@property (nonatomic, strong) UIPageControl * pageControl;

@end


@implementation JKSystemPageControl

- (void)loadSubviews {
    [super loadSubviews];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:self.bounds];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.userInteractionEnabled = false;
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    if (@available(iOS 14.0, *)) {
        _pageControl.backgroundStyle = UIPageControlBackgroundStyleProminent;
    }
    [self addSubview:self.pageControl];
    self.hidesForSinglePage = true;
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}






#pragma mark - setter

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    [super setHidesForSinglePage:hidesForSinglePage];
    self.pageControl.hidesForSinglePage = hidesForSinglePage;
}

- (void)setCurrentPage:(long)currentPage {
    [super setCurrentPage:currentPage];
    self.pageControl.currentPage = currentPage;
}

- (void)setNumberOfPages:(long)numberOfPages {
    [super setNumberOfPages:numberOfPages];
    self.pageControl.numberOfPages = numberOfPages;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    [super setCurrentPageIndicatorTintColor:currentPageIndicatorTintColor];
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    [super setPageIndicatorTintColor:pageIndicatorTintColor];
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}



@end
