//
//  JKPhoneBrowserFunction.h
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2020/3/11.
//  Copyright © 2020 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 内部函数
@interface JKPhoneBrowserFunction : NSObject

/// 16进制色值
FOUNDATION_EXPORT UIColor * JKPhotoManager_Color(long hexValue);
/// 屏宽pt
FOUNDATION_EXPORT CGFloat JKPhotoManager_ScreenWidth(void);
/// 屏高pt
FOUNDATION_EXPORT CGFloat JKPhotoManager_ScreenHeight(void);
/// 主window
FOUNDATION_EXPORT UIWindow * JKPhotoManager_KeyWindow(void);
/// statusBar高度
FOUNDATION_EXPORT CGFloat JKPhotoManager_StatusBarHeight(void);
/// ...
FOUNDATION_EXPORT CGSize JKPhotoManager_MainScreenSize(void);
/// 相对宽度(参考屏幕：iPhone11 Pro)
FOUNDATION_EXPORT CGFloat JKPhotoManager_AdaptiveW(CGFloat width);

@end

NS_ASSUME_NONNULL_END
