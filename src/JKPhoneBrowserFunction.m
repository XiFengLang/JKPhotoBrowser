//
//  JKPhoneBrowserFunction.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2020/3/11.
//  Copyright © 2020 溪枫狼. All rights reserved.
//

#import "JKPhoneBrowserFunction.h"

@implementation JKPhoneBrowserFunction

inline UIColor * JKPhotoManager_Color(long hexValue) {
    long hex = hexValue & 0xFFFFFFFF;
    int a = (0xff000000 & hex) >> 24;
    int r = (0x00ff0000 & hex) >> 16;
    int g = (0x0000ff00 & hex) >> 8;
    int b = (0x000000ff & hex) >> 0;
    if (hex <= 0xFFFFFF) {
        return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1];
    } else {
        return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f];
    }
}

inline CGFloat JKPhotoManager_ScreenWidth(void) {
    return MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
}

inline CGFloat JKPhotoManager_ScreenHeight(void) {
    return MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
}

inline UIWindow * JKPhotoManager_KeyWindow(void) {
    NSArray <UIWindow *>* windows = [UIApplication sharedApplication].windows;
    __block UIWindow * visible = nil;
    [windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isKeyWindow && obj.isHidden == false) {
            visible = obj;
            *stop = true;
        }
    }];
    return visible ? visible : windows.lastObject;
}


inline CGFloat JKPhotoManager_StatusBarHeight(void) {
    if (@available(iOS 13.0, *)) {
        return CGRectGetHeight(JKPhotoManager_KeyWindow().windowScene.statusBarManager.statusBarFrame);
    } else {
        return CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    }
}

inline CGSize JKPhotoManager_MainScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}



inline CGFloat JKPhotoManager_AdaptiveW(CGFloat width) {
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return width * JKPhotoManager_ScreenWidth() / 768.0;
    } else {
        return width * JKPhotoManager_ScreenWidth() / 375.0;
    }
}


@end
