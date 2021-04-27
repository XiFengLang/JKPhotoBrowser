//
//  MomentsTableViewCell.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "MomentsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JKSystemPageControl.h"
#import "JKNumberPageControl.h"
#import "JKPhotoBrowser.h"

@interface MomentsTableViewCell () <JKPhotoManagerDelegate>

@property (nonatomic, strong) NSMutableArray * imageModels;

@property (nonatomic, copy) NSArray * models;

@end

@implementation MomentsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageModels = [NSMutableArray array];
        
        
        CGFloat margin = 10.0f;
        CGFloat width = (CGRectGetWidth(UIScreen.mainScreen.bounds) - 40) / 3.0 ;
        for (NSInteger index = 1; index < 10; index ++) {
            
            CGFloat x = (margin + width) * ((index -1) % 3 + 1) - width;
            CGFloat y = margin + ((index - 1) / 3) * (margin + width);
            
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 5;
            imageView.backgroundColor = [UIColor redColor];
            imageView.tag = index;
            imageView.hidden = YES;
            [self.contentView addSubview:imageView];
            
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
        }
        
    }return self;
}

- (void)configueCellWithImageModels:(NSArray <JKImageModel *> *)models tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    self.models = models;
    [self.imageModels removeAllObjects];
    
    [models enumerateObjectsUsingBlock:^(JKImageModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * imageView = [self.contentView viewWithTag:idx+1];
        imageView.hidden = NO;/// 根据图片数量去控制imageView的隐藏，我这全是9张，所以都显示
        
        JKPhotoModel * photoModel = [JKPhotoModel modelWithImageView:imageView
                                                           imageSize:model.imageSize.CGSizeValue
                                                         smallPicUrl:model.imageUrl
                                                           indexPath:indexPath
                                                         contentView:tableView];
        [self.imageModels addObject:photoModel];
        
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    }];
}

- (void)clickedImageView:(UITapGestureRecognizer *)tap {
    UIImageView * imageView = (UIImageView *)tap.view;
    JKPhotoBrowser().jk_itemArray = self.imageModels;
    JKPhotoBrowser().jk_currentIndex = imageView.tag - 1;
    
    JKNumberPageControl * pageIndicator = [[JKNumberPageControl alloc] init];
    pageIndicator.currentPageIndicatorTintColor = UIColor.whiteColor;
    pageIndicator.pageIndicatorTintColor = UIColor.darkGrayColor;
    pageIndicator.hidesForSinglePage = false;
    
    JKPhotoBrowser().jk_pageControl = pageIndicator;
    [[JKPhotoManager sharedManager] jk_showPhotoBrowser];
    JKPhotoBrowser().jk_delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


/**    返回大图URL    */
- (NSString *)jk_bigImageUrlAtIndex:(NSInteger) index {
    JKImageModel * model = self.models[index];
    return model.imageUrl;
}




/**
 将图片保存到相册的结果回调
 
 @param error 结果
 */
- (void)jk_handleImageWriteToSavedPhotosAlbumWithError:(NSError *) error {
    NSLog(@"%@",error);
}


/**
 处理二维码识别
 
 @param QRCodeContent 二维码内容
 */
- (void)jk_handleQRCodeRecognitionResult:(NSString *)QRCodeContent {
    NSLog(@"%@",QRCodeContent);
}

@end
