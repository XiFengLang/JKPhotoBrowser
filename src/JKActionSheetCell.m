//
//  JKActionSheetCell.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKActionSheetCell.h"
#import <Masonry/Masonry.h>

@implementation JKActionSheetCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = JKPhotoManager_Color(0xFF1A1A1A);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JKPhotoManager_ScreenWidth(), 40)];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:JKPhotoManager_AdaptiveW(15)];
        self.titleLabel.textColor = JKPhotoManager_Color(0xFFC3C5C8);
        self.titleLabel.backgroundColor = UIColor.clearColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.height.mas_equalTo(20);
            make.right.left.mas_offset(0);
        }];
    }return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
