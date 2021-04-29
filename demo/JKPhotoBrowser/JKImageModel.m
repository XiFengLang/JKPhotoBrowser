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
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487580951536&di=31cf1044b15185349f6794951ac29304&imgtype=0&src=http%3A%2F%2Fimg.iecity.com%2FUpload%2FFile%2F201509%2F14%2F20150914124440787.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487580820769&di=bc4d6b8728d33a6392750a1f6a36c5b7&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F314e251f95cad1c85b987e87793e6709c93d516b.jpg",
                         @"https://tvax4.sinaimg.cn/large/6f8a2832gy1g61lq70rdmj21hc0u0tkw.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487580104270&di=6e885e021e36f78457f193f8c670201c&imgtype=0&src=http%3A%2F%2Ffun.youth.cn%2Fyl24xs%2F201701%2FW020170109614167518948.png",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487580164913&di=4dcb1131071ebf0beb6cc2a4c930491b&imgtype=0&src=http%3A%2F%2Fwww.11job.com%2Fdata%2Fupload%2Fkindeditor%2Fimage%2F20170119%2F20170119091748_28031.jpg",
                         @"https://p.moimg.net/project/2021/04/01/20210401_1617266018_8814.jpg?imageMogr2/auto-orient/strip?/width750/height2000",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487580217424&di=863012585bd5c4036ac048b53cef1822&imgtype=0&src=http%3A%2F%2Fimg.piaoliang.com%2Fuploads%2Fallimg%2F170204%2F145i0d12-2.jpg",
                         @"https://p.moimg.net/project/2021/04/02/20210402_1617352622_4910.jpeg?imageMogr2/auto-orient/strip?/width750/height2137",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487580525742&di=b0dd7d7481a62c88e06980fb9b4b98a8&imgtype=0&src=http%3A%2F%2Fjoymepic.joyme.com%2Fwiki%2Fimages%2Fxysw%2F6%2F68%2F%25E5%2586%25B7%25E9%2585%25B7%25E5%25A5%25B3%25E7%258B%2599%25E5%2587%25BB%25E6%2589%258B%25E6%259E%25AA%25E6%25B3%2595%25E7%25B2%25BE%25E5%2587%25867.jpg%3Fv%3D201611250947"];
    NSArray * sizes = @[
                        [NSValue valueWithCGSize:CGSizeMake(299, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(224, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(521, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(431, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(448, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(447, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(380, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(448, 299)],
                        [NSValue valueWithCGSize:CGSizeMake(532, 299)]];
    
    NSMutableArray * dataArray = [NSMutableArray array];
    for (NSInteger index = 0; index < images.count; index ++) {
        [dataArray addObject:[[JKImageModel alloc] initWithImageUrl:images[index] size:sizes[index]]];
    }
    return dataArray.copy;
}


@end
