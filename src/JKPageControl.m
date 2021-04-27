//
//  JKPhotoPageIndicator.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2021/4/27.
//  Copyright © 2021 溪枫狼. All rights reserved.
//

#import "JKPageControl.h"
#import <Masonry/Masonry.h>

@interface JKPageControl ()

@property (nonatomic, strong) UIControl * bgControl;

@end

@implementation JKPageControl


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self loadSubviews];
    }return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self loadSubviews];
    }return self;
}

- (void)loadSubviews {
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    self.bgControl = [[UIControl alloc] initWithFrame:self.bounds];
    self.bgControl.backgroundColor = UIColor.clearColor;
    [self addSubview:self.bgControl];
    [self.bgControl addTarget:self action:@selector(bgControlClicked:event:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.hidesForSinglePage = true;
    
    [self.bgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}

- (void)bgControlClicked:(UIButton *)sender event:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:sender] anyObject];
    CGPoint point = [touch locationInView:sender];
    
    long index = self.currentPage;
    if (point.x <= CGRectGetWidth(sender.frame)/2.0) {
        if (self.currentPage > 0) index -= 1;
    } else {
        if (self.currentPage < (self.numberOfPages -1)) index += 1;
    }
    if (index != self.currentPage) {
        self.currentPage = index;
        [self sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    }
}


#pragma mark - Setter

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    if (hidesForSinglePage) {
        self.hidden = self.numberOfPages <= 1;
    } else {
        self.hidden = false;
    }
}

- (void)setNumberOfPages:(long)numberOfPages {
    long temp = numberOfPages;
    if (temp < 0) temp = 0;
    
    _numberOfPages = temp;
    self.hidesForSinglePage = self.hidesForSinglePage;
}

- (void)setCurrentPage:(long)currentPage {
    long temp = currentPage;
    if (temp < 0) {
        temp = 0;
    } else if (temp >= self.numberOfPages) {
        temp = self.numberOfPages - 1;
    }
    _currentPage = temp;
    
}

@end
