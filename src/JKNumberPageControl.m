//
//  JKNumberPageControl.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2021/4/27.
//  Copyright © 2021 溪枫狼. All rights reserved.
//

#import "JKNumberPageControl.h"
#import <Masonry/Masonry.h>

@interface JKNumberPageControl ()

@property (nonatomic, strong) UILabel * numLabel;

@end


@implementation JKNumberPageControl

- (void)loadSubviews {
    [super loadSubviews];
    
    self.numLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.numLabel.backgroundColor = UIColor.clearColor;
    self.numLabel.textAlignment = 1;
    self.numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self addSubview:self.numLabel];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}



- (void)refreshPageNumber {
    __auto_type attributedText = [[NSMutableAttributedString alloc] init];
    
    UIColor * textColor = self.currentPageIndicatorTintColor ?: UIColor.clearColor;
    NSString * text = @(self.currentPage + 1).stringValue;
    NSAttributedString * currentPage = [[NSAttributedString alloc] initWithString:text attributes:@{
        NSForegroundColorAttributeName:textColor,NSFontAttributeName:self.numLabel.font}];
    
    textColor = self.pageIndicatorTintColor ?: UIColor.clearColor;
    text = [NSString stringWithFormat:@"/%ld",self.numberOfPages];
    
    NSAttributedString * count = [[NSAttributedString alloc] initWithString:text attributes:@{
        NSForegroundColorAttributeName:textColor,NSFontAttributeName:self.numLabel.font}];
    [attributedText appendAttributedString:currentPage];
    [attributedText appendAttributedString:count];
    
    self.numLabel.attributedText = attributedText;
}


#pragma mark - setter

- (void)setCurrentPage:(long)currentPage {
    [super setCurrentPage:currentPage];
    [self refreshPageNumber];
}

- (void)setNumberOfPages:(long)numberOfPages {
    [super setNumberOfPages:numberOfPages];
    [self refreshPageNumber];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    [super setCurrentPageIndicatorTintColor:currentPageIndicatorTintColor];
    [self refreshPageNumber];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    [super setPageIndicatorTintColor:pageIndicatorTintColor];
    [self refreshPageNumber];
}

@end
