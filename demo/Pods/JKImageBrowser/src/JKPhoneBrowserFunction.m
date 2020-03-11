//
//  JKPhoneBrowserFunction.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2020/3/11.
//  Copyright © 2020 溪枫狼. All rights reserved.
//

#import "JKPhoneBrowserFunction.h"

@implementation JKPhoneBrowserFunction



inline UIWindow * JKPhotoManager_KeyWindow(void) {
    NSArray <UIWindow *>* windows = [UIApplication sharedApplication].windows;
    __block UIWindow * visible = nil;
    [windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isKeyWindow && obj.isHidden == false) {
            visible = obj;
            *stop = true;
        }
    }];
    return visible;
}

inline UIUserInterfaceIdiom JKPhotoManager_UserInterfaceIdiom(void) {
    if (@available(iOS 13.0, *)) {
        return [UIDevice.currentDevice userInterfaceIdiom];
    } else {
        return UI_USER_INTERFACE_IDIOM();
    }
}

inline BOOL JKPhotoManager_iPhoneX(void) {
    if (JKPhotoManager_UserInterfaceIdiom() != UIUserInterfaceIdiomPhone) {
        return false;
    } else {
        if (@available(iOS 11.0, *)) {
            if (@available(iOS 13.0, *)) {
                /// 44    iOS13 取UIApplication.sharedApplication.keyWindow可能不是主windown
                CGFloat statusBarHeight = CGRectGetHeight(JKPhotoManager_KeyWindow().windowScene.statusBarManager.statusBarFrame);
                return statusBarHeight > 43.f;
            } else {
                /// 44
                CGFloat topPadding = JKPhotoManager_KeyWindow().safeAreaInsets.top;
                return topPadding > 43.f;
            }
        } else {
            return false;
        }
    }
}


inline CGSize JKPhotoManager_MainScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}

@end
