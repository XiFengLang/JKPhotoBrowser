//
//  MomentsTableViewCell.h
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImageModel.h"

@interface MomentsTableViewCell : UITableViewCell

- (void)configueCellWithImageModels:(NSArray <JKImageModel *> *)models tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
