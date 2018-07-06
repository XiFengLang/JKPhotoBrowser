//
//  ChatTableViewCell.m
//  JKPhotoBrowser
//
//  Created by 蒋鹏 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ChatTableViewCell ()



@property (nonatomic, strong, ) NSIndexPath * indexPath;

@property (nonatomic, weak) JKImageModel * model;
@end

@implementation ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        _imgView = imageView;
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        [self.imgView addGestureRecognizer:tap];
    }return self;
}

- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didClickImageView:atIndexPath:)]) {
        [self.delegate didClickImageView:self.imgView atIndexPath:self.indexPath];
    }
}

- (void)configueCellWithImageModel:(JKImageModel *)model indexPath:(NSIndexPath *)indexPath {
    self.model = model;
    self.indexPath = indexPath;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    
    CGSize size = model.imageSize.CGSizeValue;
    CGFloat scale = size.width / size.height;
    CGFloat width = 200;
    CGFloat height = 200;
    if (scale > 1.0) {
        height = width / scale;
    } else {
        width = height * scale;
    }
    
    
    CGFloat x = indexPath.row % 2 ? 10 : [UIScreen mainScreen].bounds.size.width - 10 - width;
    self.imgView.frame = CGRectMake(x, 10, width, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
