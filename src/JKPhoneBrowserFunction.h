//
//  JKPhoneBrowserFunction.h
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2020/3/11.
//  Copyright © 2020 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKPhoneBrowserFunction : NSObject

FOUNDATION_EXPORT UIWindow * JKPhotoManager_KeyWindow(void);
FOUNDATION_EXPORT UIUserInterfaceIdiom JKPhotoManager_UserInterfaceIdiom(void);
FOUNDATION_EXPORT BOOL JKPhotoManager_iPhoneX(void);
FOUNDATION_EXPORT CGSize JKPhotoManager_MainScreenSize(void);



@end

NS_ASSUME_NONNULL_END
