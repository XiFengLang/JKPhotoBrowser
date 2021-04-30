//
//  JKImageModel.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKImageModel.h"

@implementation JKImageModel

- (instancetype)initWithImageUrl:(NSString *)imageUrl size:(NSValue *)size {
    if (self = [super init]) {
        _imageUrl = imageUrl;
        _imageSize = size;
    }return self;
}


+ (NSArray <JKImageModel *>*)models {
    NSArray * images = @[
                         @"https://alpha-img.mvmtv.com/article/2021-04-29/df98c8ba-dc79-34b4-2732-4dabdbaab257_540x296.webp?format=gif",
                         @"https://alpha-img.mvmtv.com/article/2021-04-29/98f059d1-bbe2-e21e-0bd9-a64a40c6fe11_540x296.webp?format=gif",
                         @"https://tvax4.sinaimg.cn/large/6f8a2832gy1g61lq70rdmj21hc0u0tkw.jpg",
                         @"https://image.uisdc.com/wp-content/uploads/2019/09/hs-20190903-4.jpg",
                         @"https://s2.luckincoffeecdn.com/luckywebrm/images/selfshop.jpg",
                         @"https://p.moimg.net/project/2021/04/01/20210401_1617266018_8814.jpg?imageMogr2/auto-orient/strip?/width750/height2000",
                         @"https://image.uisdc.com/wp-content/uploads/2019/09/uisdc-sy-20190903-1.jpg",
                         @"https://p.moimg.net/project/2021/04/02/20210402_1617352622_4910.jpeg?imageMogr2/auto-orient/strip?/width750/height2137",
                         @"https://image.uisdc.com/wp-content/uploads/2019/09/uisdc-sy-20190903-4.jpg"];
    NSArray * sizes = @[
                        [NSValue valueWithCGSize:CGSizeMake(540, 296)],
                        [NSValue valueWithCGSize:CGSizeMake(540, 296)],
                        [NSValue valueWithCGSize:CGSizeMake(1920, 1080)],
                        [NSValue valueWithCGSize:CGSizeMake(2480, 3508)],
                        [NSValue valueWithCGSize:CGSizeMake(1920, 243)],
                        [NSValue valueWithCGSize:CGSizeMake(750, 2000)],
                        [NSValue valueWithCGSize:CGSizeMake(700, 394)],
                        [NSValue valueWithCGSize:CGSizeMake(750, 2137)],
                        [NSValue valueWithCGSize:CGSizeMake(450, 449)]];
    
    NSMutableArray * dataArray = [NSMutableArray array];
    for (NSInteger index = 0; index < images.count; index ++) {
        [dataArray addObject:[[JKImageModel alloc] initWithImageUrl:images[index] size:sizes[index]]];
    }
    return dataArray.copy;
}


@end
