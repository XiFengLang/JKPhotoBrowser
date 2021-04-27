//
//  JKPhotoModel.h
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKPhotoModel : NSObject

/**    图片所在的imageView    */
@property (nonatomic, weak) UIImageView * imageView;

/**    图片的URL    */
@property (nonatomic, copy) NSString * smallPicurl;

/**    图片所在的tableViewCell / CollectionViewCell    */
@property (nonatomic, weak) UIView * cell API_DEPRECATED("Use .indexPath", ios(2.0, 3.0));

/**    图片所在的tableViewCell / CollectionViewCell的indexPath    */
@property (nonatomic, strong) NSIndexPath * indexPath;

/**    图片所在的TableView / CollectionView / View   */
@property (nonatomic, weak) UIView * contentView;

/**    图片的大小，默认屏幕的宽高    */
@property (nonatomic, assign) CGSize imageSize;



/**
 实例化JKPhotoBrowser用到的Model，绑定相关的imageView、imageUrl、cell、contentView
 
 @param imageView imageView description
 @param smallPicUrl smallPicUrl description
 @param indexPath  图片所在的tableViewCell / CollectionViewCell的indexPath
 @param contentView 图片所在的TableView / CollectionView / View
 @return model
 */
+ (instancetype)modelWithImageView:(UIImageView *)imageView
                       smallPicUrl:(NSString *)smallPicUrl
                         indexPath:(NSIndexPath *)indexPath
                       contentView:(UIView *)contentView;

+ (instancetype)modelWithImageView:(UIImageView *)imageView
                         imageSize:(CGSize)imageSize
                       smallPicUrl:(NSString *)smallPicUrl
                         indexPath:(NSIndexPath *)indexPath
                       contentView:(UIView *)contentView;

@end
