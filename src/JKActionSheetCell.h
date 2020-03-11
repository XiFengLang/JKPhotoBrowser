//
//  JKActionSheetCell.h
//  JKActionSheet
//
//  Created by 蒋鹏 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhoneBrowserFunction.h"


typedef NS_ENUM(NSUInteger, JKActionSheetCellType) {
    JKActionSheetCellTypeDefault = 0,
    JKActionSheetCellTypeDestructive,
    JKActionSheetCellTypeCancel,
};

UIKIT_EXTERN const CGFloat JKActionSheetTableViewRowHeight;

@interface JKActionSheetCell : UITableViewCell


@property (nonatomic, strong) UILabel * jk_titleLabel;

- (void)configureCellWithTitle:(NSString *)title type:(JKActionSheetCellType)type;


@end
