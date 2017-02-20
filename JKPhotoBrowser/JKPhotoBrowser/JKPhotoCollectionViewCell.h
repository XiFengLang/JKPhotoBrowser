//
//  JKPhotoCollectionViewCell.h
//  ZoomScrollView
//
//  Created by 蒋鹏 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhotoModel.h"

@protocol JKPhotoCollectionViewCellDelegate <NSObject>
/**
 *  点击图片进行隐藏操作
 *
 *  @param visible   是否超出屏幕
 */
- (void)jk_didClickedImageView:(UIImageView *)imageView visible:(BOOL)visible;



/**
 退出的时候先隐藏pageControl
 */
- (void)jk_hidesPageControlIfNeed;



/**
 让容器View渐变透明

 @param alpha 透明度
 */
- (void)jk_makeContentViewTransparentWithAlpha:(CGFloat)alpha;


/**
 *  长按图片的代理
 *
 */
- (void)jk_didLongPressImageView:(UIImageView *)imageView;

@end



UIKIT_EXTERN NSString * const JKPhotoCollectionViewCellKey;

@interface JKPhotoCollectionViewCell : UICollectionViewCell


/**    用于缩放图片    */
@property (nonatomic, strong, readonly) UIScrollView * scrollView;


/**    手势响应代理    */
@property (nonatomic, weak) id<JKPhotoCollectionViewCellDelegate> delegate;




/**    刷新cell    */
- (void)refreshCellWithModel:(JKPhotoModel *)model
              collectionView:(UICollectionView *)collectionView
                 bigImageUrl:(NSString *)imageUrl
            placeholderImage:(UIImage *)placeholderImage
         isTheImageBeTouched:(BOOL)isTheImageBeTouched;


- (void)collectionViewWillDisplayCell;


- (void)collectionViewDidEndDisplayCell;

@end
