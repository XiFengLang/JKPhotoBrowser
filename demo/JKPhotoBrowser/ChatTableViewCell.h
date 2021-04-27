//
//  ChatTableViewCell.h
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImageModel.h"

@protocol ChatTableViewCellDelegate <NSObject>

- (void)didClickImageView:(UIImageView *)imageView atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, weak, readonly) UIImageView * imgView;

@property (nonatomic, weak) id<ChatTableViewCellDelegate> delegate;

- (void)configueCellWithImageModel:(JKImageModel *)model indexPath:(NSIndexPath *)indexPath;

@end
