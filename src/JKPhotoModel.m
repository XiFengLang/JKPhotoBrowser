//
//  JKPhotoModel.m
//  ZoomScrollView
//
//  Created by 蒋鹏 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "JKPhotoModel.h"

@implementation JKPhotoModel

+ (instancetype)modelWithImageView:(UIImageView *)imageView
                       smallPicUrl:(NSString *)smallPicUrl
                         indexPath:(NSIndexPath *)indexPath
                       contentView:(UIView *)contentView {
    return [self modelWithImageView:imageView
                          imageSize:CGSizeZero
                        smallPicUrl:smallPicUrl
                          indexPath:indexPath
                        contentView:contentView];
}

+ (instancetype)modelWithImageView:(UIImageView *)imageView
                         imageSize:(CGSize)imageSize
                       smallPicUrl:(NSString *)smallPicUrl
                         indexPath:(NSIndexPath *)indexPath
                       contentView:(UIView *)contentView {
    JKPhotoModel * model = [[JKPhotoModel alloc]init];
    model.imageView = imageView;
    model.smallPicurl = smallPicUrl;
    model.indexPath = indexPath;
    model.contentView = contentView;
    model.imageSize = imageSize;
    return model;
}

- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}

@end
